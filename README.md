# HTStream_eval
PAPER: https://docs.google.com/document/d/1YMfAflWbbfXeZvZ2MNUlwyH6blz8bNIFIZq32S5zvUo/edit?usp=sharing

1. Overlapper.md contains some general methods for overlapper evaluation/comparison
    - TODO: update with new datasets (multiple)
    - Need gold standard for this dataset or just go based on mapping like Qtrimmer and Adapter Trimmer
2. NTrimmer_QTrimmer.md contains general methods for evaluation effecienct of Ntrimmer and quality trimming. 
    - TODO: finalize the datasets.. dig up code again 
    -
3. 

4.


for i in `ls SRR6048806_*/SRR6048806_*_Log.final.out`; do echo $i `cat $i`; done


samtools view -f 64 -F 2304 method1.bam | cut -f1,3,4 | LC_ALL=C sort -t '\t' -k1,1 > method1.txt
samtools view -f 64 -F 2304 method2.bam | cut -f1,3,4 | LC_ALL=C sort -t '\t' -k1,1 > method2.txt
join -t '\t' -1 1 -2 1 method1.txt method2.txt > R1.comparaison

forward_stranded_counts = featureCounts(bams, annot.ext = gff,      isGTFAnnotationFile=T,      GTF.attrType='ID',     GTF.featureType='gene',     minOverlap=27,     allowMultiOverlap=TRUE,     countMultiMappingReads=TRUE,     strandSpecific = 1,  #Only reads where R1 is forward W.R.T. the transcript are counted     isPairedEnd = TRUE,     nthreads = 7,     useMetaFeatures = TRUE     #Counts should be summarized by gene )  gcounts = forward_stranded_counts$counts[, 1:ncol(forward_stranded_counts$counts)] colnames(gcounts) = gsub('.bam', '', colnames(gcounts)) fscann = cbind(ann[match(rownames(gcounts), ann$gene), ], gcounts) write.table(fscann, file='forward_stranded_read_counts_by_gene.tsv', sep='\t', row.names=F, col.names=T)


gtf -> featureCounts
https://www.rdocumentation.org/packages/Rsubread/versions/1.22.2/topics/featureCounts

- htseq (bradleys project)
- run hts for phix dataset for super deduper to look at multiqc report
- should go up and flatten and curve
- check the super deduper code
- doing mapping for the rna seq workshop
- Suggestion:  Post Papers to Workshop on Slack, so we can create separate threads instead of on Zulip.