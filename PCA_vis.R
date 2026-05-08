#packages
library(tidyverse)
library(ggplot2)
library(readr)

#data
out_path <- "/Users/classes/bio355b/CURE_projects/tbontb/data_processed"
data_path <- "/Users/classes/bio355b/CURE_projects/tbontb/snake_data_raw"
fig_path <- "/Users/classes/bio355b/CURE_projects/tbontb/figures"

all_coords_requested <- read_csv(file.path(data_path, "all_coords_requested.csv"))
all_coords_requested <- rename(all_coords_requested, INDV = number)

Sdekayi_pca <- read_table(file.path(out_path, "Sdekayi_p123_v4_25miss_pca.eigenvec"), col_names = FALSE)
colnames(Sdekayi_pca)[1:2] <- c("FID","INDV")
colnames(Sdekayi_pca)[3:ncol(Sdekayi_pca)] <- paste0("PC", 1:(ncol(Sdekayi_pca)-2))
Sdekayi_pca <- left_join(Sdekayi_pca, all_coords_requested, by = "INDV")
write.csv(Sdekayi_pca, file.path(out_path, "Sdekayi_pca.csv"), row.names = FALSE)

abacura_pca <- read_table(file.path(out_path, "abacura_only_pca.eigenvec"), col_names = FALSE)
colnames(abacura_pca)[1:2] <- c("FID","INDV")
colnames(abacura_pca)[3:ncol(abacura_pca)] <- paste0("PC", 1:(ncol(abacura_pca)-2))
abacura_pca <- left_join(abacura_pca, all_coords_requested, by = "INDV")
write.csv(abacura_pca, file.path(out_path, "abacura_pca.csv"), row.names = FALSE)

ltri_pca <- read_table(file.path(out_path, "Milks_filtered_snps_taxa_pca.eigenvec"), col_names = FALSE)
colnames(ltri_pca)[1:2] <- c("FID","INDV")
colnames(ltri_pca)[3:ncol(ltri_pca)] <- paste0("PC", 1:(ncol(ltri_pca)-2))
ltri_pca <- ltri_pca |> separate(INDV, c("genus", "species", "INDV"), "_")
ltri_pca <- left_join(ltri_pca, all_coords_requested, by = "INDV")
write.csv(ltri_pca, file.path(out_path, "ltri_pca.csv"), row.names = FALSE)

#Sdekayi plots
ggplot(Sdekayi_pca, aes(x = PC1, y = PC2)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2"
  )

ggplot(Sdekayi_pca, aes(x = PC1, y = PC2, color = lon)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Longitude"
  )

ggplot(Sdekayi_pca, aes(x = PC1, y = PC2, color = lat)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Latitude"
  )

#abacura plots
ggplot(abacura_pca, aes(x = PC1, y = PC2)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2"
  )

ggplot(abacura_pca, aes(x = PC1, y = PC2, color = lon)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Longitude"
  )

ggplot(abacura_pca, aes(x = PC1, y = PC2, color = lat)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Latitude"
  )

#ltri plots
ggplot(ltri_pca, aes(x = PC1, y = PC2)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2"
  )

ggplot(ltri_pca, aes(x = PC1, y = PC2, color = lon)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Longitude"
  )

ggplot(ltri_pca, aes(x = PC1, y = PC2, color = lat)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Latitude"
  )
