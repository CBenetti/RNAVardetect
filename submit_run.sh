#!/bin/bash
sbatch ./run_trimming > out_trimming.txt
JOB_ID=$(awk '{print $4}' out_trimming.txt)
rm out_trimming.txt
sbatch --dependency=afterok:${JOB_ID} ./run_alignment > out_alignment.txt
JOB_ID=$(awk '{print $4}' out_alignment.txt)
rm out_alignment.txt
#sbatch --dependency=afterok:${JOB_ID} ./run_bam_processing > out_processing.txt
#JOB_ID=$(awk '{print $4}' out_processing.txt)
#rm out_processing.txt
#sbatch --dependency=afterok:${JOB_ID} ./run_variant_calling > out.txt
sbatch --dependency=afterok:${JOB_ID} ./run_gene_fusion > out_gene_fusion.txt
