#
# Configuration options.
#

PKG_NAME=blahcaml

META_FILE=src/META

MATHML2DTD_DIR=src/mathml2dtd
MATHML2DTD_TARGETS=$(shell make targets -s -C $(MATHML2DTD_DIR))
MATHML2DTD_FQTARGETS=$(foreach TARGET, $(MATHML2DTD_TARGETS), $(MATHML2DTD_DIR)/$(TARGET))

BLAHTEXCORE_DIR=src/blahtexcore

UNICODECONVERTER_DIR=src/unicodeconverter

BLAHCAML_DIR=src/blahcaml
BLAHCAML_TARGETS=$(shell make targets -s -C $(BLAHCAML_DIR))
BLAHCAML_FQTARGETS=$(foreach TARGET, $(BLAHCAML_TARGETS), $(BLAHCAML_DIR)/$(TARGET))

FQTARGETS=$(MATHML2DTD_FQTARGETS) $(BLAHCAML_FQTARGETS)


#
# Rules.
#

all: lib

lib:
	make lib -C $(MATHML2DTD_DIR)
	make lib -C $(BLAHTEXCORE_DIR)
	make lib -C $(UNICODECONVERTER_DIR)
	make lib -C $(BLAHCAML_DIR)

apidoc: lib
	mkdir -p doc/apidoc
	make apidoc -C $(BLAHCAML_DIR)

install: lib
	ocamlfind install $(PKG_NAME) $(META_FILE) $(FQTARGETS)

uninstall:
	ocamlfind remove $(PKG_NAME)

reinstall: lib
	ocamlfind remove $(PKG_NAME)
	ocamlfind install $(PKG_NAME) $(META_FILE) $(FQTARGETS)

clean:
	make clean -C $(MATHML2DTD_DIR)
	make clean -C $(BLAHTEXCORE_DIR)
	make clean -C $(UNICODECONVERTER_DIR)
	make clean -C $(BLAHCAML_DIR)

dist: clean
	rm -rf doc/apidoc

