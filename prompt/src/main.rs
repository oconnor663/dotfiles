use duct::cmd;
use std::path::Path;

type Color = (u8, u8, u8);

// Solarized RGB colors
pub const BASE03: Color = (0, 43, 54);
pub const BASE02: Color = (7, 54, 66);
pub const BASE01: Color = (88, 110, 117);
pub const BASE00: Color = (101, 123, 131);
pub const BASE0: Color = (131, 148, 150);
pub const BASE1: Color = (147, 161, 161);
pub const BASE2: Color = (238, 232, 213);
pub const BASE3: Color = (253, 246, 227);
pub const YELLOW: Color = (181, 137, 0);
pub const ORANGE: Color = (203, 75, 22);
pub const RED: Color = (220, 50, 47);
pub const MAGENTA: Color = (211, 54, 130);
pub const VIOLET: Color = (108, 113, 196);
pub const BLUE: Color = (38, 139, 210);
pub const CYAN: Color = (42, 161, 152);
pub const GREEN: Color = (133, 153, 0);

// This helps Zsh cursor control understand that color codes don't take up space.
// https://superuser.com/a/893926/93400
const ZSH_ESCAPE_CODE_START: &str = "%{";
const ZSH_ESCAPE_CODE_END: &str = "%}";

fn color_reset() -> String {
    format!("{}\x1b[0m{}", ZSH_ESCAPE_CODE_START, ZSH_ESCAPE_CODE_END)
}

// https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
fn fg_color((r, g, b): Color) -> String {
    format!(
        "{}\x1b[38;2;{};{};{}m{}",
        ZSH_ESCAPE_CODE_START, r, g, b, ZSH_ESCAPE_CODE_END,
    )
}

fn bg_color((r, g, b): Color) -> String {
    format!(
        "{}\x1b[48;2;{};{};{}m{}",
        ZSH_ESCAPE_CODE_START, r, g, b, ZSH_ESCAPE_CODE_END,
    )
}

fn error_code() -> Option<(String, Color)> {
    if let Some(code) = std::env::args().skip(1).next() {
        if code != "0" {
            return Some((code, RED));
        }
    }
    None
}

fn host() -> Option<(String, Color)> {
    if std::env::var_os("SSH_CONNECTION").is_some() {
        Some((gethostname::gethostname().to_string_lossy().into(), VIOLET))
    } else {
        None
    }
}

fn path() -> Option<(String, Color)> {
    let cwd = std::env::current_dir().unwrap();
    let home = dirs::home_dir().unwrap();
    let path: String = if cwd == home {
        "~".into()
    } else if cwd.starts_with(&home) {
        format!("~/{}", cwd.strip_prefix(&home).unwrap().to_string_lossy())
    } else {
        cwd.to_string_lossy().into()
    };
    Some((path, BLUE))
}

fn git() -> Option<(String, Color)> {
    let toplevel = cmd!("git", "rev-parse", "--show-toplevel")
        .stderr_null()
        .unchecked()
        .read()
        .unwrap();
    if toplevel.is_empty() {
        // Not in a git repo.
        return None;
    }
    let mut branch = cmd!("git", "branch", "--show-current").read().unwrap();
    if branch.is_empty() {
        // No branch name. Print the current rev.
        let rev = cmd!("git", "rev-parse", "--short", "HEAD").read().unwrap();
        branch = format!("({})", rev);
    }
    let git_dir = Path::new(&toplevel).join(".git");
    // https://stackoverflow.com/a/67245016/823869
    if git_dir.join("rebase-merge").exists() || git_dir.join("rebase-apply").exists() {
        branch += " REBASE";
    }
    if git_dir.join("MERGE_HEAD").exists() {
        branch += " MERGE"
    }
    if git_dir.join("CHERRY_PICK_HEAD").exists() {
        branch += " PICK";
    }
    Some((branch, CYAN))
}

fn main() {
    let text_color = BASE2;
    print!("{}", fg_color(text_color));
    let components: Vec<(String, Color)> = vec![error_code(), host(), path(), git()]
        .into_iter()
        .flatten()
        .collect();
    for i in 0..components.len() {
        let &(ref string, color) = &components[i];
        if i == 0 {
            print!(
                "{}{}{}",
                fg_color(color),
                fg_color(text_color),
                bg_color(color),
            );
        } else {
            let &(_, prev_color) = &components[i - 1];
            print!(
                "{}{}{} ",
                bg_color(color),
                fg_color(prev_color),
                fg_color(text_color)
            );
        }
        print!("{}", string);
    }
    let &(_, last_color) = components.last().unwrap();
    print!(
        "{}{}{} ",
        color_reset(),
        fg_color(last_color),
        color_reset(),
    );
}
