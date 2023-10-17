from simplet5 import SimpleT5
import pandas
import sys

train_df = pandas.read_csv(sys.argv[1], sep='\t')
eval_df = pandas.read_csv(sys.argv[2], sep='\t')

# load trained T5 model
model = SimpleT5()
model.load_model("byt5",sys.argv[5], use_gpu=True)

outfile = open(sys.argv[4], 'a')

with open(sys.argv[3]) as f:
	for line in f:
		out = model.predict(line)
		print(out[0], file=outfile)
