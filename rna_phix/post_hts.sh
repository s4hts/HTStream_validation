rm -rf 01-HTS_Preproc/_*
ls --ignore="*phiX_*" 01-HTS_Preproc/ > samples.txt
ls 01-HTS_Preproc/ | grep phiX > phix_samples.txt

array_1=`cat samples.txt | wc -l`
array_2=`cat phix_samples.txt | wc -l`

echo The STAR proc should have an array of $array_1
echo The Phix proc should have an array of $array_2
