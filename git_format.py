#! /usr/bin/env python
# coding=utf8

import os
import re
import sys

# We have to do everything in binary, because diffs can contain invalid
# unicode. Open our own streams instead of using sys.stdin/sys.stdout, so that
# we can catch BrokenPipeErrors ourselves.
stdin = os.fdopen(0, 'rb')
stdout = os.fdopen(1, 'wb')

# Get all these bytes in a Python-2-compatible way.
TOPLEFT = u'╭─'.encode('utf8')
TOP = u'─'.encode('utf8')
TOPRIGHT = u'─╮'.encode('utf8')
LEFT = u'│ '.encode('utf8')
RIGHT = u' │'.encode('utf8')
BOTTOMLEFT = u'╰─'.encode('utf8')
BOTTOM = u'─'.encode('utf8')
BOTTOMRIGHT = u'─╯'.encode('utf8')
NEWLINE = os.linesep.encode('utf8')

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
        stdout.write(color + LEFT + commit_text +
                     b' '*(width-len(commit_text)) + RIGHT + NEWLINE)
        stdout.write(color + LEFT + author_text +
                     b' '*(width-len(author_text)) + RIGHT + NEWLINE)
        stdout.write(color + LEFT + date_text + b' '*(width-len(date_text)) +
                     RIGHT + NEWLINE)
        stdout.write(color + BOTTOMLEFT + BOTTOM*width + BOTTOMRIGHT + NEWLINE)
except BrokenPipeError:
    sys.exit(1)
