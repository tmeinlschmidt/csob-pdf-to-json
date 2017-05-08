# CSOB pdf do JSON

## Pozadavky

* xpdf

## Prevod pdf do textu

`pdftotext -table -nopgbrk -enc UTF-8 ./vypis.pdf ./pdf.txt`

## Prevod textu do json

`ruby csob2json.rb pdf.txt`
