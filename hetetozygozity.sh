# move to directory
cd /Users/classes/bio355b/CURE_projects/tbontb/snake_data_raw

# load tools
bcftools=/usr/bin/bcftools
vcftools=/usr/local/bin/vcftools

# replace username 
mvdir /Users/username/smith/BIO335/snake/doi_10_5061_dryad_9cnp5hqv5__v20241125
bcftools=/opt/homebrew/Cellar/bcftools
vcftools=/opt/homebrew/bin/vcftools

# abacura het
vcftools --gzvcf abacura_only.vcf \
  --het \
  --out out/abacura_only

# dekayi het
vcftools --gzvcf Sdekayi_p123_v4_25miss.vcf \
  --het \
  --out out/Sdekayi

# ltri het
vcftools --gzvcf 	Milks_filtered_snps_taxa.vcf \
  --het \
  --out out/ltriangulum
