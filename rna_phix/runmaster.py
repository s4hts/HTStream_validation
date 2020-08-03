import os
import sys

# pass either rna or phix (so far) to this script to call hts_master
try:
	analysis_type = sys.argv[1]
except:
	sys.stderr.write("No analysis type such as phix or rna given\n")
	sys.exit()

if analysis_type == 'rna':
	hts_types = ['std','ntrimmer','qtrimmer','deduper','lengthfilter','seqscreener_phix', 'polyatrim', 
		     'seqscreener_rrna', 'adaptertrim','skewerqtrim','none', 'adapterremoval_adaptertrim']
	file = 'datasets.txt'
elif analysis_type =='phix':
	file = 'phix_datasets.txt'
	hts_types = ['std','seqscreener_phix','adaptertrim', 'seqscreener_rrna', 'none']
else:
	sys.stderr.write('Must be either rna or phix arg\n')
	sys.exit()

lines_in_file = open(file, 'r').readlines()
number_of_lines = len(lines_in_file)



for type in hts_types:
    if number_of_lines > 1:
        call = 'sbatch --array=1-%s hts_master.slurm %s %s' % (number_of_lines, type, file)
    elif number_of_lines == 1:
        call = 'sbatch hts_master.slurm %s %s' % (type, file)
    else:
        sys.stderr.write('No lines in %s \n' %file)
    os.system(call)
