#! /bin/bash

LICENSE_HEADER="`pwd`/licenseheader.txt"
SRC_FILES="`find src -type f -name *.h -o -name *.m`"

for f in $SRC_FILES; do
  echo "Checking $f"
  head -n 20 $f | diff $LICENSE_HEADER - || ( cat $LICENSE_HEADER $f > /tmp/headerfile.txt; mv /tmp/headerfile.txt $f ) 
done
