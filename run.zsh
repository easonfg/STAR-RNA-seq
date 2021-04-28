############## index a genome #############
echo '######## INDEXING MOUSE GENOME #######'
./STAR/source/STAR \
--runThreadN 16 \
--runMode genomeGenerate \
--genomeDir mm_primary_assembly_index_annotated \
--genomeFastaFiles ../genome/GRCm38.primary_assembly.genome.fa \
--sjdbGTFfile ../genome/gencode.vM25.primary_assembly.annotation.gtf

## human index
echo '######## INDEXING HUMAN GENOME #######'
./STAR/source/STAR \
--runThreadN 16 \
--runMode genomeGenerate \
--genomeDir  human_primary_assembly_index_annotated \
--genomeFastaFiles ../genome/GRCh38.primary_assembly.genome.fa \
--sjdbGTFfile  ../genome/gencode.v34.primary_assembly.annotation.gtf
############## index a genome #############

################# map reads ##############
# set ulimit higher
ulimit -n 10000

echo '######## MAPPING MOUSE READS #######'
./STAR/source/STAR \
--outSAMattributes All \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts TranscriptomeSAM \
--runThreadN 16 \
--sjdbGTFfile ../genome/gencode.vM25.primary_assembly.annotation.gtf \
--outReadsUnmapped Fastx \
--outMultimapperOrder Random \
--genomeDir mm_primary_assembly_index_annotated \
--readFilesIn ../../Brain/26mo/CD/Br26CD1/Br26CD1_CKDL200153216-1a-AK13229-AK13230_H3LCKDSXY_L2_1.fq ../../Brain/26mo/CD/Br26CD1/Br26CD1_CKDL200153216-1a-AK13229-AK13230_H3LCKDSXY_L2_2.fq \
--outFileNamePrefix trial3_with_transcriptomeSAM2/br26cd1_
#--outWigType wiggle \
#
#human test
echo '######## MAPPING HUMAN READS #######'
./STAR/source/STAR \
--outSAMattributes All \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts TranscriptomeSAM \
--runThreadN 16 \
--outReadsUnmapped Fastx \
--outMultimapperOrder Random \
--genomeDir human_primary_assembly_index_annotated \
--readFilesIn ~/Desktop/salmon_tutorial/homo/raw_data/S_P8_2_1.fq ~/Desktop/salmon_tutorial/homo/raw_data/S_P8_2_2.fq \
--outFileNamePrefix human_test/S_P8_2_
#--sjdbGTFfile ../genome/gencode.v34.primary_assembly.annotation.gtf \
################# map reads #########################


################# qualimap #########################
## run qualimap on rnaseq

echo '######## RUNNING QUALIMAP on MOUSE  #######'
qualimap_v2.2.1/qualimap rnaseq \
-outdir trial3_with_transcriptomeSAM2/qualimap \
-bam trial3_with_transcriptomeSAM2/br26cd1_Aligned.sortedByCoord.out.bam \
-gtf ../genome/gencode.vM25.primary_assembly.annotation.gtf \
--java-mem-size=64G

## human test
echo '######## RUNNING QUALIMAP on HUMAN  #######'
qualimap_v2.2.1/qualimap rnaseq \
-outdir human_test/qualimap \
-bam human_test/S_P8_2_Aligned.sortedByCoord.out.bam \
-gtf ../genome/gencode.v34.primary_assembly.annotation.gtf \
--java-mem-size=64G

## htseq count with the bam file
echo '######## COUNTING MOUSE #######'
htseq-count \
-c trial3_with_transcriptomeSAM2/output.count \
trial3_with_transcriptomeSAM2/br26cd1_Aligned.sortedByCoord.out.bam ../genome/gencode.vM25.primary_assembly.annotation.gtf

## human test
echo '######## COUNTING HUMAN #######'
htseq-count \
-c human_test/output.count \
human_test/S_P8_2_Aligned.sortedByCoord.out.bam ../genome/gencode.vM25.primary_assembly.annotation.gtf
