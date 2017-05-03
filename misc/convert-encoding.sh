#!/usr/bin/env sh

# Handle command line arguments
function usage() {
    echo "Usage: convert-encoding.sh -s <SOURCE_DIR> -d <DEST_DIR> [-f <FROM_ENCODING>] [-t <TO_ENCODING>]"
    exit $@
}

FROM=UTF-8
TO=GBK
SRC=
DEST=
VERBOSE=false

function info() {
    $VERBOSE && echo $@
}

function error() {
    echo $@ 1>&2
}

while getopts f:t:s:d:vh options; do
    case $options in
        f) FROM=$OPTARG ;;
        t) TO=$OPTARG ;;
        s) SRC=$OPTARG ;;
        d) DEST=$OPTARG ;;
        v) VERBOSE=true ;;
        h) usage 0 ;;
    esac
done

if [ -z "$SRC" ]; then
    echo "Must specify a source directory" 1>&2
    usage 1
fi

if [ -z "$DEST" ]; then
    echo "Must specify a dest directory" 1>&2
    usage 1
fi

# Convert file encoding

DIR=`pwd`
if [ ! -d $DEST ]; then
    mkdir $DEST -p
fi
cd "$DEST"
ABSDEST=`pwd`
cd "$DIR"
cd "$SRC"

info "DIR=$DIR"
info "ABSDEST=$ABSDEST"
info "SRC=$SRC"

find . -iname '*.csv' -print0 | while read -d $'\0' file; do
    destfile="$ABSDEST/$file"
    dir=$(dirname "$destfile")
    if [ -f "$dir" ]; then
        error "$dir exists but is not a directory"
        exit 1
    fi
    if [ ! -d "$dir" ]; then
        info "Creating directory $dir"
        mkdir "$dir" -p
    fi
    info "Converting $file"
    iconv -f $FROM -t $TO "$file" > "$destfile"
done
