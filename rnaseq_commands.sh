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
 done on 02/10/25
