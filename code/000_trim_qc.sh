#!/bin/bash
#SBATCH --mail-type=FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=cinzia.benetti@edu.unito.it # Where to send mail
#SBATCH --mem=40G
#SBATCH --time=24:00:00
#SBATCH -N 1
#SBATCH -p cpu_medium
#SBATCH -c 16
#SBATCH --threads-per-core 1

if [ ! -f "fastq_trimmed/${ARG1}_fastp.html" ]; then
	fastqs=($(ls fastq/${ARG1}*fastq.gz))
	module load fastp/0.22.0
	if [ "${#fastqs[@]}" -eq 2 ]; then
	    fastp -i ${fastqs[0]} -I ${fastqs[1]} \
	          -o fastq_trimmed/${ARG1}_R1.fastq.gz \
	          -O fastq_trimmed/${ARG1}_R2.fastq.gz \
	          --detect_adapter_for_pe \
	          --qualified_quality_phred 20 \
	          --length_required 36 \
	          --html "fastq_trimmed/${ARG1}_fastp.html" \
	          --json "fastq_trimmed/${ARG1}_fastp.json"
	else
	    fastp -i ${fastqs[0]} \
	          -o fastq_trimmed/${ARG1}_R1.fastq.gz \
	          --qualified_quality_phred 20 \
	          --length_required 36 \
	          --html "fastq_trimmed/${ARG1}_fastp.html" \
	          --json "fastq_trimmed/${ARG1}_fastp.json"
	fi
fi
touch flag_${ARG1}
