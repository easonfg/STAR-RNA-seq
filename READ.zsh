# R_methods: where downstream analysis like count and DEseq2 lives
# STAR: where the package is. can add to .zsh bash but hasnt done it yet
# qualimap_v2.2.1 is where qualimap package is. allows for some quality graphs and percentage introns etc
# quant_samples.zsh uses regular standard STAR pipeline to run ketone diet samples
# test_quant_samples.zsh is seting threshold of STAR to accept shorter reads. allowing for higher % unique mapping
# quants: results from quant_samples.zsh
# short_reads_test: results from test_quant_samples.zsh
#
# the following codes are also in run.zsh
#
############## index a genome #############
./STAR/source/STAR \
--runThreadN 16 \
--runMode genomeGenerate \
--genomeDir mm_primary_assembly_index_annotated \
--genomeFastaFiles ../genome/GRCm38.primary_assembly.genome.fa \
--sjdbGTFfile ../genome/gencode.vM25.primary_assembly.annotation.gtf

## human index
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

./STAR/source/STAR \
--outSAMattributes All \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts \
--runThreadN 16 \
--sjdbGTFfile ../genome/gencode.vM25.primary_assembly.annotation.gtf \
--outReadsUnmapped Fastx \
--outMultimapperOrder Random \
--genomeDir mm_primary_assembly_index_annotated \
--readFilesIn ../../Brain/26mo/CD/Br26CD1/Br26CD1_CKDL200153216-1a-AK13229-AK13230_H3LCKDSXY_L2_1.fq ../../Brain/26mo/CD/Br26CD1/Br26CD1_CKDL200153216-1a-AK13229-AK13230_H3LCKDSXY_L2_2.fq \
--outFileNamePrefix trial2/br_26cd1_
#--readFilesCommand zcat \
#--outSAMunmapped Within
#--outSAMattributes Standard
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
## ran qualimap GUI
./qualimap (in qualimap folder)
## run qualimap on rnaseq
./qualimap rnaseq \
-outdir ../trial2/qualimap \
-bam ~/Desktop/ketone_exp/salmon/STAR/trial2/br26cd1_Aligned.sortedByCoord.out.bam \
-gtf ~/Desktop/ketone_exp/salmon/genome/gencode.vM25.primary_assembly.annotation.gtf \
--java-mem-size=64G

./qualimap rnaseq \
-outdir ../trial3_with_transcriptomeSAM/qualimap \
-bam ~/Desktop/ketone_exp/salmon/STAR/trial3_with_transcriptomeSAM/br26cd1_Aligned.sortedByCoord.out.bam \
-gtf ~/Desktop/ketone_exp/salmon/genome/gencode.vM25.primary_assembly.annotation.gtf \
--java-mem-size=64G

## human test
./qualimap rnaseq \
-outdir ../human_test/qualimap \
-bam ~/Desktop/ketone_exp/salmon/STAR/human_test/S_P8_2_Aligned.sortedByCoord.out.bam \
-gtf ~/Desktop/ketone_exp/salmon/genome/gencode.v34.primary_assembly.annotation.gtf \
--java-mem-size=64G

## htseq count with the bam file
htseq-count \
-c output.count \
br26cd1_Aligned.sortedByCoord.out.bam ../../genome/gencode.vM25.primary_assembly.annotation.gtf
#-s no \
#-r pos \
#—t exon \
#-i pacid \
#
