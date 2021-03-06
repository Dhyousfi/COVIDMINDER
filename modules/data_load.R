# Import states json
states.shapes <- readRDS("data/json/us_projection.Rds")

# Import NY shape
NY.shape <- readRDS("data/shape_files/NY.Rds")

# Data structure modifed 08 Apr
#NY.tests <- read_csv("data/csv/time_series/NY_county_tests.csv")
NY.tests <- read_csv("data/csv/time_series/NY_county_data.csv")

NY.deaths.cases <- read_csv("data/csv/time_series/covid_NY_counties.csv")

# Update with manual deaths; don't use new date field (yet) - Testing without
#covid_NY_counties.deaths <- read_csv("data/csv/time_series/covid_NY_counties.deaths.manual.csv") %>%
#  select(county, deaths)

# Import county regions and join them is
NY_counties_regions <- read_csv("data/csv/time_series/NY_counties_regions.csv")

# Import NY Diabetes 
NY_counties_diabetes <- read_csv("data/csv/time_series/NY_counties_diabetes.csv")

#NY.deaths.cases <- dplyr::inner_join(NY.deaths.cases[,-2], covid_NY_counties.deaths, by = c("county" = "county"))

NY.data <- dplyr::inner_join(as.data.frame(NY.tests), as.data.frame(NY.deaths.cases), by = c("County" = "county"))

NY.data <- dplyr::inner_join(NY.data, as.data.frame(NY_counties_diabetes[,c(2,3,6)]), by = c("County" = "County"))

NY.data <- dplyr::inner_join(NY.data, as.data.frame(NY_counties_regions), by = c("County" = "County"))

NY.data$FIPS <- as.character(NY.data$FIPS)

# Convert to dataframe state data
states <- states.shapes
states <- data.frame(states)
states <- states[c("fips_state", "name")]
colnames(states) <- c("FIPS", "NAME")

# Import population data
population <- read_csv("data/csv/population.csv")

# Import provider capacity data
provider_capacity <- read_csv("data/csv/provider_capacity.csv")

# Import state testing data
state_covid_testing <- read_csv("data/csv/state_covid_testing.csv")

# Import at risk adults data
# (NOTE: THis includes all at-risk and share of at-risk over 60)
at_risk_adults <- read_csv("data/csv/at_risk_adults.csv") 

# Import cardio data (NEW)
# UPDATED: 16 Apr (new source!)
#cardio_deaths_2017 <- read_csv("data/csv/cardio_deaths_2017.csv")
# NOTE: Includes ethnicities; already in p_100K format
cardio_deaths_2015 <- read_csv("data/csv/HeartDisease_DeathRate_States_CDC_2015.csv")

# Import COVID-19 Cases & Deaths data
covid_data_states <- read_csv("data/csv/covid_data_states.csv")

# join in population column
covid_data_states <- left_join(covid_data_states, population, by = c('NAME'))

# NEW: Need to calculate these because JHU data doesn't pre-calculate
covid_data_states$calc_case_rate <- covid_data_states$covid19_cases/covid_data_states$Population
covid_data_states$calc_death_rate <- covid_data_states$covid19_deaths/covid_data_states$Population

# Divide-by-mil only needed for KFF data
# covid_data_states$p_death_rate <- covid_data_states$deaths_per_mil/1000000
covid_data_states$p_death_rate <- covid_data_states$calc_death_rate

# Import US Diabetes data
# Diabetes is a comorbitity of severe COVID-19 cases
diabetes_data_states <- read_csv("data/csv/diabetes_data_states.csv")

# Import US Obesity data: see https://stateofchildhoodobesity.org/adult-obesity/
# Obesity is a comorbitity of severe COVID-19 cases
obesity_data_states <- read_csv("data/csv/obesity_data_states.csv")

# Import NYS TS cases (for plotting) 
covid_NY_TS_counties_long <- read_csv("data/csv/time_series/covid_NY_TS_counties_long.csv")
covid_NY_TS_counties_long.cases <- read_csv("data/csv/time_series/covid_NY_TS_counties_long.cases.csv")

covid_NY_TS_plot.cases <- read_csv("data/csv/time_series/covid_NY_TS_plot.cases.csv")

# Import per-state per-race disparity data
covid_racial_data_states.wide <- read_csv("data/csv/states_cdc_racial_wide.csv")

# Important per-state legislative and EO data
covid_eo_bills <- read_csv("data/csv/Covid_EO.csv")

# Test rates from countries we are comparing to 
total_test_rates.df <- read_csv("data/csv/owid_glb_test_rates.csv")

# Obesity rates from countries we are comparing to
owid_data.obesity.rate <- read.csv("data/csv/owid_obese_pct_2016.csv")
colnames(owid_data.obesity.rate) <- c("Entity", "Code", "Year", "Pct_obese_adult")
