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
module load star-fusion/1.9.0
    STAR-Fusion --genome_lib_dir /genome \
                --chimeric_junction BAM_OUT/${ARG1}_Chimeric.out.junction \
                --output_dir /out/gene_fusion/${ARG1}_STARFUSION
touch flag_${ARG1}












