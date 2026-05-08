#!/bin/bash

LABDIR=/Users/classes/bio355b/CURE_projects/tbontb
DATADIR=/Users/classes/bio355b/CURE_projects/tbontb/data_processed
OUTDIR=/Users/classes/bio355b/CURE_projects/tbontb/results

admixture=/usr/local/bin/admixture

POPS=(
  abacura_only
  Sdekayi_p123_v4_25miss
  Milks_filtered_snps_taxa
)

for ((i=0; i<${#POPS[@]}; i++))
do
  pop=${POPS[$i]}

  cp $DATADIR/${pop}.bed $DATADIR/${pop}_admix.bed
  cp $DATADIR/${pop}.fam $DATADIR/${pop}_admix.fam
  awk 'BEGIN{OFS="\t"} { split($1, parts, "_"); $1=parts[2]; print }' $DATADIR/${pop}.bim > $DATADIR/${pop}_admix.bim

  DATA=$DATADIR/${pop}_admix.bed

  for K in 2 3 4
  do
    echo "Running ADMIXTURE with K=$K"

    $admixture --cv $DATA $K > $OUTDIR/${pop}_admixture_K${K}.log 2>&1

  done

done
