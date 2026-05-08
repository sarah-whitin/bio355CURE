#load packages
library(dplyr)
library(utils)
library(sf)
library(ggplot2)

#load data
results_path <- "/Users/classes/bio355b/CURE_projects/tbontb/results"
data_path <- "/Users/classes/bio355b/CURE_projects/tbontb/snake_data_raw"
fig_path <- "/Users/classes/bio355b/CURE_projects/tbontb/figures"

abacura_clusters <- read.csv(file.path(results_path, "a_clusters.csv"))
sdekayi_clusters <- read.csv(file.path(results_path, "s_clusters.csv"))
ltri_clusters <- read.csv(file.path(results_path, "l_result.csv"))
ltri_clusters <- rename(ltri_clusters, INDV = ID)

all_coords_requested <- read_csv(file.path(data_path, "all_coords_requested.csv"))
all_coords_requested <- rename(all_coords_requested, INDV = number)

#data processing
abacura_clusters <- left_join(abacura_clusters, all_coords_requested, by = "INDV")
sdekayi_clusters <- left_join(sdekayi_clusters, all_coords_requested, by = "INDV")
ltri_clusters <- left_join(ltri_clusters, all_coords_requested, by = "INDV")

abacura_clusters <- abacura_clusters |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)
sdekayi_clusters <- sdekayi_clusters |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)
ltri_clusters <- ltri_clusters |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

#load map data
usa_map <- tidycensus::get_acs(geography = "state", 
                               variables = "B01003_001", 
                               geometry = TRUE) |>
  st_transform(crs = 4326)

Mexico_map <-  maps::map(region = "Mexico", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

Canada_map <-  maps::map(region = "Canada", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

#figures
ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = abacura_clusters, aes(color = as.factor(Cluster), alpha = 0.5)) +
  xlim((min(abacura_clusters$lon)-2.5), max(abacura_clusters$lon)+2.5) +
  ylim(min(abacura_clusters$lat-2.5), max(abacura_clusters$lat)+2.5) +
  scale_color_discrete(palette = c("blue", "yellow", "red")) +
  labs(
    x = "longitude",
    y = "latitude",
    color = "DPCA Clusters"
  ) +
  scale_alpha(guide = 'none') +
  theme(legend.title=element_blank())
ggsave(filename = "abacura_cluster_map.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = sdekayi_clusters, aes(color = as.factor(Cluster), alpha = 0.5)) +
  xlim((min(sdekayi_clusters$lon)-2.5), max(sdekayi_clusters$lon)+2.5) +
  ylim(min(sdekayi_clusters$lat-2.5), max(sdekayi_clusters$lat)+2.5) +
  scale_color_discrete(palette = c("blue", "burlywood3","yellow", "red")) +
  labs(
    x = "longitude",
    y = "latitude",
    color = "DPCA Clusters"
  ) +
  scale_alpha(guide = 'none') +
  theme(legend.title=element_blank())
ggsave(filename = "sdekayi_cluster_map.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = Mexico_map) +
  geom_sf(data = Canada_map) +
  geom_sf(data = ltri_clusters, aes(color = as.factor(Value), alpha = 0.5)) +
  xlim((min(ltri_clusters$lon)-2.5), max(ltri_clusters$lon)+2.5) +
  ylim(min(ltri_clusters$lat-2.5), max(ltri_clusters$lat)+2.5) +
  scale_color_discrete(palette = c("darkblue",
                                   "purple",
                                   "green",
                                   "orange",
                                   "red",
                                   "blue", 
                                   "yellow",
                                   "lightblue",
                                   "darkgreen",
                                   "brown",
                                   "grey",
                                   "pink")) +
  labs(
    x = "longitude",
    y = "latitude",
    color = "DPCA Clusters"
  ) +
  scale_alpha(guide = 'none') +
  theme(legend.title=element_blank())
ggsave(filename = "ltri_cluster_map.png", path = fig_path)