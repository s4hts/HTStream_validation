# todo get the job memory and time somehow? sacct --format="CPUTime,MaxRSS,JobID,JobName"
# need to edit the job name on the fly

#if the array size wasnt right we need this
rm -rf 01-HTS_Preproc/_*

# create samples.txt based on all directories except phiX
ls --ignore="*phiX_*" 01-HTS_Preproc/ > samples.txt

# create phix_samples.txt
ls 01-HTS_Preproc/ | grep phiX > phix_samples.txt

# check the array size for when we call star_proc.slurm (maybe combine these two scripts)
array_1=`cat samples.txt | wc -l`
array_2=`cat phix_samples.txt | wc -l`

echo The STAR proc should have an array of $array_1
echo The Phix proc should have an array of $array_2
