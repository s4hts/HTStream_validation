# argv.py
import sys
import json
import os

script_name = sys.argv[0]
print("Name of the script: %s " % script_name)

in_file = sys.argv[1]
print("Arguments of the in file: %s" % in_file)

out_file = in_file + '.json'
print("Arguments of the output file : %s" % in_file + '.json')

file = open(in_file, 'r')
stat_dict = {}

for line in file:
    #print(line)
    line = line.split('\t')
    #line = [x.replace(' ', '') for x in line]
    print(line)
    if len(line)>1:
        stat = line[0].strip(' ').replace('|', '')
        num = line[1].replace(':', '').replace('\n', '').strip(' ')
        stat_dict[stat] = num
print(stat_dict)

with open(out_file, 'w') as fp:
    json.dump(stat_dict, fp)

os.system('cp %s %s' % (out_file, 'output/' + out_file.split('/')[-1]))
