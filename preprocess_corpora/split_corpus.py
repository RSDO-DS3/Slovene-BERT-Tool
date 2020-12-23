import argparse
import random

parser = argparse.ArgumentParser(description='Splits corpus into train, eval, test')
parser.add_argument('-i', '--input', help='input text file')
parser.add_argument('-o', '--output', help='output prefix')
parser.add_argument('--eval', type=float, default=0.005, help='eval ratio')
parser.add_argument('--test', type=float, default=0.005, help='test ratio')
parser.add_argument('--train', type=float, default=0.99, help='train ratio')
args = parser.parse_args()

with open(args.input, 'r') as reader, open(args.output+'.train', 'w') as train, open(args.output+'.eval', 'w') as eval, open(args.output+'.test', 'w') as test:
    for line in reader:
        r = random.random()
        if r < args.train:
            train.write(line)
        elif r < args.train + args.eval:
            eval.write(line)
        elif r < args.train + args.eval + args.test:
            test.write(line)
        
