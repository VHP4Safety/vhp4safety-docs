
# Minimal makefile for Sphinx documentation
#

# get origin (docs from github 'cloud' repo)
origin: $(eval SHELL:=/bin/bash)
	curl -L -o origin/main.zip https://github.com/VHP4Safety/cloud/archive/refs/heads/main.zip
	unzip origin/main.zip -d origin/unzipped/

OUT="service"
IN="origin/unzipped/cloud-main/docs/service"

build_from_origin: $(eval SHELL:=/bin/bash)
	pandoc --from=markdown --to=markdown --output="$(OUT)/aopwiki.md" "$(IN)/aopwiki.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/cdkdepict.md" "$(IN)/cdkdepict.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/sysrev.md" "$(IN)/sysrev.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/bridgedb.md" "$(IN)/bridgedb.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/decimer.md" "$(IN)/decimer.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/popgen.md" "$(IN)/popgen.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/txg_mapr.md" "$(IN)/txg_mapr.md"
	pandoc --from=markdown --to=markdown --output="$(OUT)/wikibase.md" "$(IN)/wikibase.md"

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
	rm -rf catalog.md
	rm -rf catalog.rst
	curl -o tmp/catalog.md https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/catalog.md
#	mdToRst catalog.md | tee Services/catalog.rst
	pandoc --from=markdown --to=rst --output=catalog.rst tmp/catalog.md
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
