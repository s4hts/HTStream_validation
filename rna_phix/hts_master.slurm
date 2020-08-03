#!/bin/bash

#SBATCH --job-name=htstream # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=9
#SBATCH --time=900
#SBATCH --mem=3000 # Memory pool for all cores (see also --mem-per-cpu)
##SBATCH --partition=production
##SBATCH --reservation=workshop
##SBATCH --account=workshop
##SBATCH --array=1-3
#SBATCH --output=slurmout/htstream_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/htstream_%A_%a.err # File to which STDERR will be written

start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" ${2}`
type=$1
sample_nosuffix=${sample}
sample=${sample}_${type}
inpath='/share/biocore/keith/benchmarking/ena' 
outpath='01-HTS_Preproc'
[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"
echo "SAMPLE NO SUFFIX: ${sample_nosuffix}"
module load htstream/1.3.2


#TODO make all of these variables that I can put together..

if [[ ${type} == "seqscreener_phix" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'screen phix'  | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"

elif [[ ${type} == "seqscreener_rrna" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2*  -N 'initial stats' | \
      hts_SeqScreener -s References/human_rrna.fasta -r -A ${outpath}/${sample}/${sample}.json -N 'count the number of rRNA reads' | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"

elif [[ ${type} == "deduper" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_SuperDeduper -A ${outpath}/${sample}/${sample}.json -N 'remove PCR duplicates' | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"

elif [[ ${type} == "ntrimmer" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_NTrimmer -A ${outpath}/${sample}/${sample}.json 'remove any remaining N characters' | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"

elif [[ ${type} == "qtrimmer" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_QWindowTrim -A ${outpath}/${sample}/${sample}.json -N 'quality trim the ends of reads' | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"


elif [[ ${type} == "adaptertrimmer" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_AdapterTrimmer -A ${outpath}/${sample}/${sample}.json -N 'trim adapters'| \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"


elif [[ ${type} == "lengthfilter" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_LengthFilter -A ${outpath}/${sample}/${sample}.json -N 'remove reads < 50bp' -n -m 50 | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"


elif [[ ${type} == "polyatrim" ]]; then
call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_PolyATTrim --no-left --skip_polyT -A ${outpath}/${sample}/${sample}.json -N 'remove polyAT tails' | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"


elif [[ ${type} == "none" ]]; then
cp ${inpath}/${sample_nosuffix}*_1* ${outpath}/${sample}/${sample}_1.fastq.gz
cp ${inpath}/${sample_nosuffix}*_2* ${outpath}/${sample}/${sample}_2.fastq.gz


elif [[ ${type} == "std" ]]; then

call="hts_Stats -L ${outpath}/${sample}/${sample}.json -1 ${inpath}/${sample_nosuffix}*_1* -2 ${inpath}/${sample_nosuffix}*_2* -N 'initial stats' | \
      hts_SeqScreener -A ${outpath}/${sample}/${sample}.json -N 'screen phix'  | \
      hts_SeqScreener -s References/human_rrna.fasta -r -A ${outpath}/${sample}/${sample}.json -N 'count the number of rRNA reads' | \
      hts_SuperDeduper -A ${outpath}/${sample}/${sample}.json -N 'remove PCR duplicates' | \
      hts_AdapterTrimmer -A ${outpath}/${sample}/${sample}.json -N 'trim adapters'| \
      hts_PolyATTrim --no-left --skip_polyT -A ${outpath}/${sample}/${sample}.json -N 'remove polyAT tails' | \
      hts_QWindowTrim -A ${outpath}/${sample}/${sample}.json -N 'quality trim the ends of reads' | \
      hts_NTrimmer -A ${outpath}/${sample}/${sample}.json 'remove any remaining N characters' | \
      hts_LengthFilter -A ${outpath}/${sample}/${sample}.json -N 'remove reads < 50bp' -n -m 50 | \
      hts_Stats -A ${outpath}/${sample}/${sample}.json -f ${outpath}/${sample}/${sample} -N 'final stats'"


elif [[ ${type} == "skewerqtrim" ]]; then
module load skewer
call="skewer -Q 20 ${inpath}/${sample_nosuffix}*_1* \
		   ${inpath}/${sample_nosuffix}*_2* \
	-o ${outpath}/${sample}/${sample}"


elif [[ ${type} == "adapterremoval_adaptertrim" ]]; then
source activate /share/biocore/keith/benchmarking/eval
call="AdapterRemoval --file1 ${inpath}/${sample_nosuffix}*_1* \
	             --file2 ${inpath}/${sample_nosuffix}*_2* \
	             --basename ${outpath}/${sample}/${sample}"

fi

echo $call
eval $call


end=`date +%s`
runtime=$((end-start))
echo $runtime
