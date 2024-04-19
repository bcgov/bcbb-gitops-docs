#!/bin/sh

pandoc *.md -o mfin-data-catalogue.pdf --from markdown --template eisvogel --listings --toc
