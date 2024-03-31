#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

# https://wiki.gentoo.org/wiki/MAKEOPTS
target="/etc/portage/makeopts.conf"

cores=$(nproc)
if [ "${cores}" -le 2 ];
then
    _cores="${cores}"
else
    _cores="$((cores-2))"
fi

echo -e "# THIS FILE IS AUTOMATICALLY GENERATED BY ${0}\n" > "${target}"
echo "MAKEOPTS=\"-j${_cores}\"" >> "${target}"

source_line="source ${target}"
grep -E "^${source_line}$" /etc/portage/make.conf > /dev/null || { echo "${0}: ERROR: the line: \`${source_line}\` was not found in /etc/portage/make.conf" ; exit 1 ; }
