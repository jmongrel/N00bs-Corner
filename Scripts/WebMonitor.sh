#/bin/bash

controls="./controls"
replicates="./replicates"
hashes="./hashes"
dirperm=755
fileperm=644
date=`date +%Y-%m-%d.%H:%M:%S`

if [ $# -ne 1 ] ; then
	echo "Usage: $0 url" >&2
	exit 1
fi

if [ "$(echo $1 | cut -c1-5)" != "http:" ]; then
	echo "Please use fully qualified URLs (e.g. start with 'http://')" >&2
	exit 1
fi

if [ ! -d $controls ]; then
	mkdir $controls
	if [ ! -d $replicates ]; then
		mkdir $replicates
		if [ ! -d $hashes ]; then
			mkdir $hashes
		exit 1
		fi
		chmod $dirperm $controls $replicates $hashes
	fi
fi

basedir="$(echo $1 | cut -d "/" -f3)"
hashreplicate="$hashes/$basedir"

# Create baseline files
if [ ! -d $controls/$basedir ]; then
	wget --mirror -p --restrict-file-names=windows --html-extension --convert-links -v -e robots=off -P $controls $1
	$(which md5deep) -r $controls/$basedir |grep -v "md5" |sort -u > $controls/$basedir/sums.md5
	chmod $dirperm $controls/$basedir
	else
	echo "Status: control files for $basedir already exists... proceeding to check replicates."  >&2
fi

# Create hash repo
if [ ! -d $hashreplicate ]; then
	mkdir $hashreplicate
	chmod $dirperm $hashreplicate
fi

# Update replicate files
if [ -d $replicates/$basedir ]; then
	rm -rf $replicates/$basedir	
	wget --mirror -p --restrict-file-names=windows --html-extension --convert-links -v -e robots=off -P $replicates $1
	$(which md5deep) -r $replicates/$basedir |grep -v "md5" |sort -u > $hashreplicates/sums-$date.md5
	else
	wget --mirror -p --restrict-file-names=windows --html-extension --convert-links -v -e robots=off -P $replicates $1
	$(which md5deep) -r $replicates/$basedir |grep -v "md5" |sort -u > $hashreplicates/sums-$date.md5
	exit 0
	chmod $dirperm $replicates/$basedir
fi

if $(which md5deep) -r -X $controls/$basedir/sums.md5 $replicates/$basedir; then
   echo "" >&2
   echo "Coast is clear... Nothing changed since the last check!" >&2
   else
   echo "" >&2
   echo "File change detected!" >&2
fi

exit 0