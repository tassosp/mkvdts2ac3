#!/bin/bash
## mkvdtsupload - removes and uploads redundant DTS tracks
## Author: Jake Wharton <jakewharton@gmail.com>
## Version: 0.1a

## Used to time execution
START=$(date +%s)

DEST=$(dirname "$1")
NAME=$(basename "$1" .mkv)

WD=.

## Get the track number for the DTS track
DTSTRACK=$(mkvmerge -i "$1" | grep A_DTS | cut -d: -f1 | cut -d" " -f3)
KEEPTRACKS=$(mkvmerge -i "$1" | grep audio | grep -v A_DTS | cut -d: -f1 | cut -d" " -f3 | awk '{ if (T == "") T=$1; else T=T","$1 } END { print T}' )

## Setup temporary files
DTSFILE="$WD/$NAME.dts"
NEWFILE="$WD/$NAME.new.mkv"

## Extract the DTS track
mkvextract tracks "$1" $DTSTRACK:"$DTSFILE"

## Remove DTS track from MKV
mkvmerge -o "$NEWFILE" -a $KEEPTRACKS "$1"

## Move new file over the old one (NOT SAFELY)
mv "$NEWFILE" "$1"

## TODO: Upload dts file

## Delete the DTS file
#rm "$DTSFILE"
