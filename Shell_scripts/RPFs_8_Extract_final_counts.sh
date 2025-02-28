#!/usr/bin/env bash

#read in variables
source common_variables.sh

#set lengths and offsets. These are the final ones which you will use for any DE analysis or codon occupancy.
#Use the plots generated by the periodicity and offset scripts to decide what values to set these at

lengths='29,30,31,32,33'
offsets='12,12,13,13,13'

#run counting script to generate <.counts> files for both all and best alignments
for filename in $RPF_filenames
do
counting_script.py -bam $BAM_dir/${filename}_pc_best_sorted.bam -fasta $pc_fasta -len $lengths -offset $offsets -out_file ${filename}_pc_best_final.counts -out_dir $counts_dir &
counting_script.py -bam $BAM_dir/${filename}_pc_all_sorted.bam -fasta $pc_fasta -len $lengths -offset $offsets -out_file ${filename}_pc_all_final.counts -out_dir $counts_dir &
done
wait



