#!/bin/sh
set -e
rm -f sui.zip
zip -r sui.zip src test css/sui.css extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit sui.zip -x
