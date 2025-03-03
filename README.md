# RNAVardetect

This pipeline is designed forworking on HPC clusters equipped with slurm process manager.
It allows to perform SNP, indel and gene fusion analysis starting from RNAseq data (paired end mode).
It is designed with working with max 16 samples, therefore to adjust the number of samples running in parallel 
the stopping flags in the for cyscles within the run_* scripts must be adjusted accordingly


## Usage

To run the full pipeline, add in the fastq directory your input files
(only ONE file for each R1 and R2 fastq must be provided. cat and merge if multiple lanes are provided before launching the pipeline)

Then just run the master script: 

```
./submit_run.sh
```

To run a partial version of the pipeline, just comment the steps you want to skip on the master script.

To run individual parts of the piepeline only, just submit the corresponding run script, e.g.:

```
sbatch run_alignment.sh
```


## Requirements

The pipeline requires 
-An indexed version of the human genome (fasta files and STAR index directory) and references in gtf format
-Picard dictionary (.dict) file
-Variant data (tabix indexed vcf files including known variants and indels)
-CTAT library file required by STAR-fusion
-SnpEff database
All of these files are already provided for Human genome version hg38 in the genome and variant_data directories.


#### Modules being loaded for the analysis
-star/2.7.11b
-fastp/0.22.0
-picard/2.26.10
-gatk/4.2.1.0
-samtools/1.9
-snpeff/4.3
-tabix/0.2.6
-star-fusion/1.9.0
-fastqc/0.11.7
-condaenvs/new/multiqc
