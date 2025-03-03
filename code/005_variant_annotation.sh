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
	module load snpeff/4.3
	module load tabix/0.2.6

####SNPs
        gatk SelectVariants -R genome/hg38_genome.fasta -V "out/variant_calling/${ARG1}/${ARG1}_raw_variants.vcf" --select-type-to-include SNP -O "out/variant_calling/${ARG1}/${ARG1}_raw_snps.vcf"
##Filter variant calls based on INFO and/or FORMAT annotations.
	gatk VariantFiltration -V "out/variant_calling/${ARG1}/${ARG1}_raw_snps.vcf" -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "SOR > 3.0" --filter-name "SOR3" -filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" -O "out/variant_calling/${ARG1}/${ARG1}_filtered_snps.vcf"
	#-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
##Annotation
	cd out/variant_calling/${ARG1}
	java -Xmx8g -jar /gpfs/share/apps/snpeff/4.3/snpEff.jar  -c ../../../code/snpEff.config -v GRCh38.86 "${ARG1}_filtered_snps.vcf" > "${ARG1}_filtered_snps-ann.vcf"
	mv snpEff_summary.html snpEff_summary_snps.html
	mv snpEff_genes.txt snpEff_genes_snps.txt
	cd ../../../
##QC
	bgzip -c "out/variant_calling/${ARG1}/${ARG1}_filtered_snps-ann.vcf" > "out/variant_calling/${ARG1}/${ARG1}_filtered_snps-ann.vcf.gz"
	tabix -f -p "out/variant_calling/${ARG1}/${ARG1}_filtered_snps-ann.vcf.gz"
	gatk CollectVariantCallingMetrics -I "out/variant_calling/${ARG1}/${ARG1}_filtered_snps-ann.vcf.gz" -O "out/variant_calling/${ARG1}/${ARG1}_filtered_snps-ann-eval" --DBSNP "variant_data/Homo_sapiens_assembly38.dbsnp138.vcf.gz"

####INDELS
        gatk SelectVariants -R genome/hg38_genome.fasta -V "out/variant_calling/${ARG1}/${ARG1}_raw_variants.vcf" --select-type-to-include INDEL -O "out/variant_calling/${ARG1}/${ARG1}_raw_indels.vcf"
##Filter variant calls based on INFO and/or FORMAT annotations.
	gatk VariantFiltration -V "out/variant_calling/${ARG1}/${ARG1}_raw_indels.vcf" -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "FS > 200.0" --filter-name "FS200" -O "out/variant_calling/${ARG1}/${ARG1}_filtered_indels.vcf"

	#-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
##Annotation
	cd out/variant_calling/${ARG1}
	java -Xmx8g -jar /gpfs/share/apps/snpeff/4.3/snpEff.jar  -c ../../../code/snpEff.config -v GRCh38.86 "${ARG1}_filtered_indels.vcf" > "${ARG1}_filtered_indels-ann.vcf"
	mv snpEff_summary.html snpEff_summary_indels.html
	mv snpEff_genes.txt snpEff_indels_snps.txt
	cd ../../../
##QC
	bgzip -c "out/variant_calling/${ARG1}/${ARG1}_filtered_indels-ann.vcf" > "out/variant_calling/${ARG1}/${ARG1}_filtered_indels-ann.vcf.gz"
	tabix -f -p "out/variant_calling/${ARG1}/${ARG1}_filtered_indels-ann.vcf.gz"
	gatk CollectVariantCallingMetrics -I "out/variant_calling/${ARG1}/${ARG1}_filtered_indels-ann.vcf.gz" -O "out/variant_calling/${ARG1}/${ARG1}_filtered_indels-ann-eval" --DBSNP "variant_data/Homo_sapiens_assembly38.known_indels.vcf.gz"


        touch "flag_${ARG1}"


