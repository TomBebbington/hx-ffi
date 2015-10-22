#! /bin/sh
haxe doc.hxml
haxelib run dox -i doc/doc.xml -o doc --title "Haxe FFI - bind to dynamic libraries with ease"
git add -A .
git commit -am "Update documentation"
git subtree push --prefix doc origin gh-pages