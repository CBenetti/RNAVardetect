#!/bin/bash
#SBATCH --job-name=featureCCinzia # Job name
#SBATCH --mail-type=END,FAIL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=cinzia.benetti@edu.unito.it # Where to send mail
#SBATCH -J RNAseq_featureC
#SBATCH --mem=80G
#SBATCH --time=24:00:00
#SBATCH -N 1
#SBATCH --output=log_files/featureCCinzia.log
#SBATCH -p cpu_medium
#SBATCH -c 6
module load subread/1.6.3

        if test ! -d count_matrix
        then
            	mkdir count_matrix
        fi
	files=($(find BAM_OUT/* -name *Aligned.sortedByCoord.out.bam))
	##raw counts on transcripts
	featureCounts -T 6 -a genome/hg38.ensGene.gtf -F GTF -t transcript -g gene_id -s 1 -o count_matrix/tableCounts_t ${files[@]}
	featureCounts -T 6 -a genome/hg38.ensGene.gtf -F GTF -t transcript -g gene_id -s 2 -o count_matrix/tableCounts_t_rev ${files[@]}

