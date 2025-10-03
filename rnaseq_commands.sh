# loading conda and directing to 2_rnaseq folder:
$ load_mamba
$ cd /project/immd0811/linux/2_rnaseq
#running Fast qc:
$ fastqc --noextract --nogroup -o 3_analysis/1_fastqc 1_fastq/cd8_rep3_read1.fastq.gz 1_fastq/cd8_rep3_read2.fastq.gz
#seeing quality score:
in a new terminal
$ scp
$ pwd
$ cd /c/Users/immd0811/
$ cd Downloads/
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/1_fastqc/cd8_rep3_read1_fastqc.html .
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/1_fastqc/cd8_rep3_read2_fastqc.html .
#running MultiQC:
In the 3_analysis folder:
$ mkdir reports
$ cd reports
$ multiqc /project/immd0811/linux/2_rnaseq/3_analysis/1_fastqc
#examining the output:
in a new terminal
$ scp
$ pwd
$ cd /c/Users/immd0811/Downloads
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/reports/multiqc_report.html .

#Submiting a job
$ cd /project/immd0811/linux/2_rnaseq/3_analysis/1_fastqc
$ load_mamba
$ cp /project/shared/linux/4_slurm/slurm_template.sh .
On a new terminal:
$ nano slurm_template.sh
Change the output pathway and input files to my own:
fastqc  --nogroup --threads 2 --extract -o /project/immd0811/linux/2_rnaseq/3_analysis/1_fastqc /project/immd0811/linux/2_rnaseq/1_fastq/cd8_rep3_read1.fastq.gz /project/immd0811/linux/2_rnaseq/1_fastq/cd8_rep3_read2.fastq.gz
save and exit
$ sbatch slurm_template.sh
$ squeue –me
$ watch squeue –me
$ less 565_slurm_template.sh.err
less 565_slurm_template.sh.out
#Running HISAT2 to map reads
$ cd /project/immd0811/linux/2_rnaseq/3_analysis
create a new directory:
$ mkdir 2_hisat
$ cp /project/shared/linux/4_slurm/slurm_template.sh .
$ nano slurm_template.sh
On nano:
hisat2 --threads 8 /project/shared/linux/5_rnaseq/hisat2_index/grcm39 \
-1 /project/immd0811/linux/2_rnaseq/1_fastq/cd8_rep3_read1.fastq.gz \
-2 /project/immd0811/linux/2_rnaseq/1_fastq/cd8_rep3_read2.fastq.gz \
--rna-strandness RF \
--summary-file /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/stats.txt \
-S /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/aln-pe.sam
Save and exit
$ sbatch slurm_template.sh
$ watch squeue --me
$ less 613_slurm_template.sh.err
$ less 613_slurm_template.sh.out
completed on 02/10/2025
good :)

#Day 5 03/10/2025
#Mapping and qunatification
#Use SAMtools to generate mapping QC
#You can convert your SAM to BAM and sort in the same step
#Index BAM file
Created a new script called sam_template.sh with instructions as follows:
samtools view -b /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/aln-pe.sam | samtools sort > /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/sorted.bam
samtools index sorted.bam Save exit 
$ sbatch sam_template.sh
$ watch squeue –me
To download the index BAM file:
In a different terminal (don’t log in)
$ scp
$ pwd
$ cd /c/Users/immd0811/Downloads
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/sorted.bam .
# Run samtools flagstat
$ samtools flagstats sorted.bam > sorted.flagstat
# Run samtools idxstats
$ samtools idxstats sorted.bam > sorted.idxstats
#Use MultiQC to visualise mapping QC
Created a new folder called mapping_reports in the 2_hisat folder using:
$ mkdir mapping_reports
then 
$ cd mapping_reports
$ multiqc /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat
On a new terminal:
$ scp
$ pwd
$ cd /c/Users/immd0811/Downloads
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/mapping_reports/multiqc_report.html .
#Run featureCounts to generate a count matrix
#Read the manual to find the necessary parameters
#Remember this is stranded data
#Submit as a job to the cluster
Created a new script called job_script.sh using 
Touch job_scriot.sh
Then in the script:
featureCounts -t exon -g gene_id -p --countReadPairs -a /project/immd0811/linux/2_rnaseq/2_genome/Mus_musculus.GRCm39.115.gtf.gz -o counts.txt \
/project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/sorted.bamSave and exit 
$ sbatch job_script.sh
$ watch squeue –me
#Use MultiQC to visualise quantification QC
$ mkdir counts_report
$ cd counts_report
$ multiqc /project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/counts.txt
On a new terminal:
$ scp
$ pwd
$ cd /c/Users/immd0811/Downloads
$ scp obds:/project/immd0811/linux/2_rnaseq/3_analysis/2_hisat/counts_report/multiqc_report.html .
#Visualise BAM file with IGV on your laptop
Save both .bam and .bam.bai files in the same folder
Then on the IGV website change the genome to genome of interest, then on the track select both the .bam and .bam.bai folder.
tasks completed 03/10/2025 :)
