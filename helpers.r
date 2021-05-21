library(ggmap)
library(stringr)
library(raster)

# lat/lon computation ----
station <- fread("shiny/data/stations.csv")
station$'전철역명' <- ifelse(str_detect(station$'전철역명', "역"), station$'전철역명', paste0(station$'전철역명', "역"))
station_latlon = mutate_geocode(station, 전철역명)

# Shapefile (Seoul) ----
korea <- shapefile('TL_SCCO_SIG.shp') %>%
  spTransform(CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
korea$SIG_KOR_NM <- iconv(korea$SIG_KOR_NM, from = "CP949", to = "UTF-8", sub = NA, mark = TRUE, toRaw = FALSE) # change encoding
korea <- fortify(korea, region='SIG_CD')
korea$id <- as.numeric(korea$id)
seoul_map <- korea[korea$id <= 11740, ]

# Background map ----  
p <- get_googlemap("seoul", zoom = 11) %>% ggmap()

save.image(file="shiny/data/station_latlon.RData")

