.PHONY: all

.DEFAULT all:
	make $(MAKECMDGOALS) -C blahtexcore
	make $(MAKECMDGOALS) -C uconv
	make $(MAKECMDGOALS) -C blahcaml

