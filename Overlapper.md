# Followed Methods in this paper
- download for bbmerge: 
- paper for bbmerge: BBMerge – Accurate paired shotgun read merging via overlap

## Synthetic data

1. Dowload the data:
- https://www.ncbi.nlm.nih.gov/nuccore/CM008962.1?report=fasta

2. Produce indexed reference sequence
    ```
    ./../tools/bbmap/bbmap.sh ref=chlamy_reference.fasta.qz
    ```

3. Generate Synthetic Reads
    ```
    ./../tools/bbmap/randomreads.sh reads=20m out=synth20m.fq.gz len=150 paired int pigz=32 zl=6 minq=14 midq=24 maxq=34 qv=6 adderrors=t nrate=0.00 maxns=2 maxnlen=8 ow mininsert=100 maxinsert=400 gaussian overlap=150 banns fragadapter=GACGCTGCCGACGAATAGAGAGGTGTAGATCTCGGTGGTCGCCGTATCATT fragadapter2=CCGAGCCCACGAGACTAAGGCGAATCTCGTATGCCGTCTTCTGCTTG
    ```

4. Rename read headers to know their insert size to allow for subsequent grading
    ```
    ./../tools/bbmap/rename.sh in=synth20m.fq.gz out=renamed20m.fq.gz renamebyinsert int
    ```
 
5. Reformat and store:
    ```
    ./../tools/bbmap/reformat.sh in=renamed20m.fq.gz out=/share/biocore/keith/benchmarking/data/r#.fq
    ```

## Real Shotgun Data

5. Download the data:
- https://genome.jgi.doe.gov/portal/pages/dynamicOrganismDownload.jsf?organism=MeCorS


6. Index the reference genomes
    ```
    ./..tools/bbmap/bbmap.sh ref=mock_ref.fa
    ```

7. shotgun metagenome reads were mapped to reference sequences to a) determine insert sizes, and b) to remove reads that mapped with indels or that did not map in a properly paired orientation

    ```
    ./..tools/bbmap/bbmap.sh in=mock_raw.fq.gz outm=mapped_renamed_noindels.fq.gz ow po indelfilter=0 renamebyinsert maxindel=20 minid=0.75
    ```

8. The remaining shotgun metagenome reads were subsampled to 20 million read pairs
    ```
    ./..tools/bbmap/reformat.sh in=clean.fq.gz out=20m.fq.gz srt=20m
    ```


# THIS IS WHERE TOOLS ARE RUN?
```
bbmerge.sh in=r#.fq out=merged_bbmerge.fq adapters=adapters.fa t=32
bbmerge-auto.sh in=r#.fq out=merged_bbmerge_rem.fq adapters=adapters.fa  t=32 rem k=62
bbmerge-auto.sh in=r#.fq out=merged_bbmerge_rsem.fq adapters=adapters.fa  t=32 rsem k=62
fastq-join -p 8 r1.fq r2.fq -o merged_fqj%.fq
flash -t 32 -x 0.25 -M 200 r1.fq r2.fq
hts_overlapper ....
```


9. Grading performed using grade merge
    ```
    ./..tools/bbmap/grademerge.sh in=merged.fq
    ```





10. Assembly quality was evaluated using raw shotgun metagenomic reads from MBARC-26 subsampled to 20 million read pairs
    ```
    ./..tools/bbmap/reformat.sh in = mock_raw.fq.gz out = r#.fq srt = 20m
    ```




## Not needed yet?

11. Reads were merged with each tool, then both the merged and unmerged output was passed to SPAdes v. 3.8.2 for assembly in metagenome mode

    ```
    spades.py—meta -k25,55,95,125—phred-offset 33 -s merged.fq -1 unmerged1.fq -2 unmerged2.fq -o spades_out
    ```   
    
12. Assembled contigs were compared to the metagenome reference using QUAST v. 4.2 for evaluation
    ```
    quast.py -o quast_out -R mock_ref.fa -f spades_*/contigs.fasta
    ```