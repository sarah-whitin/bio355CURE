#!/bin/bash

LABDIR=/Users/classes/bio355b/CURE_projects/tbontb
OUTDIR=/Users/classes/bio355b/CURE_projects/tbontb/data_processed
DATADIR=/Users/classes/bio355b/CURE_projects/tbontb/snake_data_raw

bcftools=/usr/bin/bcftools

POPS=(
  abacura_only
  Sdekayi_p123_v4_25miss
  Milks_filtered_snps_taxa
)

mkdir -p "$OUTDIR"

# Loop through all unique population pairs
for ((i=0; i<${#POPS[@]}; i++))
do
  pop=${POPS[$i]}
  vcf="$DATADIR/${pop}.vcf"

  $bcftools view \
    -Oz \
    -o $OUTDIR/${pop}.vcf.gz \
    $vcf

  $bcftools index \
  -o $OUTDIR/${pop}.vcf.tbi \
  -t $OUTDIR/${pop}.vcf.gz

done

echo "All compressed and indexed files created"
