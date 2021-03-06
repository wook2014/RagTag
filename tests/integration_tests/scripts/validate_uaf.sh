#!/usr/bin/env bash

# Validate the integrated RagTag unique anchor filtering

# position args:
## 1. unfiltered delta file
## 2. filtered PAF file
## 2. unique alignment length

Usage() {
    echo "Usage: $0 pre.fa pre.gff post.fasta post.gff"
}

mecho() {
    NAME=`basename $0`
    echo "$NAME:" $1
}

if [ $# -lt 3 ] ; then
    Usage
    exit 1
fi

DELTA=$1
DELTA_PREF=`basename $1 .delta`

PAF=$2
ULEN=$3

python3 scripts/Assemblytics_uniq_anchor.py --delta $DELTA \
    --out UAF \
    --unique-length $ULEN \
    --keep-small-uniques

ragtag_delta2paf.py UAF.Assemblytics.unique_length_filtered_l${ULEN}.delta.gz > UAF.paf

echo "validate_uaf: Comparing PAF files with 'diff':"
diff <(sort $PAF) <(cut -f1-12 UAF.paf | sort)

rm UAF.*