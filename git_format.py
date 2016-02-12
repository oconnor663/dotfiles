#! /usr/bin/env python

import os
import re
import sys

# We have to do everything in binary, because diffs can contain invalid
# unicode. Open our own streams instead of using sys.stdin/sys.stdout, so that
# we can catch BrokenPipeErrors ourselves.
stdin = os.fdopen(0, 'rb')
stdout = os.fdopen(1, 'wb')

TOPLEFT = '╭'.encode()
TOP = '─'.encode()
TOPRIGHT = '╮'.encode()
SIDE = '│'.encode()
BOTTOMLEFT = '╰'.encode()
BOTTOM = '─'.encode()
BOTTOMRIGHT = '╯'.encode()
NEWLINE = os.linesep.encode()

try:
    for line in stdin:
        # Looks for lines of the form:
        #   ${ANSI color}commit abcdef...
        commit_regex = b"^(?P<color>(\x1b\\[\S*m)?)(?P<text>commit \w{40})"
        match = re.match(commit_regex, line)
        # Just print any non-matching lines.
        if not match:
            stdout.write(line)
            continue
        # For matching lines, extract the color, and read the author and date
        # from the next two lines.
        commit_line = line
        color = match.group("color")
        commit_text = match.group("text")
        author_text = next(stdin).strip()
        date_text = next(stdin).strip()

        # Print all three lines in color, with a fancy box.
        width = max(len(commit_text), len(author_text), len(author_text))
        stdout.write(color + TOPLEFT + TOP*width + TOPRIGHT + NEWLINE)
        stdout.write(color + SIDE + commit_text +
                     b' '*(width-len(commit_text)) + SIDE + NEWLINE)
        stdout.write(color + SIDE + author_text +
                     b' '*(width-len(author_text)) + SIDE + NEWLINE)
        stdout.write(color + SIDE + date_text + b' '*(width-len(date_text)) +
                     SIDE + NEWLINE)
        stdout.write(color + BOTTOMLEFT + BOTTOM*width + BOTTOMRIGHT + NEWLINE)
except BrokenPipeError:
    sys.exit(1)
