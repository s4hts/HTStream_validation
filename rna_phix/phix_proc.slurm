#!/bin/bash

#SBATCH --job-name=samphix # Job name
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=180
#SBATCH --mem=32000 # Memory pool for all cores (see also --mem-per-cpu)
##SBATCH --partition=production
##SBATCH --reservation=workshop
##SBATCH --account=worksh8
#SBATCH --array=1-8
#SBATCH --output=slurmout/samphix_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/samphix_%A_%a.err # File to which STDERR will be written


start=`date +%s`
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" phix_samples.txt`

inpath='/share/biocore/keith/benchmarking/scripts/rna/01-HTS_Preproc'
outpath='02-PHIX_alignment'
REF='/share/biocore/keith/benchmarking/scripts/rna/References/phix.fasta'
BAM='${outpath}/${sample}.bam'


[[ -d ${outpath} ]] || mkdir ${outpath}
[[ -d ${outpath}/${sample} ]] || mkdir ${outpath}/${sample}

echo "SAMPLE: ${sample}"

module load samtools
module load bwa
call="bwa mem -t 8 ${REF} ${inpath}/${sample_nosuffix}*_1* ${inpath}/${sample_nosuffix}*_2* | \
      samtools view -Sb - > ${BAM}"

echo $call
eval $call

call2="samtools flagstat ${BAM}
echo $call
eval $call


end=`date +%s`
runtime=$((end-start))
echo $runtime

