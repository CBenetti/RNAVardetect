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
	module load gatk/4.2.1.0
	mkdir "out/variant_calling/${ARG1}"
	BAM=($(ls BAM_OUT/${ARG1}_*.bam))
	gatk --java-options "-Xmx4g" HaplotypeCaller -R genome/hg38_genome.fasta -I ${BAM} -O "out/variant_calling/${ARG1}/${ARG1}_raw_variants.vcf" -bamout "out/variant_calling/${ARG1}/${ARG1}_vc.bam"
	touch "flag_${ARG1}"
