import argparse

parser = argparse.ArgumentParser(description='Parse .vert files into .txt for training BERT/RoBERTa/ELMo models')
parser.add_argument('-i', '--input', help='Text file in vert format.')
parser.add_argument('-o', '--output', help='Output .txt path/filename.')
parser.add_argument('-b', '--bert', action='store_true', help='Keep empty lines between paragraphs (for BERT). Skip this option if using RoBERTa or ELMo.')
args = parser.parse_args()

with open(args.input, 'r') as reader, open(args.output, 'w') as writer:
    par = ''
    for line in reader:
        line = line.strip()
        if '<doc>' == line or '</doc>' == line or '<p>' == line or '<s>' == line:
            continue
        elif '</p>' == line:
            if args.bert:
                par += '\n'
            writer.write(par)
            par = ''
        elif '</s>' == line:
            par = par.strip()
            par += '\n'
        elif '<g/>' == line:
            par = par[:-1]
        else:
            par += line+' '
