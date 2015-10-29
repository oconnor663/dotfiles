print("Jack's startup.py...")
import math
import os
import re
import subprocess
import sys

try:
    import asyncio
except:
    pass

try:
    from pathlib import Path
except:
    pass

import readline
# Ctrl-W behavior more like Vim.
readline.parse_and_bind('"\\C-w": backward-kill-word')
# Prevent ctrl-p/ctrl-n/Up/Down from doing prefix searching in IPython.
readline.parse_and_bind('"\\C-p": previous-history')
readline.parse_and_bind('"\\C-n": next-history')
readline.parse_and_bind('"\\e[A": previous-history')
readline.parse_and_bind('"\\e[B": next-history')

subprocess.call(['stty', 'werase', 'undef'])
