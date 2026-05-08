#abacura_only_admixture_K2.log:CV error (K=2): 0.38999
#abacura_only_admixture_K3.log:CV error (K=3): 0.40766
#abacura_only_admixture_K4.log:CV error (K=4): 0.45346
#Milks_filtered_snps_taxa_admixture_K2.log:CV error (K=2): 0.21763
#Milks_filtered_snps_taxa_admixture_K3.log:CV error (K=3): 0.20237
#Milks_filtered_snps_taxa_admixture_K4.log:CV error (K=4): 0.21020
#Sdekayi_p123_v4_25miss_admixture_K2.log:CV error (K=2): 0.66008
#Sdekayi_p123_v4_25miss_admixture_K3.log:CV error (K=3): 0.74277
#Sdekayi_p123_v4_25miss_admixture_K4.log:CV error (K=4): 0.81872

library(tidyverse)
library(ggplot2)

results_path <- "/Users/classes/bio355b/CURE_projects/tbontb/results"
data_path <- "/Users/classes/bio355b/CURE_projects/tbontb/data_processed"

CV_error <- data.frame(
  species = c("abacura_only", "Milks_filtered", "Sdekayi"),
  K2   = c(0.38999, 0.21763, 0.66008),
  K3   = c(0.40766, 0.20237, 0.74277),
  K4   = c(0.45346, 0.21020, 0.81872)
)

abacura_admix.2 <- read_table((file.path(results_path, "abacura_only_admix.2.Q")), col_names = FALSE)
abacura_fam <- read_table((file.path(data_path, "abacura_only.fam")), col_names = FALSE)
abacura_fam <- abacura_fam |> separate(X2, c("genus", "species", "ID"), "_")
abacura_admix.2$ID <- abacura_fam$ID
abacura_admix.2_long <- abacura_admix.2 %>%
  pivot_longer(
    cols = starts_with("X"),
    names_to = "cluster",
    values_to = "ancestry"
  )
ggplot(abacura_admix.2_long, aes(x = ID, y = ancestry, fill = cluster)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(
    x = "Individual",
    y = "Ancestry proportion",
    title = "ADMIXTURE results (K = 2)"
  ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


Milks_admix.3 <- read_table((file.path(results_path, "Milks_filtered_snps_taxa_admix.3.Q")), col_names = FALSE)
Milks_fam <- read_table((file.path(data_path, "Milks_filtered_snps_taxa.fam")), col_names = FALSE)
Milks_fam <- Milks_fam |> separate(X2, c("genus", "species", "ID"), "_")
Milks_admix.3$ID <- Milks_fam$ID
Milks_admix.3_long <- Milks_admix.3 %>%
  pivot_longer(
    cols = starts_with("X"),
    names_to = "cluster",
    values_to = "ancestry"
  )
ggplot(Milks_admix.3_long, aes(x = ID, y = ancestry, fill = cluster)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(
    x = "Individual",
    y = "Ancestry proportion",
    title = "ADMIXTURE results (K = 3)"
  ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


Sdekayi_admix.2 <- read_table((file.path(results_path, "Sdekayi_p123_v4_25miss_admix.2.Q")), col_names = FALSE)
Sdekayi_fam <- read_table((file.path(data_path, "Sdekayi_p123_v4_25miss.fam")), col_names = FALSE)
Sdekayi_fam <- Sdekayi_fam |> separate(X2, c("genus", "species", "ID"), "_")
Sdekayi_admix.2$ID <- Sdekayi_fam$ID
Sdekayi_admix.2_long <- Sdekayi_admix.2 %>%
  pivot_longer(
    cols = starts_with("X"),
    names_to = "cluster",
    values_to = "ancestry"
  )
ggplot(Sdekayi_admix.2_long, aes(x = ID, y = ancestry, fill = cluster)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(
    x = "Individual",
    y = "Ancestry proportion",
    title = "ADMIXTURE results (K = 2)"
  ) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
