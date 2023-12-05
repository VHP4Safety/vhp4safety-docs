
# Minimal makefile for Sphinx documentation
# get github repos (cloud en tutorials)
origin: $(eval SHELL:=/bin/bash)
	rm -rf origin
	mkdir origin
	curl -L -o origin/cloud-main.zip https://github.com/VHP4Safety/cloud/archive/refs/heads/main.zip
	unzip origin/cloud-main.zip -d origin/unzipped-cloud/
	curl -L -o origin/tutorials-main.zip https://github.com/VHP4Safety/vhp4safety-tutorials/archive/refs/heads/main.zip
	unzip origin/tutorials-main.zip -d origin/unzipped-tutorials/
	export OUT-SERVICE="service"
	export IN-SERVICE="origin/unzipped-cloud/cloud-main/docs/service"
	export OUT-TUTORIALS = "tutorials"
	export IN-TUTORIALS = "origin/unzipped-tutorials/tutorials-main"

#build_from_origin: $(eval SHELL:=/bin/bash)
## services
#	pandoc --from=markdown --to=rst --output="$(OUT)/aopwiki/intro.rst" "$(IN)/aopwiki.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/cdkdepict/intro.rst" "$(IN)/cdkdepict.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/sysrev/intro.rst" "$(IN)/sysrev.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/bridgedb/intro.rst" "$(IN)/bridgedb.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/decimer/intro.rst" "$(IN)/decimer.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/popgen/intro.rst" "$(IN)/popgen.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/txg_mapr/intro.rst" "$(IN)/txg_mapr.md"
#	pandoc --from=markdown --to=rst --output="$(OUT)/wikibase/intro.rst" "$(IN)/wikibase.md"

## tutorials

# update metadata
metadata: 
	python service/aopwiki/meta.py
	python service/cdkdepict/meta.py
	python service/sysrev/meta.py
	python service/decimer/meta.py
	python service/popgen/meta.py
	python service/txg_mapr/meta.py
	python service/wikibase/meta.py

# get images
images: $(eval SHELL:=/bin/bash)
	curl -o service/aopwiki/aopwiki.png https://github.com/VHP4Safety/cloud/raw/main/docs/service/aopwiki.png
	

# update catalog and clean up
catalog: $(eval SHELL:=/bin/bash)
	rm -rf tmp
	mkdir tmp
	rm -rf catalog.md
	rm -rf service/catalog.rst
	curl -o tmp/catalog.md https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/catalog.md
#	mdToRst catalog.md | tee Services/catalog.rst
	pandoc --from=markdown --to=rst --output=service/catalog.rst tmp/catalog.md
	rm -rf tmp/catalog.md

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
