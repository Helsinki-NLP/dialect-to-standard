#! /usr/bin/env python3

import sys

for line in sys.stdin:
	s = line.strip().replace(" ", "")
	s = s.replace("_", " ")
	sys.stdout.write(s.strip() + "\n")
