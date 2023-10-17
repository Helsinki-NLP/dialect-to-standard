#! /usr/bin/env python3

import sys

ini = sys.stdin.read()
ini = ini.replace('[distortion-limit]\n6','[distortion-limit]\n0')
for line in ini.strip().split('\n'):
	if line.startswith('Distortion') or line.startswith('LexicalReordering'):
		continue
	elif line.startswith('KENLM'):
		sys.stdout.write(line.replace('KENLM ', 'KENLM lazyken=0 ')+'\n')
	else:
		sys.stdout.write(line+'\n')
	
