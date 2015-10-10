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
readline.parse_and_bind('"\\C-w": backward-kill-word')
subprocess.call(['stty', 'werase', 'undef'])
