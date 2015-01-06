.PHONY: all

all: node_modules bower_components

node_modules:
	@echo "Please run 'npm install' first"; false

.PHONY: bower_components

bower_components: node_modules
	node_modules/.bin/bower install

BOWER_LIBS= \
	bower_components/moment/min/moment.min.js \
	bower_components/moment-timezone/builds/moment-timezone-with-data-2010-2020.min.js

$(BOWER_LIBS): bower_components

%.gz : %
	gzip -9 < $< > $@

public/concat.js: $(BOWER_LIBS) lib/colors.js
	cat $^ >$@

all: public/index.html.gz public/concat.js.gz
