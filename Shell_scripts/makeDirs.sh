#!/usr/bin/env bash

#read in variables
source common_variables.sh

#make directories
mkdir $fastq_dir
mkdir $fastqc_dir
mkdir $SAM_dir
mkdir $BAM_dir
mkdir $log_dir
mkdir $counts_dir
mkdir $rsem_dir
mkdir $analysis_dir
mkdir $region_counts_dir
mkdir $spliced_counts_dir
mkdir $periodicity_dir
mkdir $cds_counts_dir
mkdir $codon_counts_dir
mkdir $plots_dir
mkdir $summed_counts_plots_dir
mkdir $periodicity_plots_dir
mkdir $offset_plots_dir
mkdir $heatmaps_plots_dir
