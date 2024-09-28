#/bin/bash

export CLANG_VERSION=14

cd qml/pages
qmlformat -V -i *.qml
cd ../..

cd qml/components
qmlformat -V -i *.qml
cd ../..

cd qml/cover
qmlformat -V -i *.qml
cd ../..

