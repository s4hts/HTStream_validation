# HTStream Validation
PAPER: https://docs.google.com/document/d/1YMfAflWbbfXeZvZ2MNUlwyH6blz8bNIFIZq32S5zvUo/edit?usp=sharing

## TODO:
1. HTS std call have stats after every step
1. add more datasets because why not? (mrnaseq is looking pretty clean)
1. double check adapter trimmer reduction for all file type? Library prep?
1. Update htsream version
2. Fix master_parse.sh need to make for all datasets
3. ask about library prep part to put in the paper.
5. Add info about memory and time
6. Produce a pipeline DNA, RNA, Amplicon one, SE (no super deduper for SE)
7. Show algorithms do what they are supposed to do… some are straight forward.
8. Experimental validation, record parameters and use them to show consistency. (MDS plot) statistic for each tool -> info about sample
12. Make sure all statements applicable to nanopore/pacbio as well in regards to hts
13. Use HTS stream before and after each tool (like the other ones)
1. add overlapper to RNA seq methodso
1. detailing applications is boring, intro some philosophy> apps and what they are meant to do.
1. discussion > impac, QA/QC, 
1. get bam file to spit out the name fo the gene and siisoalte from the non processed file. 
1. add the stuff from the github.io pages for s4hts
1. Make sure all statements applicable to nanopore/pacbio as well in regards to hts?

## METHODS:

### In the `jupyter_notebookes` and `r_analysis` directories
1. Executable for analyzing data in the `rna_phix` output directories

### `multiqc_data` for storing multiqc reports
1. More info on the relevant report.

### In the `rna_phix` directory

1. ena/SAMPLES(from datasets.txt/phix_datasets.txt) -> runmaster.py runs hts_master.slurm ${type} ${datasets_file}
        - `python runmaster.py phix` OR/AND
        - `python runmaster.py rna`
        - output in 01-HTS_preproc

2. Clean up files since array doesnt match for phix and rna (whoops) create samples.txt and phix_samples.txt files and tells you array size needed for step 3$
        - `./post_hts.sh`

3. STAR alignment for rna type
        - adjust array based on output of `post_hts.sh`
        - `sbatch star_proc.slurm`
        - `./master_parse.sh` should be run will call parse_output.py for each of the files to get the .json files for each alignment.
        - TODO: fix parse_output.py and see how all json file get to the output directory.
        - jupyter notebook analysis for this


4. BWA Mem alignment for phix type (seq screener)
        - adjust array based on output of `post_hts.sh`
        - `sbatch phix_proc.slurm`
        - TODO some thing sfor getting the flgstats stuff

5. Adapter eval.py? (Using some bbmap scripts
        - `./randomreads.sh`
        - `./addadapters.sh`

6. Deduper eval.py/.R? (deduper but needed for overall methodology talk)
7. Primer eval.py (sampe as adapter eval?)
8. Overlapper (see `Overlapper.md)




## CHECKLIST OF APPS/MODULES TESTED
X = done
& = not done

1. X - adaptereval (Adapter eval above)
2. & # - deduper (big one!)
3. X - qtrimmer (Star alignment above) (multiqc report for the effect on the reads to double check) (maybe deduper noise to$
4. X - ntrimmer (same as q trimmer)
5. X - polyatrim (same as n trimmer)
6. X - seqscreener (BWA mem alignment)

## Extra notes from old markdown

1. Overlapper.md contains some general methods for overlapper evaluation/comparison
    - TODO: update with new datasets (multiple)
    - Need gold standard for this dataset or just go based on mapping like Qtrimmer and Adapter Trimmer
2. NTrimmer_QTrimmer.md contains general methods for evaluation effecienct of Ntrimmer and quality trimming. 
    - TODO: finalize the datasets.. dig up code again 


`for i in `ls SRR6048806_*/SRR6048806_*_Log.final.out`; do echo $i `cat $i`; done`

```
samtools view -f 64 -F 2304 method1.bam | cut -f1,3,4 | LC_ALL=C sort -t '\t' -k1,1 > method1.txt
samtools view -f 64 -F 2304 method2.bam | cut -f1,3,4 | LC_ALL=C sort -t '\t' -k1,1 > method2.txt
join -t '\t' -1 1 -2 1 method1.txt method2.txt > R1.comparaison
```

```
forward_stranded_counts = featureCounts(bams, annot.ext = gff,      isGTFAnnotationFile=T,      GTF.attrType='ID',     GTF.featureType='gene',     minOverlap=27,     allowMultiOverlap=TRUE,     countMultiMappingReads=TRUE,     strandSpecific = 1,  #Only reads where R1 is forward W.R.T. the transcript are counted     isPairedEnd = TRUE,     nthreads = 7,     useMetaFeatures = TRUE     #Counts should be summarized by gene )  gcounts = forward_stranded_counts$counts[, 1:ncol(forward_stranded_counts$counts)] colnames(gcounts) = gsub('.bam', '', colnames(gcounts)) fscann = cbind(ann[match(rownames(gcounts), ann$gene), ], gcounts) write.table(fscann, file='forward_stranded_read_counts_by_gene.tsv', sep='\t', row.names=F, col.names=T)
```

- gtf -> featureCounts
- https://www.rdocumentation.org/packages/Rsubread/versions/1.22.2/topics/featureCounts
- htseq (bradleys project)
- run hts for phix dataset for super deduper to look at multiqc report
- should go up and flatten and curve
- check the super deduper code
- doing mapping for the rna seq workshop
- Suggestion:  Post Papers to Workshop on Slack, so we can create separate threads instead of on Zulip.
