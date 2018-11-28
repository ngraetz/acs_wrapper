## Test workflow for ACS microsimulation.

# for(p in c('RANN', 'scales', 'matrixStats', 'fastmatch', 'stringr', 'rmapshaper', 'feather', 'data.table', 'sf', 'tigris', 'tidycensus', 'tidyverse')) {
#  install.packages(p,character.only=T)
# }
# census_api_key('ecae108da10a8741591e6bdda9aee2c1cb438538', install = TRUE)
# missing required dependencies from above: automap, lwgeom
library(viridis)

## 01. Get ACS data.
Sys.getenv("CENSUS_API_KEY")
d <- getBlockGroupData(state = 'WA', county_code = '033')

ggplot(d[[1]]) +
  geom_sf(aes(fill = Percent.of.population.below.poverty.line)) +
  scale_fill_viridis("Poverty") +
  ggtitle("Poverty") +
  theme_bw()

## 02. Aggregate block groups.
d_agg <- aggregateBlockGroups(bg_data = d, cv.thresh = 0.30, coh.thresh = 0.50)
max(d_agg$geo$region)
plot(d_agg$geo["region"])

## 03. Generate weights
##  - createFeather(): One-time operation to import unadulterated .csv PUMS microdata
##                     files and save the results to disk as .feather files. This step improves performance
##                     when batch processing many states with processPUMS, but is not strictly necessary.
##  - processPUMS(): Pre-processes PUMS data to create household and person datasets that
##                   contain constructed variables necessary for the sample reweighting procedure.
## Problem with createFeather... seems to not be parsing correctly at this line:
## invisible(code <- capture.output(get("processPUMSinternal")))
hus.WA <- fread("C:/Users/Nick/Downloads/csv_hwa/ss16hwa.csv")
pus.WA <- fread("C:/Users/Nick/Downloads/csv_pwa/ss16pwa.csv")
pums <- processPUMS(state = 'WA',
                    hus = hus.WA,
                    pus = pus.WA)
## Problem with class of "hid" - needs to be numeric or character (mine were integer64).
pums[[1]]$hid <- as.numeric(pums[[1]]$hid)
pums[[2]]$hid <- as.numeric(pums[[2]]$hid)
result <- generateRegionWeights(aggregation_object = d_agg, processed_pums = pums)
# Examine how the weighted sample margins compare to the actual margins
View(result$`1`$margins)



