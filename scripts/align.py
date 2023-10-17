#! /usr/bin/env python3
# -*- coding: utf-8 -*-


import codecs, math, sys, os, re, html
import edlib


def getLevenAlignment(src, tgt, SEP):
	result = edlib.align(tgt, src, task='path')
	actions = [(int(x[0]), x[1]) for x in re.findall(r'(\d+)([XDI=])', result['cigar'])]
	if len(result['locations']) != 1:
		raise NotImplementedError
	if result['locations'][0][0] != 0 and result['locations'][0][1] != len(src)+2:
		raise NotImplementedError
	
	i, j = 0, 0
	count = 0
	data = []
	while True:
		if count == actions[0][0]:
			count = 0
			actions.pop(0)
		if len(actions) == 0:
			break

		if actions[0][1] == "D":
			data.append((src[i], actions[0][1], " "))
			count += 1
			i += 1
		elif actions[0][1] == "I":
			data.append((" ", actions[0][1], tgt[j]))
			count += 1
			j += 1
		else:
			data.append((src[i], actions[0][1], tgt[j]))
			count += 1
			i += 1
			j += 1
	
	words = []
	word_src, word_tgt = "", ""
	for x in data:
		if x[0] == SEP and x[2] == SEP:
			s = word_src.replace(' ', '').split(SEP)
			t = word_tgt.replace(' ', '').replace(SEP, ' ')
			words.append((s[0], t))
			for s2 in s[1:]:
				words.append((s2, ''))
			word_src, word_tgt = "", ""
		else:
			word_src += x[0]
			word_tgt += x[2]

	if word_src != "" or word_tgt != "":
		s = word_src.replace(' ', '').split(SEP)
		t = word_tgt.replace(' ', '').replace(SEP, ' ')
		words.append((s[0], t))
		for s2 in s[1:]:
			words.append((s2, ''))

	if words[0] == ('', ''):
		words.pop(0)
	if words[-1][0] == '':
		words.pop()
	return words


# SEGM_SEP: word separator in the segm files
# VERT_SEP: multi-word-token separator in the vert files
def retokenize(orig_segm, trans_segm, orig_vert, out_vert, SEGM_SEP="_", VERT_SEP=" ", split_trans=False):
	orig_segm_file = open(orig_segm, 'r')
	trans_segm_file = open(trans_segm, 'r')
	sentences = []
	for origsentence, transsentence in zip(orig_segm_file, trans_segm_file):
		origchars = origsentence.strip().split(" ")
		if split_trans:
			transchars = [SEGM_SEP] + list(transsentence.strip().replace(" ", SEGM_SEP)) + [SEGM_SEP]
		else:
			transchars = transsentence.strip().split(" ")
		wordpairs = getLevenAlignment(origchars, transchars, SEP=SEGM_SEP)
		if origchars.count(SEGM_SEP) - 1 != len(wordpairs):
			print("Alignment mismatch", origchars.count(SEGM_SEP)-1, len(wordpairs))
		sentences.append(wordpairs)
	orig_segm_file.close()
	trans_segm_file.close()

	orig_vert_file = open(orig_vert, 'r')
	orig_sentences = []
	sentence = []
	for line in orig_vert_file:
		if line.strip() == "" and len(sentence) > 0:
			orig_sentences.append(sentence)
			sentence = []
		else:
			w = line.strip().split("\t")[0]
			sentence.append(w)
	if len(sentence) > 0:
		orig_sentences.append(sentence)
	orig_vert_file.close()

	if len(sentences) != len(orig_sentences):
		print("Different number of sentences:", len(sentences), len(orig_sentences))
		return

	out_vert_file = open(out_vert, 'w')
	for origsent, transsent in zip(orig_sentences, sentences):
		for origword in origsent:
			temp_origword = ""
			normword = ""
			if origword == transsent[0][0]:
				normword = transsent.pop(0)[1]
			elif origword.startswith(transsent[0][0]):
				o, n = transsent.pop(0)
				temp_origword += o
				normword += n
				while len(temp_origword) < len(origword) and origword.startswith((temp_origword + VERT_SEP + transsent[0][0])):
					o, n = transsent.pop(0)
					temp_origword += VERT_SEP + o
					normword += VERT_SEP + n
				if temp_origword != origword:
					print("Word form mismatch:", origword, temp_origword, "==>", normword)
			out_vert_file.write("{}\t{}\n".format(origword, normword))
		out_vert_file.write("\n")
	out_vert_file.close()

if __name__ == "__main__":
	# orig_segm, trans_segm, orig_vert, out_vert, [--detokenized]
	if len(sys.argv) > 5 and sys.argv[5] == "--detokenized":
		retokenize(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], split_trans=True)
	else:
		retokenize(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
