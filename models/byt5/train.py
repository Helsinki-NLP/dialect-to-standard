from simplet5 import SimpleT5
import pandas
import sys

# load (supports t5, mt5, byT5 models)
model = SimpleT5()
model.from_pretrained("byt5","google/byt5-base")

train_df = pandas.read_csv(sys.argv[1], sep='\t')
train_df.head()
eval_df = pandas.read_csv(sys.argv[2], sep='\t')
eval_df.head()

model.train(train_df=train_df, # pandas dataframe with 2 columns: source_text & target_text
            eval_df=eval_df, # pandas dataframe with 2 columns: source_text & target_text
            source_max_token_len = 512,
            target_max_token_len = 512,
            batch_size = 4,
            max_epochs = 10,
            early_stopping_patience_epochs = 0,
            use_gpu = True,
            outputdir = sys.argv[3],
            precision = 32
            )
