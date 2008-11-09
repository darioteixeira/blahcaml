.PHONY: all

.DEFAULT all:
	make $(MAKECMDGOALS) -C src/mathml2dtd
	make $(MAKECMDGOALS) -C src/blahtexcore
	make $(MAKECMDGOALS) -C src/unicodeconverter
	make $(MAKECMDGOALS) -C src/blahcaml

