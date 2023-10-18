#! /usr/bin/env python3
import sys

def convertFile(infilename, outfilename):
	f1 = open(infilename, 'r')
	f2 = open(outfilename, 'w')
	f2.write("source_text\ttarget_text\n")
	origsent, normsent = [], []
	for line in f1:
		if line.strip() == "":
			if origsent != [] and normsent != []:
				f2.write(" ".join(origsent) + "\t" + " ".join(normsent) + "\n")
			origsent, normsent = [], []
		else:
			elements = line.split("\t")
			origsent.append(elements[0].strip())
			normsent.append(elements[1].strip())
	if origsent != [] and normsent != []:
		f2.write(" ".join(origsent) + "\t" + " ".join(normsent) + "\n")
	f1.close()
	f2.close()

if __name__ == "__main__":
	convertFile(sys.argv[1], sys.argv[2])
