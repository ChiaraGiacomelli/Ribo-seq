#!/usr/bin/env bash

#This script uses bbmap to align reads.
#in specificies the input <.fastq> file.
#out specificies the output <.SAM> file.
#ref specifies the <.fasta> file to use as a reference. bbmap will use this to make an index. As this is much quicker than other alignment programs, we use the nodisk option so that this isn't written to file
#outm and outu specificies filenames to write <.fastq> files for all reads that either align or do not align respectively
#ambigous specifies how to treat multimapped reads. For the contaminating RNA species we use best (keeps the highest scored alignment). For protein coding (pc) we run with both best and all (keeps all possible aligments)
#2> stores the text that is printed to the screen as a log
#We first align to rRNA, then use everything that did not align to rRNA as input to align to tRNAs, then mitochondrial mRNAs and finally protein coding mRNAs. We then use fastQC on all the output <.fastq> files

#read in variables
source common_variables.sh

#Align to rRNA
for filename in $RPF_filenames
do
bbmap.sh in=$fastq_dir/${filename}_UMIremoved.fastq out=$SAM_dir/${filename}_rRNA.sam ref=$rRNA_fasta outm=$fastq_dir/${filename}_rRNA.fastq outu=$fastq_dir/${filename}_non_rRNA.fastq ambiguous=best nodisk 2> $log_dir/${filename}_rRNA_log.txt
done

#Align to tRNA fasta
for filename in $RPF_filenames
do
bbmap.sh in=$fastq_dir/${filename}_non_rRNA.fastq out=$SAM_dir/${filename}_tRNA.sam ref=$tRNA_fasta outm=$fastq_dir/${filename}_tRNA.fastq outu=$fastq_dir/${filename}_non_rRNA_tRNA.fastq ambiguous=best nodisk 2> $log_dir/${filename}_tRNA_log.txt
done

#Align to mito fasta
for filename in $RPF_filenames
do
bbmap.sh in=$fastq_dir/${filename}_non_rRNA_tRNA.fastq out=$SAM_dir/${filename}_mito.sam ref=$mito_fasta outm=$fastq_dir/${filename}_mito.fastq outu=$fastq_dir/${filename}_non_rRNA_tRNA_mito.fastq ambiguous=best nodisk 2> $log_dir/${filename}_mito_log.txt
done

#Align to protein coding transcriptomes
for filename in $RPF_filenames
do
bbmap.sh in=$fastq_dir/${filename}_non_rRNA_tRNA_mito.fastq out=$SAM_dir/${filename}_pc_all.sam ref=$pc_fasta outm=$fastq_dir/${filename}_pc.fastq outu=$fastq_dir/${filename}_unaligned.fastq ambiguous=all nodisk 2> $log_dir/${filename}_pc_all_log.txt
bbmap.sh in=$fastq_dir/${filename}_non_rRNA_tRNA_mito.fastq out=$SAM_dir/${filename}_pc_best.sam ref=$pc_fasta ambiguous=best nodisk 2> $log_dir/${filename}_pc_best_log.txt
done

#run fastqc on mapped reads
for filename in $RPF_filenames
do
fastqc $fastq_dir/${filename}_rRNA.fastq --outdir=$fastqc_dir &
fastqc $fastq_dir/${filename}_tRNA.fastq --outdir=$fastqc_dir &
fastqc $fastq_dir/${filename}_mito.fastq --outdir=$fastqc_dir &
fastqc $fastq_dir/${filename}_pc.fastq --outdir=$fastqc_dir &
fastqc $fastq_dir/${filename}_unaligned.fastq --outdir=$fastqc_dir &
done
wait
