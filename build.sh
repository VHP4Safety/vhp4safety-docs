#!/bin/bash
rm -rf _build 
make origin &&
#make build_from_origin &&
make images &&
make catalog &&
make metadata &&
make html
