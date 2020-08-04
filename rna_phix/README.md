##OLD NOTES:
add overlapper to RNA seq methodso
detailing applications is boring, intro some philosophy> apps and what they are meant to do.
discussion > impac, QA/QC, 
get bam file to spit out the name fo the gene and siisoalte from the non processed file. 
add the stuff from the github.io pages for s4hts

##TODO:
1. CHeck todo list in post_hts.slurm (need to get job memory and time)
1. HTS stats call have stats after every step
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

##MAYBE
12. Make sure all statements applicable to nanopore/pacbio as well in regards to hts

##METHODS:
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
8. 



##CHECKLIST OF APPS/MODULES TESTED
X = done
# = not done

1. X - adaptereval (Adapter eval above)
2. # - deduper (big one!)
3. X - qtrimmer (Star alignment above) (multiqc report for the effect on the reads to double check) (maybe deduper noise to$
4. X - ntrimmer (same as q trimmer)
5. X - polyatrim (same as n trimmer)
6. X - seqscreener (BWA mem alignment)


