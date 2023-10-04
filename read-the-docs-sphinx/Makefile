
# Minimal makefile for Sphinx documentation
#

# get origin (docs from github 'cloud' repo)
origin: $(eval SHELL:=/bin/bash)
	curl -L -o origin/main.zip https://github.com/VHP4Safety/cloud/archive/refs/heads/main.zip
	unzip origin/main.zip -d origin/unzipped/

OUT="Services"
IN="origin/unzipped/cloud-main/docs/service"

build_from_origin: $(eval SHELL:=/bin/bash)
	pandoc --from=markdown --to=rst --output="$(OUT)/aopwiki/intro.rst" "$(IN)/aopwiki.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/cdkdepict/intro.rst" "$(IN)/cdkdepict.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/sysrev/intro.rst" "$(IN)/sysrev.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/bridgedb/intro.rst" "$(IN)/bridgedb.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/decimer/intro.rst" "$(IN)/decimer.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/popgen/intro.rst" "$(IN)/popgen.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/txg_mapr/intro.rst" "$(IN)/txg_mapr.md"
	pandoc --from=markdown --to=rst --output="$(OUT)/wikibase/intro.rst" "$(IN)/wikibase.md"

# update metadata
metadata: 
	python Services/aopwiki/meta.py
	python Services/cdkdepict/meta.py
	python Services/sysrev/meta.py
	python Services/decimer/meta.py
	python Services/popgen/meta.py
	python Services/txg_mapr/meta.py
	python Services/wikibase/meta.py

# get images
images: $(eval SHELL:=/bin/bash)
	curl -o Services/aopwiki/aopwiki.png https://github.com/VHP4Safety/cloud/raw/main/docs/service/aopwiki.png
	

# update catalog and clean up
catalog: $(eval SHELL:=/bin/bash)
	rm -rf catalog.md
	rm -rf Services/catalog.rst
	curl -o tmp/catalog.md https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/catalog.md
#	mdToRst catalog.md | tee Services/catalog.rst
	pandoc --from=markdown --to=rst --output=Services/catalog.rst tmp/catalog.md
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
