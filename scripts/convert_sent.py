#! /usr/bin/env python3

import sys, argparse, re, html, random

wordsep = "_"

# redefine title to work with exploded strings
def title(s):
	return s[0].upper() + s[1:].lower()

def escape(s):
	return html.escape(s).replace("|", "&#124;")

def convertConstraints(splitfile, clsfile, outfilename):
	outf = open(outfilename, 'w')

	outline = [wordsep]
	for splline, clsline in zip(splitfile, clsfile):
		if splline.isspace():
			outf.write(" ".join(outline) + "\n")
			outline = [wordsep]
		else:
			if clsline.isspace():
				print("Space mismatch:", splline.strip(), "<>", clsline.strip())
			elements = splline.split("\t")
			if re.search(r'^https?://', elements[0]):
				outline += ["URL", wordsep]
			else:
				w1 = html.unescape(elements[0].strip())
				w1 = " ".join(list(w1.replace(" ", wordsep)))
				if clsline.strip() in ("KEEP", "equal"):
					outline += ['<np translation="{}">{}</np>'.format(escape(w1), escape(w1)), wordsep]
				elif clsline.strip() in ("TITLE", "title"):
					outline += ['<np translation="{}">{}</np>'.format(title(escape(w1)), escape(w1)), wordsep]
				elif clsline.strip() in ("UPPER", "upper"):
					outline += ['<np translation="{}">{}</np>'.format(escape(w1).upper(), escape(w1)), wordsep]
				elif clsline.strip() in ("LOWER", "lower"):
					outline += ['<np translation="{}">{}</np>'.format(escape(w1).lower(), escape(w1)), wordsep]
				elif clsline.strip() in ("CHANGE", "diff"):
					outline += [w1, wordsep]
				else:
					print("Unknown option, assuming difference:", clsline.strip())
					outline += [w1, wordsep]

	if len(outline) > 1:
		outf.write(" ".join(outline) + "\n")
	outf.close()


def convert(tweetfile, btfile, outprefix, mode, labels, shuffle):
	outdata = []
	outline1 = [wordsep]
	outline2 = [wordsep]
	for splline in tweetfile:
		if splline.isspace():
			outdata.append(("TWT", " ".join(outline1), " ".join(outline2)))
			outline1 = [wordsep]
			outline2 = [wordsep]
		else:
			elements = splline.split("\t")
			if re.search(r'^https?://', elements[0]):
				outline1 += ["URL", wordsep]
				outline2 += ["URL", wordsep]
			else:
				w1 = html.unescape(elements[0].strip())
				w1 = " ".join(list(w1.replace(" ", wordsep)))
				outline1 += [w1, wordsep]
				if len(elements) > 1:
					w2 = html.unescape(elements[1].strip())
					w2 = " ".join(list(w2.replace(" ", wordsep)))
					outline2 += [w2, wordsep]
				# else don't add anything to outline2
	if len(outline1) > 1:
		outdata.append(("TWT", " ".join(outline1), " ".join(outline2)))
	tweetfile.close()

	if btfile:
		for line in btfile:
			elements = line.strip().split("\t")
			if len(elements) == 2:
				outdata.append(("BT", elements[0], elements[1]))
		btfile.close()

	if mode == "dev":
		of1 = open("{}.src".format(outprefix), 'w')
		of2 = open("{}.tgt".format(outprefix), 'w')
	elif mode == "test":
		of1 = open("{}.src".format(outprefix), 'w')
	else:
		if shuffle:
			random.shuffle(outdata)
		of1 = open("{}.src".format(outprefix), 'w')
		of2 = open("{}.tgt".format(outprefix), 'w')
	
	for item in outdata:
		if labels:
			of1.write("<{}> {}\n".format(item[0], item[1]))
		else:
			of1.write("{}\n".format(item[1]))
		if mode != "test":
			of2.write("{}\n".format(item[2]))
	of1.close()
	if mode != "test":
		of2.close()
	
	if mode == "train_lm":
		lm1 = open("{}.lm1.tgt".format(outprefix), 'w')
		if btfile:
			lm2 = open("{}.lm2.tgt".format(outprefix), 'w')
		for item in outdata:
			if item[0] == "TWT":
				lm1.write(item[2] + "\n")
			elif btfile:
				lm2.write(item[2] + "\n")
		lm1.close()
		if btfile:
			lm2.close()


if __name__ == "__main__":
	argparser = argparse.ArgumentParser()
	argparser.add_argument("--twt-data", type=argparse.FileType('r'))
	argparser.add_argument("--bt-data", type=argparse.FileType('r'), default=None)
	argparser.add_argument("--constraints", type=argparse.FileType('r'), default=None)
	argparser.add_argument("--mode", type=str, choices=['train', 'train_lm', 'dev', 'test'])
	argparser.add_argument("--labels", action="store_true")
	argparser.add_argument("--shuffle", action="store_true")
	argparser.add_argument("--outprefix", type=str)
	args = argparser.parse_args()

	if args.constraints:
		if args.mode in ("train", "train_lm"):
			print("Constraints not supported at training time")
			sys.exit(1)
		if args.labels:
			print("Labels and constraints not implemented")
			sys.exit(1)
		outfilename = args.outprefix + ".src"
		convertConstraints(args.twt_data, args.constraints, outfilename)
	
	else:
		convert(args.twt_data, args.bt_data, args.outprefix, args.mode, args.labels, args.shuffle)
