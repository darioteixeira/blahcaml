#
# Configuration options.
#

PKG_NAME=blahcaml

SRC=src
APIDOCDIR=doc/apidoc

BLAHTEXCORE_DIR=$(SRC)/blahtexcore
UNICODECONVERTER_DIR=$(SRC)/unicodeconverter
MESSAGES_DIR=$(SRC)/messages

MATHML2DTD_DIR=$(SRC)/mathml2dtd
MATHML2DTD_TARGETS=$(shell make targets -s -C $(MATHML2DTD_DIR))
MATHML2DTD_FQTARGETS=$(foreach TARGET, $(MATHML2DTD_TARGETS), $(MATHML2DTD_DIR)/$(TARGET))

BLAHCAML_DIR=$(SRC)/blahcaml
BLAHCAML_TARGETS=$(shell make targets -s -C $(BLAHCAML_DIR))
BLAHCAML_FQTARGETS=$(foreach TARGET, $(BLAHCAML_TARGETS), $(BLAHCAML_DIR)/$(TARGET))

FQTARGETS=$(MATHML2DTD_FQTARGETS) $(BLAHCAML_FQTARGETS)


#
# Rules.
#

all: lib

lib:
	make lib -C $(BLAHTEXCORE_DIR)
	make lib -C $(UNICODECONVERTER_DIR)
	make lib -C $(MESSAGES_DIR)
	make lib -C $(MATHML2DTD_DIR)
	make lib -C $(BLAHCAML_DIR)

apidoc: lib $(MATHML2DTD_DIR)/mathml2dtd.mli $(BLAHCAML_DIR)/blahcaml.mli $(BLAHCAML_DIR)/blahcaml.ml
	mkdir -p $(APIDOCDIR)
	ocamlfind ocamldoc -package pxp-engine,pxp-ulex-utf8 -I $(MATHML2DTD_DIR) -I $(BLAHCAML_DIR) -html -d $(APIDOCDIR) $(MATHML2DTD_DIR)/mathml2dtd.mli $(BLAHCAML_DIR)/blahcaml.mli $(BLAHCAML_DIR)/blahcaml.ml

install: lib
	ocamlfind install $(PKG_NAME) META $(FQTARGETS)

uninstall:
	ocamlfind remove $(PKG_NAME)

reinstall: lib
	ocamlfind remove $(PKG_NAME)
	ocamlfind install $(PKG_NAME) META $(FQTARGETS)

clean:
	make clean -C $(BLAHTEXCORE_DIR)
	make clean -C $(UNICODECONVERTER_DIR)
	make clean -C $(MESSAGES_DIR)
	make clean -C $(MATHML2DTD_DIR)
	make clean -C $(BLAHCAML_DIR)

distclean: clean
	rm -rf $(APIDOCDIR)

