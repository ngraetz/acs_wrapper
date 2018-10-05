## Test workflow for ACS microsimulation.

# for(p in c('RANN', 'scales', 'matrixStats', 'fastmatch', 'stringr', 'rmapshaper', 'feather', 'data.table', 'sf', 'tigris', 'tidycensus', 'tidyverse')) {
#  install.packages(p,character.only=T)
# }
# census_api_key('ecae108da10a8741591e6bdda9aee2c1cb438538', install = TRUE)
# missing required dependencies from above: automap
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
