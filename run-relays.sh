#!/usr/bin/env bash
set -eu

tor_bin=$(which tor)

for torrc in $(pwd)/*/torrc; do
	echo $torrc
	sudo $tor_bin -f $torrc --quiet &
done
