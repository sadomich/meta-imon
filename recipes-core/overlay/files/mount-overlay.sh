#!/bin/sh

if [ $# -lt 2 ]; then
	echo >&2 "Usage: $0 spec mountpoint"
	exit 1
fi

# e.g. /data/overlayfs/root
spec=$1

# e.g. /root
mountpoint=$2

mkdir -p "${spec}/upper"
mkdir -p "${spec}/work"

extraoptions=",index=off,metacopy=off,xino=on"

mount -t overlay overlay -o lowerdir="${mountpoint}",upperdir="${spec}/upper",workdir="${spec}/work""${extraoptions}" "${mountpoint}"
