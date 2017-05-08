# CSOB pdf do JSON

Na popud Michala Blahy (https://twitter.com/michalblaha/status/861227801206292480)

## Pozadavky

* xpdf (`brew install xpdf` na osx)
* ruby 2.2.0+

## Prevod pdf do textu

`pdftotext -table -nopgbrk -enc UTF-8 ./vypis.pdf ./pdf.txt`

## Prevod textu do json

`ruby csob2json.rb pdf.txt`
