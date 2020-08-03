#!/bin/bash

rm -rf  output/*
mkdir output/logs


for i in `ls 02-STAR_alignment/*_*/*_*_Log.final.out`

do

    echo $i
    python parse_output.py $i
    cp $i output/logs/
done

