#!/usr/bin/env bash
set -eu

tor_bin=$(which tor)
commands=( start stop reload restart )

function usage {
	echo "valid commands: ${commands[@]}"
}

[[ "${1:-}" == "" ]] && usage && exit 1
[[ " ${commands[@]} " != *" $1 "* ]] && usage && exit 1

function start_fn {
	for torrc in $(pwd)/*/torrc; do
		echo Starting tor with $torrc
		sudo $tor_bin -f $torrc --quiet &
	done
}

function stop_fn {
	echo SIGINT PIDs: $(cat */tor.pid)
	cat */tor.pid | xargs kill -INT
}

function reload_fn {
	echo SIGHUP PIDs: $(cat */tor.pid)
	cat */tor.pid | xargs kill -HUP
}

function restart_fn {
	stop_fn
	sleep 5
	start_fn
}

command="$1"
[[ "$command" == "start" ]] && start_fn
[[ "$command" == "stop" ]] && stop_fn
[[ "$command" == "reload" ]] && reload_fn
[[ "$command" == "restart" ]] && restart_fn
