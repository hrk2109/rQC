#!/bin/bash

WD=$1
BAM=$2

SAMPLE=`basename $BAM .outAligned.sortedByCoord.out.bam`

JAR=/ifs/work/bergerm1/kimh/src/RNA-SeQC/

ID=$SAMPLE
LB=$SAMPLE
PU="CASAVA_hg19"
PL="ILLUMINA"
SM="illumina"
 
java -Xmx2048m -Xms2048m -jar $JAR/AddOrReplaceReadGroups.jar \
        I=$BAM \
        O=$SAMPLE.rg.bam \
        RGID=${ID} \
        RGLB=${LB} \
        RGPL=${PL} \
        RGPU=${PU} \
        RGSM=${SM} \
        VALIDATION_STRINGENCY=LENIENT \
        2>./$SAMPLE.AddOrReplaceReadGroups.err

BAM=$SAMPLE.rg.bam

samtools index $BAM

mkdir $WD/$BAM.out

java -Xmx2048m -Xms2048m -jar /ifs/work/bergerm1/kimh/src/RNA-SeQC/RNASeQC.jar -n 1000 -s "TestId|$BAM|TestDesc" -t /ifs/work/bergerm1/kimh/src/RNA-SeQC/ref/gencode.v7.annotation_goodContig.gtf -r /ifs/work/bergerm1/kimh/src/RNA-SeQC/ref/Homo_sapiens_assembly19.fasta -o $WD/$BAM.out -strat gc -gc /ifs/work/bergerm1/kimh/src/RNA-SeQC/ref/gencode.v7.gc.txt -BWArRNA /ifs/work/bergerm1/kimh/src/RNA-SeQC/ref/human_all_rRNA.fasta

