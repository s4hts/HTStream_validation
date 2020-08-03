module load multiqc/htstream.dev0
mkdir -p 02-HTS_multiqc_report
multiqc -i HTSMultiQC-cleaning-report -o 02-HTS_multiqc_report -l 01-HTS_Preproc/*_std*/*.json ./analysis_dir
