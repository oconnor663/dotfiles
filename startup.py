print("Jack's startup.py...")
from base64 import *
from binascii import *
from collections import *
from hashlib import *
from io import *
from math import *
from os import *
from re import *
from subprocess import *
from sys import *

try:
    from asyncio import *
except:
    pass

try:
    from pathlib import *
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

call(['stty', 'werase', 'undef'])
