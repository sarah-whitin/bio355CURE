#packages
library(scales)
library(dplyr)

#loading data
out_path <- "/Users/classes/bio355b/CURE_projects/tbontb/data_processed"
fig_path <- "/Users/classes/bio355b/CURE_projects/tbontb/figures"

Sdekayi_pca <- read_csv(file.path(out_path, "Sdekayi_pca.csv"))
abacura_pca <- read_csv(file.path(out_path, "abacura_pca.csv"))
ltri_pca <- read_csv(file.path(out_path, "ltri_pca.csv"))

Sdekayi_val <- read_table(file.path(out_path, "Sdekayi_p123_v4_25miss_pca.eigenval"), col_names = FALSE)
abacura_val <- read_table(file.path(out_path, "abacura_only_pca.eigenval"), col_names = FALSE)
ltri_val <- read_table(file.path(out_path, "Milks_filtered_snps_taxa_pca.eigenval"), col_names = FALSE)

#loading map components
usa_map <- tidycensus::get_acs(geography = "state", 
                               variables = "B01003_001", 
                               geometry = TRUE) |>
  st_transform(crs = 4326)

Mexico_map <-  maps::map(region = "Mexico", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

Canada_map <-  maps::map(region = "Canada", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

#data processing
abacura_pca <- abacura_pca |>
  mutate(
    lon_255 = rescale(abacura_pca$lon, from = c(min(abacura_pca$lon), max(abacura_pca$lon)), to = c(0, 255)),
    lat_255 = rescale(abacura_pca$lat, from = c(min(abacura_pca$lat), max(abacura_pca$lat)), to = c(0, 255)),
    lon_red = rgb(lon_255,0,0, maxColorValue = 255),
    lat_blue = rgb(0,0,lat_255, maxColorValue = 255),
    lon_lat_mix = rgb(lon_255,0,lat_255, maxColorValue = 255)
  )

abacura_pca <- abacura_pca |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

abacura_val <- abacura_val |>
  rename("eigenval" = X1) |>
  mutate(PC = c(paste0("PC", 1:20)),
         percent = eigenval/sum(eigenval)*100)

Sdekayi_pca <- Sdekayi_pca |>
  mutate(
    lon_255 = rescale(Sdekayi_pca$lon, from = c(min(Sdekayi_pca$lon), max(Sdekayi_pca$lon)), to = c(0, 255)),
    lat_255 = rescale(Sdekayi_pca$lat, from = c(min(Sdekayi_pca$lat), max(Sdekayi_pca$lat)), to = c(0, 255)),
    lon_red = rgb(lon_255,0,0, maxColorValue = 255),
    lat_blue = rgb(0,0,lat_255, maxColorValue = 255),
    lon_lat_mix = rgb(lon_255,0,lat_255, maxColorValue = 255)
  )

Sdekayi_pca <- Sdekayi_pca |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

Sdekayi_val <- Sdekayi_val |>
  rename("eigenval" = X1) |>
  mutate(PC = c(paste0("PC", 1:20)),
         percent = eigenval/sum(eigenval)*100)

ltri_pca <- ltri_pca |>
  mutate(
    lon_255 = rescale(ltri_pca$lon, from = c(min(ltri_pca$lon), max(ltri_pca$lon)), to = c(0, 255)),
    lat_255 = rescale(ltri_pca$lat, from = c(min(ltri_pca$lat), max(ltri_pca$lat)), to = c(0, 255)),
    lon_red = rgb(lon_255,0,0, maxColorValue = 255),
    lat_blue = rgb(0,0,lat_255, maxColorValue = 255),
    lon_lat_mix = rgb(lon_255,0,lat_255, maxColorValue = 255)
  )

ltri_pca <- ltri_pca |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

ltri_val <- ltri_val |>
  rename("eigenval" = X1) |>
  mutate(PC = c(paste0("PC", 1:20)),
         percent = eigenval/sum(eigenval)*100)

#ltri figures
ggplot(ltri_pca, aes(x = PC1, y = PC2, color = lat_blue)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Latitude"
  ) +
  scale_color_identity()

ggplot(ltri_pca, aes(x = PC1, y = PC2, color = lon_red)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA",
    x = "PC1",
    y = "PC2",
    color = "Longitude"
  ) +
  scale_color_identity()

ggplot(ltri_pca, aes(x = PC1, y = PC2, color = lon_lat_mix)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA for *L. triangulum*",
    x = paste("PC1", round(ltri_val[1,3], 2), "%"),
    y = paste("PC2", round(ltri_val[2,3], 2), "%"),
    color = "Latitude + Longitude mix"
  ) +
  scale_color_identity() +
  theme(plot.title = ggtext::element_markdown())
ggsave(filename = "ltri_pca_mix.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = ltri_pca, aes(color = lat_blue)) +
  xlim((min(ltri_pca$lon)-2.5), max(ltri_pca$lon)+2.5) +
  ylim(min(ltri_pca$lat-2.5), max(ltri_pca$lat)+2.5) +
  scale_color_identity()

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = ltri_pca, aes(color = lon_red)) +
  xlim((min(ltri_pca$lon)-2.5), max(ltri_pca$lon)+2.5) +
  ylim(min(ltri_pca$lat-2.5), max(ltri_pca$lat)+2.5) +
  scale_color_identity() +
  labs(
    title = "L. triangulum complex",
    x = "longitude",
    y = "latitude",
    color = "Latitude"
  )

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = Mexico_map) +
  geom_sf(data = Canada_map) +
  geom_sf(data = ltri_pca, aes(color = lon_lat_mix)) +
  xlim((min(ltri_pca$lon)-2.5), max(ltri_pca$lon)+2.5) +
  ylim(min(ltri_pca$lat-2.5), max(ltri_pca$lat)+2.5) +
  scale_color_identity() +
  labs(
    x = "longitude",
    y = "latitude"
  )
ggsave(filename = "ltri_map_mix.png", path = fig_path)

# abacura figures

ggplot(abacura_pca, aes(x = PC1, y = PC2, color = lon_lat_mix)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA for *F. abacura*",
    x = paste("PC1", round(abacura_val[1,3], 2), "%"),
    y = paste("PC2", round(abacura_val[2,3], 2), "%"),
    color = "Latitude + Longitude mix"
  ) +
  scale_color_identity() +
  theme(plot.title = ggtext::element_markdown())
ggsave(filename = "abacura_pca_mix.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = abacura_pca, aes(color = lon_lat_mix)) +
  xlim((min(abacura_pca$lon)-2.5), max(abacura_pca$lon)+2.5) +
  ylim(min(abacura_pca$lat-2.5), max(abacura_pca$lat)+2.5) +
  scale_color_identity() +
  labs(
    x = "longitude",
    y = "latitude"
  )
ggsave(filename = "abacura_map_mix.png", path = fig_path)

# Sdekayi figures

ggplot(Sdekayi_pca, aes(x = PC1, y = PC2, color = lon_lat_mix)) +
  geom_point(size = 3) +
  theme_classic() +
  labs(
    title = "Population Structure PCA for *S. Dekayi*",
    x = paste("PC1", round(Sdekayi_val[1,3], 2), "%"),
    y = paste("PC2", round(Sdekayi_val[2,3], 2), "%"),
    color = "Latitude + Longitude mix"
  ) +
  scale_color_identity() +
  theme(plot.title = ggtext::element_markdown())
ggsave(filename = "Sdekayi_pca_mix.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = Sdekayi_pca, aes(color = lon_lat_mix)) +
  xlim((min(Sdekayi_pca$lon)-2.5), max(Sdekayi_pca$lon)+2.5) +
  ylim(min(Sdekayi_pca$lat-2.5), max(Sdekayi_pca$lat)+2.5) +
  scale_color_identity() +
  labs(
    x = "longitude",
    y = "latitude"
  )
ggsave(filename = "Sdekayi_map_mix.png", path = fig_path)
