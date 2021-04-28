ulimit -n 10000

run_STAR(){
  echo "Processing sample $1"

  A="$(cut -d'/' -f7 <<<"$1")"
  A="$(cut -d'_' -f1 <<<"$A")"
  echo $A

    mkdir short_reads_test/${A}_quant

    ./STAR/source/STAR \
    --outSAMattributes All \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode GeneCounts TranscriptomeSAM \
    --runThreadN 16 \
    --readFilesCommand gunzip -c \
    --sjdbGTFfile ../genome/gencode.vM25.primary_assembly.annotation.gtf \
    --outReadsUnmapped Fastx \
    --outMultimapperOrder Random \
    --genomeDir mm_primary_assembly_index_annotated \
    --readFilesIn $1_1.fq.gz $1_2.fq.gz \
    --outFilterScoreMinOverLread 0 --outFilterMatchNminOverLread 0 --outFilterMatchNmin 40 \
    --outFileNamePrefix short_reads_test/${A}_quant/${A}_

    qualimap_v2.2.1/qualimap rnaseq \
    -outdir short_reads_test/${A}_quant/qualimap \
    -bam short_reads_test/${A}_quant/${A}_Aligned.sortedByCoord.out.bam \
    -gtf ../genome/gencode.vM25.primary_assembly.annotation.gtf \
    --java-mem-size=64G

    #htseq-count \
    #-c short_reads_test/${A}_quant/output.count \
    #short_reads_test/${A}_quant/${A}_Aligned.sortedByCoord.out.bam ../genome/gencode.vM25.primary_assembly.annotation.gtf

}


#for counter in {0..4}
#do
#  i=$((counter * 2))
#  #echo $i
#  run_salmon KD_P${i}_1
#  run_salmon KD_P${i}_2
#  run_salmon S_P${i}_1
#  run_salmon S_P${i}_2
#done


#run_salmon KDiPSC_${counter}
#run_salmon S_iPSC_${counter}

#run_STAR ../../Brain/12mo/CD/Br12CD1/Br12CD1_CKDL200153216-1a-AK13273-AK13274_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/CD/Br12CD2/Br12CD2_CKDL200153216-1a-AK519-AK13281_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/CD/Br12CD3/Br12CD3_CKDL200153216-1a-AK13455-AK13456_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/CD/Br12CD4/Br12CD4_CKDL200153216-1a-AK10744-AK13317_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/CD/Br12CD5/Br12CD5_CKDL200153216-1a-AK13227-AK13228_H3LCKDSXY_L2
#
#run_STAR ../../Brain/12mo/KD/Br12KD1/Br12KD1_CKDL200153216-1a-AK9081-AK13343_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD2/Br12KD2_CKDL200153216-1a-AK13734-AK13735_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD3/Br12KD3_CKDL200153216-1a-AK13357-AK13358_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD4/Br12KD4_CKDL200153216-1a-AK13275-AK13276_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD5/Br12KD5_CKDL200153216-1a-AK13264-AK13265_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD6/Br12KD6_CKDL200153216-1a-AK2423-AK10746_H3LCKDSXY_L2
#run_STAR ../../Brain/12mo/KD/Br12KD7/Br12KD7_CKDL200153216-1a-AK6713-AK7577_H3LCKDSXY_L2
#
#run_STAR ../../Brain/26mo/CD/Br26CD1/Br26CD1_CKDL200153216-1a-AK13229-AK13230_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD2/Br26CD2_CKDL200153216-1a-AK13344-AK13345_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD3/Br26CD3_CKDL200153216-1a-AK13736-AK13737_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD4/Br26CD4_CKDL200153216-1a-AK8999-AK13359_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD5/Br26CD5_CKDL200153216-1a-AK13277-AK657_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD6/Br26CD6_CKDL200153216-1a-AK13266-AK13267_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD7/Br26CD7_CKDL200153216-1a-AK13533-AK13534_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/CD/Br26CD8/Br26CD8_CKDL200153216-1a-AK13453-AK13575_H3LCKDSXY_L2
#
#run_STAR ../../Brain/26mo/KD/Br26KD1/Br26KD1_CKDL200153216-1a-AK10745-AK13325_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD2/Br26KD2_CKDL200153216-1a-AK13346-AK13347_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD3/Br26KD3_CKDL200153216-1a-AK3203-AK13738_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD4/Br26KD4_CKDL200153216-1a-AK13360-AK4417_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD5/Br26KD5_CKDL200153216-1a-AK13278-AK2259_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD6/Br26KD6_CKDL200153216-1a-AK7549-AK13214_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD7/Br26KD7_CKDL200153216-1a-AK11648-AK13565_H3LCKDSXY_L2
#run_STAR ../../Brain/26mo/KD/Br26KD8/Br26KD8_CKDL200153216-1a-5UDI1999-AK4034_H3LCKDSXY_L2
#
#
#run_STAR ../../liver/26mo/CD/LvrCD1/LvrCD1_CKDL200153216-1a-AK12040-AK13326_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD2/LvrCD2_CKDL200153216-1a-AK10718-AK13694_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD3/LvrCD3_CKDL200153216-1a-7UDI1371-5UDI1911_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD4/LvrCD4_CKDL200153216-1a-AK12039-AK13760_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD5/LvrCD5_CKDL200153216-1a-AK13279-AK13280_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD6/LvrCD6_CKDL200153216-1a-AK13215-AK13216_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD7/LvrCD7_CKDL200153216-1a-AK13536-AK8772_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/CD/LvrCD8/LvrCD8_CKDL200153216-1a-7UDI2585-7UDI439_H3LCKDSXY_L2
#
#run_STAR ../../liver/26mo/KD/LvrKD1/LvrKD1_CKDL200153216-1a-AK8727-AK13327_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD2/LvrKD2_CKDL200153216-1a-AK13348-AK13349_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD3/LvrKD3_CKDL200153216-1a-AK13739-AK13740_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD4/LvrKD4_CKDL200153216-1a-AK13761-AK4896_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD5/LvrKD5_CKDL200153216-1a-AK12042-AK12044_H3LCKDSXY_L2
run_STAR ../../liver/26mo/KD/LvrKD6/LvrKD6_CKDL200153216-1a-AK13217-AK13218_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD7/LvrKD7_CKDL200153216-1a-AK9963-AK7364_H3LCKDSXY_L2
#run_STAR ../../liver/26mo/KD/LvrKD8/LvrKD8_CKDL200153216-1a-AK12502-AK13584_H3LCKDSXY_L2

