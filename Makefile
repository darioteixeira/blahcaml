.PHONY: all

.DEFAULT all:
	make $(MAKECMDGOALS) -C blahtexcore
	make $(MAKECMDGOALS) -C unicodeconverter
	make $(MAKECMDGOALS) -C blahcaml

