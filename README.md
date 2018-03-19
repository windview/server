# WindView

## Pre-requisites

  * Ruby 2.5.0-p0
  * Bundler 1.16.1
  * PostgreSQL 9.6

## First Build

  * bundle
  * rails db:create
  * rails db:migrate
  * rails db:seed

## Run Tests

```
$ rake test
```

## Run server

```
$ rails s
```

## URLs

  * API Root: http://localhost:3000/api
      * to list the seeded forcasts http://localhost:3000/api/forecasts
  * Swagger API Doc: http://localhost:3000/apidocs

## Checking Quality

### Test Coverage

**TODO**


## Included Examples

### ARGUS-PRIMA forecasts for 12 WIND Toolkit Sites

#### Load sites

```bash
$ rails load:wtk_sites[examples/argus_prima-wtk12/sites.geojson] 
Loading sites from examples/argus_prima-wtk12/sites.geojson...
Loaded 12 of 12 sites.
```

#### Load forecasts

```bash
$ rails load:forecasts[argusprima,examples/argus_prima-wtk12/forecasts]
Loading files from examples/argus_prima-wtk12/forecasts...
Loaded 24 forecasts from 24 files.
```

### ARGUS-PRIMA forecasts for 229 WIND Toolkit Sites in Texas

The texas example is a little different. We selected 228 sites from all those found in Texas. The
forecasts files are actually day-ahead forecasts for a few months. What we do is create 8 forecasts
based on the last week of data from each file. Seven of the forecasts are day-ahead forecasts for that last week.
The other one is a fictional week-ahead using the same data as each day-ahead.

#### Load sites

** WIP **

```bash
$ rails load:wtk_sites[examples/argus_prima-wtk_texas_under_10mw/sites.geojson] 
Loading sites from examples/argus_prima-wtk_texas_under_10mw/sites.geojson...
Loaded 229 of 229 sites
```

#### Generate forecasts

** NOT WORKING YET **
```bash
$ rails gen_forecasts:texas[argusprima,./examples/argus_prima-wtk_texas_under_10mw/forecasts]
Loading files from ./examples/argus_prima-wtk_texas_under_10mw/forecasts... 
Loaded 457 week-ahead forecasts and 3199 day-ahead forecasts from 457 files.
XAJA|Loaded 1832 forecasts for 229 forecast files.
```

### ARGUS-PRIMA demo data for WIND Toolkit Sites

### Download WIND Toolkit data

1. Go to https://maps.nrel.gov/wind-prospector/?visible=wind_3tier_site_metadata#/?aL=p7FOkl%255Bv%255D%3Dt&amp;bL=groad&amp;cE=0&amp;lR=0&amp;mC=40.21244%2C-91.625976&amp;zL=4
2. Click the down arrow icon next to the "Wind Toolkit" layer
3. Click on the GeoJSON button
4. Copy the downloaded file, nrel-wind_3tier_site_metadata.json, to the data directory
