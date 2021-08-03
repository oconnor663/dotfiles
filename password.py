#! /usr/bin/env python3

import secrets
import sys

if len(sys.argv) < 2:
    length = 10
else:
    length = int(sys.argv)

left = "qwertasdfgzxcv"
right = "poiuylkjhmnb"
on_left = secrets.choice([True, False])

password = ""
for _ in range(length):
    if on_left:
        password += secrets.choice(left)
    else:
        password += secrets.choice(right)
    on_left = not on_left

print(password)
