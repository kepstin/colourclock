.PHONY: all

all:

%.gz : %
	gzip -9 < $< > $@

public/index.html.gz: public/index.html
public/colors.js.gz: public/colors.js


all: public/index.html.gz public/colors.js.gz
