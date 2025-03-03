#!/bin/bash
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=cinzia.benetti@edu.unito.it # Where to send mail
#SBATCH --mem=40G
#SBATCH --time=24:00:00
#SBATCH -N 1
#SBATCH -p cpu_medium
#SBATCH -c 16
#SBATCH --threads-per-core 1
##Load modules
#source code/custom-tcshrc
	module load picard/2.26.10
	module load gatk/4.2.1.0

	BAM=($(ls BAM_OUT/${ARG1}/*.bam))
	if [ ! -f "BAM_OUT/${ARG1}/${ARG1}.sorted.dedup.bam" ]; then
		java -jar /gpfs/share/apps/picard/2.26.10/raw/picard/build/libs/picard.jar MarkDuplicates INPUT=${BAM} OUTPUT="BAM_OUT/${ARG1}/${ARG1}.sorted.dedup.bam" METRICS_FILE="BAM_OUT/${ARG1}/metrics.txt"
	fi
	if [ ! -f "BAM_OUT/${ARG1}/${ARG1}_RG1.sorted.dedup.bam" ]; then
		java -jar /gpfs/share/apps/picard/2.26.10/raw/picard/build/libs/picard.jar AddOrReplaceReadGroups I="BAM_OUT/${ARG1}/${ARG1}.sorted.dedup.bam" O="BAM_OUT/${ARG1}/${ARG1}_RG1.sorted.dedup.bam" RGID=${ARG1} RGLB=1 RGPL=Illumina RGPU=unit1 RGSM=3
	fi
	if [ ! -f "BAM_OUT/${ARG1}/${ARG1}_RG1.sorted.dedup.bai" ]; then
		java -jar /gpfs/share/apps/picard/2.26.10/raw/picard/build/libs/picard.jar BuildBamIndex INPUT="BAM_OUT/${ARG1}/${ARG1}_RG1.sorted.dedup.bam"
	fi
	if [ ! -f "BAM_OUT/${ARG1}/${ARG1}_RG1_split.sorted.dedup.bai" ]; then
		gatk SplitNCigarReads -R genome/hg38_genome.fasta -I "BAM_OUT/${ARG1}/${ARG1}_RG1.sorted.dedup.bam" -O "BAM_OUT/${ARG1}/${ARG1}_RG1_split.sorted.dedup.bam"
	fi
	if [ ! -f "BAM_OUT/${ARG1}/${ARG1}_recal_data.table" ]; then
		gatk BaseRecalibrator -I "BAM_OUT/${ARG1}/${ARG1}_RG1_split.sorted.dedup.bam" -R genome/hg38_genome.fasta --known-sites "variant_data/Homo_sapiens_assembly38.known_indels.vcf.gz" --known-sites "variant_data/Homo_sapiens_assembly38.dbsnp138.vcf.gz" -O "BAM_OUT/${ARG1}/${ARG1}_recal_data.table"
	fi
	gatk ApplyBQSR -R genome/hg38_genome.fasta -I "BAM_OUT/${ARG1}/${ARG1}_RG1_split.sorted.dedup.bam" --bqsr-recal-file "BAM_OUT/${ARG1}/${ARG1}_recal_data.table" -O "BAM_OUT/${ARG1}_recal_reads.bam"
	touch "flag_${ARG1}"
