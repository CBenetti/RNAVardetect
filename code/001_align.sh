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
module load star/2.7.11b

if [ ! -d "BAM_OUT/${ARG1}" ]; then
	mkdir "BAM_OUT/${ARG1}"
	cd "BAM_OUT/${ARG1}"
	if [ -d ../../fastq_trimmed/ ]; then
		fastqs=($(ls ../../fastq_trimmed/${ARG1}*fastq.gz))
	else
		fastqs=($(ls ../../fastq/${ARG1}*fastq.gz))
	fi

	 STAR \
	  --runThreadN 10 \
	  --runMode alignReads \
	  --genomeDir ${ARG2} \
	  --readFilesIn ${fastqs[@]} \
	  --readFilesCommand zcat \
	  --outFileNamePrefix "${ARG1}_" \
	  --outSAMtype BAM SortedByCoordinate \
	  --quantMode GeneCounts \
	  --twopassMode Basic \
	  --outSAMstrandField intronMotif \
	  --alignSJoverhangMin 8 \
	  --alignSJDBoverhangMin 1 \
	  --outFilterMismatchNoverLmax 0.04 \
	  --outFilterMultimapNmax 1 \
	  --outFilterMismatchNmax 3 \
	  --limitBAMsortRAM 45000000000 \
	  --outReadsUnmapped Fastx \
	  --outWigType bedGraph \
	  --outWigStrand Stranded \
	  --chimSegmentMin 12 \
	  --chimJunctionOverhangMin 12 \
	  --chimOutType Junctions SeparateSAMold \
	  --outWigNorm RPM \
	  --chimOutJunctionFormat 1
fi
touch "../../flag_${ARG1}"
