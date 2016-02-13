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

# Python 2 does not define BrokenPipeError.
expected_errors = (KeyboardInterrupt, IOError)
if sys.version_info.major >= 3:
    expected_errors += (BrokenPipeError,)

try:
    for line in stdin:
        # Looks for lines of the form:
        #   ${ANSI color}commit abcdef...
        commit_regex = b"^(?P<color>(\x1b\\[\S*m)?)(?P<text>commit \w{40})"
        match = re.match(commit_regex, line)
        # Just print until we get to a matching line.
        if not match:
            stdout.write(line)
            continue

        # For a matching line, extract the color. Then, slurp up all the
        # following lines that don't start with a space. (Usually this is
        # Author and Date, but it can also include Merge.)
        commit_line = line
        color = match.group("color")
        commit_text = match.group("text")
        lines_to_box = [commit_text]

        while True:
            next_line = next(stdin)
            if next_line.startswith(b' ') or next_line.startswith(NEWLINE):
                # This is the end of the commit header lines. We'll need to
                # print this line after we've printed the header.
                break
            lines_to_box.append(next_line.strip())

        # Print all three lines in color, with a fancy box.
        width = max(len(line) for line in lines_to_box)
        stdout.write(color + TOPLEFT + TOP*width + TOPRIGHT + NEWLINE)
        for line in lines_to_box:
            padding = b' ' * (width - len(line))
            stdout.write(color + LEFT + line + padding + RIGHT + NEWLINE)
        stdout.write(color + BOTTOMLEFT + BOTTOM*width + BOTTOMRIGHT + NEWLINE)

        # Finally, print out the extra raw line we read above.
        stdout.write(next_line)

except expected_errors:
    sys.exit(1)
