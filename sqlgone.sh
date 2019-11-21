#!/bin/bash

# dotCMS Engineering
#
# Maintainer: dEC <support@dotcms.com>
#

# Regex for the tables that are going to be skipped
TABLES_SKIP='dist|indicies'
OUTPUT_FILE="all-data.sql"

if [ -f ${OUTPUT_FILE} ]; then
  rm -f ${OUTPUT_FILE}
fi

for i in `ls *.sql | grep -Ev ${TABLES_SKIP}`; do
  cat $i | sed -e 's/INSERT\ INTO\ \(.*\)\ (/INSERT\ INTO\ \L\1\ (/g' > conv-$i
done

cat `ls | grep conv` > ${OUTPUT_FILE}

rm conv-*

echo "File: ${OUTPUT_FILE}"

exit 0
