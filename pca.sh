#!/bin/bash

LABDIR=/Users/classes/bio355b/CURE_projects/tbontb
DATADIR=/Users/classes/bio355b/CURE_projects/tbontb/data_processed

plink=/usr/local/plink/plink
bcftools=/usr/bin/bcftools

POPS=(
  abacura_only
  Sdekayi_p123_v4_25miss
  Milks_filtered_snps_taxa
)

# Loop through all unique population pairs
for ((i=0; i<${#POPS[@]}; i++))
do
  pop=${POPS[$i]}
  vcf="$DATADIR/${pop}.vcf"

  #index
  $bcftools index -t $DATADIR/${pop}.vcf.gz

  #convert to plink
  $plink --vcf $DATADIR/${pop}.vcf.gz \
  --allow-extra-chr \
  --make-bed \
  --out $DATADIR/${pop}

  #run PCA
  $plink --bfile $DATADIR/${pop} \
  --allow-extra-chr \
  --pca \
  --out $DATADIR/${pop}_pca

done

echo "All PCA files created"
