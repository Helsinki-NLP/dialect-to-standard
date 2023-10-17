#! /usr/bin/env python3

import sys

# sentence = []
# for line in sys.stdin:
# 	s = line.replace(" ", "").strip()
# 	elem = [x for x in s.split("▁") if x != ""]
# 	for x in elem[1:-1]:
# 		sentence.append(x)
# 	if elem[-1] == "$$":
# 		t = " ".join(sentence)
# 		t = t.replace("_", " ")
# 		sys.stdout.write(t.strip() + "\n")
# 		sentence = []

sentence = []
for line in sys.stdin:
	if line.strip() == "":
		t = " ".join(sentence)
		t = t.replace("_", " ")
		sys.stdout.write(t.strip() + "\n")
		sentence = []
	else:
		elem = line.split("\t")
		if len(elem) > 1:
			sentence.append(elem[1].strip())
if sentence != []:
	t = " ".join(sentence)
	t = t.replace("_", " ")
	sys.stdout.write(t.strip() + "\n")
