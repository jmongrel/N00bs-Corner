#!/bin/bash
#This basic script will compare two files if they match
#Instruction: chmod +x filecompare.sh
#then ./filecompare.sh file1 file2

if [ $# -ne 2 ] ; then
   echo "" >&2
   echo "Usage: $0 file1 file2" >&2
   echo "" >&2
   exit 1
fi

file1=$1
file2=$2

if cmp -s $file1 $file2; then
   echo "" >&2
   echo "Both files are a match! :)" >&2
   else
   echo "" >&2
   echo "The files do not match... Please check the DETAILS below. :(" >&2
fi

echo "" >&2
echo "DETAILS:" >&2
echo ""
type1=$(file $file1 |awk '{$1=""; print}')
type2=$(file $file2 |awk '{$1=""; print}')
echo "File1 is an: $type1 while..." >&2
echo "File2 is an: $type2" >&2
echo "" >&2

hash1=$(md5sum $file1)
hash2=$(md5sum $file2)
hash11=$(echo $hash1 | awk '{print $1}')
hash22=$(echo $hash2 | awk '{print $1}')

echo "Hash values are: " >&2
echo "  File1: $hash11" >&2
echo "  File2: $hash22" >&2
echo "" >&2

diff=$(diff -by --suppress-common-lines $file1 $file2)
echo "Diff: Column1 == File1  | Column2 == File2" >&2
echo "" >&2
echo "$diff" >&2

wc1=$(wc $file1  | awk '{print $1}')
wc2=$(wc $file2  | awk '{print $1}')
echo "" >&2
echo "Number of lines for File 1: $wc1 lines" >&2
echo "Number of lines for File 2: $wc2 lines" >&2
echo "" >&2

exit 0