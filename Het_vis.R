#necessary packages
library(leaflet)
library(sf)
library(tidycensus)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggExtra)

#path + data
out_path <- "/Users/classes/bio355b/CURE_projects/tbontb/data_processed"
fig_path <- "/Users/classes/bio355b/CURE_projects/tbontb/figures"
abacura_het_coords <- read.csv(file.path(out_path, "abacura_het_coords"))
ltri_het_coords <- read.csv(file.path(out_path, "ltri_het_coords"))
sdekayi_het_coords <- read.csv(file.path(out_path, "sdekayi_het_coords"))

#map components
usa_map <- tidycensus::get_acs(geography = "state", 
                               variables = "B01003_001", 
                               geometry = TRUE) |>
            st_transform(crs = 4326)

Mexico_map <-  maps::map(region = "Mexico", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

Canada_map <-  maps::map(region = "Canada", plot = FALSE, fill = TRUE) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

#data processing
abacura_het_coords <- abacura_het_coords |>
  select(INDV, prop_o_het, lon, lat) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

ltri_het_coords <- ltri_het_coords |>
  select(INDV, prop_o_het, lon, lat) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

sdekayi_het_coords <- sdekayi_het_coords |>
  select(INDV, prop_o_het, lon, lat) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)

#maps + plots
ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = abacura_het_coords, aes(color = prop_o_het)) +
  xlim((min(abacura_het_coords$lon)-2.5), max(abacura_het_coords$lon)+2.5) +
  ylim(min(abacura_het_coords$lat-2.5), max(abacura_het_coords$lat)+2.5) +
  scale_color_gradientn(colours = colorRampPalette(c("blue", "red"))(10)) +
  theme(plot.title = ggtext::element_markdown(),
        legend.title=element_blank()) +
  labs(
    title = "Proportion of Observed Heterozygosity in *F. abacura*",
    x = "longitude",
    y = "latitude"
  )

ggsave(filename = "abacura_het_map.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = Mexico_map) +
  geom_sf(data = Canada_map) +
  geom_sf(data = ltri_het_coords, aes(color = prop_o_het)) +
  xlim((min(ltri_het_coords$lon)-2.5), max(ltri_het_coords$lon)+2.5) +
  ylim(min(ltri_het_coords$lat-2.5), max(ltri_het_coords$lat)+2.5) +
  scale_color_gradientn(colours = colorRampPalette(c("blue", "red"))(10)) +
  theme(plot.title = ggtext::element_markdown(),
        legend.title=element_blank()) +
  labs(
    title = "Proportion of Observed Heterozygosity in *L. triangulum*",
    x = "longitude",
    y = "latitude"
  )

ggsave(filename = "ltri_het_map.png", path = fig_path)

ggplot() +
  geom_sf(data = usa_map) +
  geom_sf(data = sdekayi_het_coords, aes(color = prop_o_het)) +
  xlim((min(sdekayi_het_coords$lon)-2.5), max(sdekayi_het_coords$lon)+2.5) +
  ylim(min(sdekayi_het_coords$lat-2.5), max(sdekayi_het_coords$lat)+2.5) +
  scale_color_gradientn(colours = colorRampPalette(c("blue", "red"))(10)) +
  theme(plot.title = ggtext::element_markdown(),
        legend.title=element_blank()) +
  labs(
    title = "Proportion of Observed Heterozygosity in *S. Dekayi*",
    x = "longitude",
    y = "latitude"
  )

ggsave(filename = "sdekayi_het_map.png", path = fig_path)