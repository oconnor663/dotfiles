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

const ARROW: &str = "";

// This helps Zsh cursor control understand that color codes don't take up space.
// https://superuser.com/a/893926/93400
fn zsh_escape_code_start() {
    print!("%{{");
}

fn zsh_escape_code_end() {
    print!("%}}");
}

fn color_reset() {
    zsh_escape_code_start();
    print!("\x1b[0m");
    zsh_escape_code_end();
}

// https://chrisyeh96.github.io/2020/03/28/terminal-colors.html
fn fg_color((r, g, b): Color) {
    zsh_escape_code_start();
    print!("\x1b[38;2;{};{};{}m", r, g, b);
    zsh_escape_code_end();
}

fn bg_color((r, g, b): Color) {
    zsh_escape_code_start();
    print!("\x1b[48;2;{};{};{}m", r, g, b);
    zsh_escape_code_end();
}

fn error_code() {
    if let Some(code) = std::env::args().skip(1).next() {
        if code != "0" {
            fg_color(RED);
            print!("{} ", code);
        }
    }
}

fn host() {
    if std::env::var_os("SSH_CONNECTION").is_some() {
        fg_color(VIOLET);
        print!("{} ", gethostname::gethostname().to_string_lossy());
    }
}

fn path() {
    let cwd = std::env::current_dir().unwrap();
    let home = dirs::home_dir().unwrap();
    fg_color(BLUE);
    if cwd == home {
        print!("~ ");
    } else if cwd.starts_with(&home) {
        print!("~/{} ", cwd.strip_prefix(&home).unwrap().to_string_lossy());
    } else {
        print!("{} ", cwd.to_string_lossy());
    }
}

fn git() {
    let toplevel = cmd!("git", "rev-parse", "--show-toplevel")
        .stderr_null()
        .unchecked()
        .read()
        .unwrap();
    if toplevel.is_empty() {
        // Not in a git repo.
        return;
    }
    fg_color(YELLOW);
    let branch = cmd!("git", "branch", "--show-current").read().unwrap();
    if !branch.is_empty() {
        // Got a branch name.
        print!("{} ", branch);
    } else {
        // No branch name. Print the current rev.
        let rev = cmd!("git", "rev-parse", "--short", "HEAD").read().unwrap();
        print!("({}) ", rev);
    }
    let git_dir = Path::new(&toplevel).join(".git");
    // https://stackoverflow.com/a/67245016/823869
    if git_dir.join("rebase-merge").exists() || git_dir.join("rebase-apply").exists() {
        print!("REBASE ");
    }
    if git_dir.join("MERGE_HEAD").exists() {
        print!("MERGE ");
    }
    if git_dir.join("CHERRY_PICK_HEAD").exists() {
        print!("PICK ");
    }
}

fn main() {
    let background = BASE2;
    bg_color(background);
    print!(" ");
    error_code();
    host();
    path();
    git();
    color_reset();
    fg_color(background);
    print!("{}", ARROW);
    color_reset();
    print!(" ");
}
