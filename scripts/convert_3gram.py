#! /usr/bin/env python3

import sys, re, html

START = "^^"
END = "$$"
URL = "URL"
wordsep = "_"

def convert(infilename, outprefix):
	f = open(infilename, 'r')
	data = []
	sentence = [(START, START)]
	for line in f:
		if line.isspace():
			sentence.append((END, END))
			data.append(sentence)
			sentence = [(START, START)]
		else:
			elements = line.split("\t")
			if re.search(r'^https?://', elements[0]):
				sentence.append((URL, URL))
			else:
				w1 = " ".join(html.unescape(elements[0].strip()).replace(" ", wordsep))
				if len(elements) == 1:
					w2 = " "
				else:
					w2 = " ".join(html.unescape(elements[1].strip()).replace(" ", wordsep))
				sentence.append((w1, w2))
	if sentence != []:
		sentence.append((END, END))
		data.append(sentence)
	f.close()

	of1 = open(outprefix + ".src", 'w')
	of2 = open(outprefix + ".tgt", 'w')
	for sentence in data:
		for t1, t2, t3 in zip(sentence[:-2], sentence[1:-1], sentence[2:]):
			of1.write(" ".join([wordsep, t1[0], wordsep, t2[0], wordsep, t3[0], wordsep]) + "\n")
			of2.write(" ".join([wordsep, t1[1], wordsep, t2[1], wordsep, t3[1], wordsep]) + "\n")
	of1.close()
	of2.close()


if __name__ == "__main__":
	convert(sys.argv[1], sys.argv[2])
