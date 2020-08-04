#!/bin/bash

#SBATCH --job-name=star # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=200
#SBATCH --mem=32000 # Memory pool for all cores (see also --mem-per-cpu)
##SBATCH --partition=production
##SBATCH --reservation=workshop
##SBATCH --account=worksh8
#SBATCH --array=1-24
#SBATCH --output=slurmout/star_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/star_%A_%a.err # File to which STDERR will be written


start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" samples.txt`
REF="References/star.overlap100.gencode.v31"

inpath='/share/biocore/keith/benchmarking/scripts/rna/01-HTS_Preproc'
outpath='02-STAR_alignment'
[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"

module load star/2.7.0e

call="STAR
     --runThreadN 8 \
     --genomeDir $REF \
     --outSAMtype BAM SortedByCoordinate \
     --readFilesCommand zcat \
     --readFilesIn ${inpath}/${sample}/${sample}*1.fastq*.gz ${inpath}/${sample}/${sample}*2.fastq*.gz \
     --quantMode GeneCounts \
     --outFileNamePrefix ${outpath}/${sample}/${sample}_ \
     > ${outpath}/${sample}/${sample}-STAR.stdout 2> ${outpath}/${sample}/${sample}-STAR.stderr"

echo $call
eval $call


# do some handling using picard tools we want to run it on none and super deduper
if [[ ${sample} == *"_none"* ]] | [[ ${type} == *"deduper"* ]]; then

source activate /share/biocore/keith/benchmarking/eval
sample_new="${sample}_picardmarkdups"
[[ -d ${outpath}/${sample_new} ]] || mkdir ${outpath}/${sample_new}
call2 = "picard MarkDuplicates -I ${outpath}/${sample}/${sample}*.bam  -M ${outpath}/${sample_new}/${sample_new}.txt -O ${outpath}/${sample_new}/${sample_new}

echo $call2
eval $call2
fi

end=`date +%s`
runtime=$((end-start))
echo $runtime

