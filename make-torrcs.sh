#!/usr/bin/env bash
set -eu

# Define basic info for the relays. All these arrays need the same length
relays=( tfinn1 tfinn2 tfinn3 tfinn4 )
nicks=(  TFinn1 TFinn2 TFinn3 TFinn4 )
orports=(   443   9000    443   9000 )
dirports=(   80   9001     80   9001 )
ips=( 65.19.167.131 65.19.167.131 \
      65.19.167.132 65.19.167.132 \
)

# The union of these two arrays should equal the $relays array
guards=( tfinn1 )
exits=(  tfinn2 tfinn3 tfinn4 )

# The relay-specific torrcs will each include some of of these common torrcs
torrc_common_guard=$(pwd)/torrc-common-guard
torrc_common_exit=$(pwd)/torrc-common-exit
torrc_common=$(pwd)/torrc-common
torrc_empty=$(pwd)/torrc-empty
# The template for the relay-specific torrc
torrc_tmpl=torrc.tmpl

# Make sure these exist
touch $torrc_common_guard
touch $torrc_common_exit
touch $torrc_common
echo '' > $torrc_empty

# Create each relay's specific torrc
for i in $(seq 0 $((4-1))); do
	relay=${relays[$i]}
	nick=${nicks[$i]}
	orport=${orports[$i]}
	dirport=${dirports[$i]}
	ip=${ips[$i]}
	torrc_spec=$(pwd)/$relay/torrc-misc-specific
	touch $torrc_spec
	if echo ${guards[@]} | grep -qw $relay; then
		torrc_common_type=$torrc_common_guard
	elif echo ${exits[@]} | grep -qw $relay; then
		torrc_common_type=$torrc_common_exit
	else
		echo WARN: $relay doesnt have a torrc_common_type
		torrc_common_type=$torrc_empty
	fi
	mkdir -pv $relay
	chmod 700 $relay
	cat <<EOT >$relay/torrc
#############################
###                       ###
### DO NOT EDIT THIS FILE ###
###                       ###
#############################
#
# - For general options that apply to all relays, edit torrc-common and reload
#   the relays.
# - For options that apply to just guards or just exits, edit either
#   torrc-common-guards or torrc-common-exits and reload the relays.
# - For options that apply to all relays but need different values for each
#   relay, edit torrc.tmpl and rerun make-torrcs.sh.
# - For options specific to this relay only, edit torrc-misc-specific.
#
# $(realpath $0) created this file
# $(date)

EOT
	sed "
	s|DATADIR|$(pwd)/$relay|;
	s|NICK|$nick|;
	s|IP|$ip|;
	s|ORPORT|$ip:$orport|;
	s|DIRPORT|$ip:$dirport|;
	s|TORRC_COMMON_TYPE|$torrc_common_type|;
	s|TORRC_COMMON|$torrc_common|;
	s|TORRC_MISC_SPECIFIC|$torrc_spec|;
	" torrc.tmpl >> $relay/torrc
done
echo OK
