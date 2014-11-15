#!/bin/sh
set -e
rm -f sui.zip
zip -r sui.zip src test extraParams.hxml haxelib.json LICENSE README.md
haxelib submit sui.zip