#!/bin/bash

rake db:drop && \
rake db:create && \
rake db:migrate && \
rake db:seed && \
rake load:wtk_sites[examples/argus_prima-wtk_texas_under_10mw/sites.geojson] && \
rake load:texas
