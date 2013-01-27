#! /bin/bash

LICENSE_HEADER="`pwd`/licenseheader.txt"
SRC_FILES="`find src -type f -name *.h -o -name *.m`"

function checkforlicense {
  head $1 | diff $LICENSE_HEADER -  
}

for f in $SRC_FILES; do
  if ! grep -q Copyright $f; then
    echo "Adding license to $f"
    cat $LICENSE_HEADER $f > /tmp/file
    mv /tmp/file $f
  fi
done
