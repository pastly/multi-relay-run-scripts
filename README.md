A bit of boilerplate for running a handful of relays on one machine easily.

This is mainly for rather advanced and knowledgeable Tor relay operators with
an uncommon setup like me. This is for a very fast and well connected machine
with multiple IP addresses that will be running ~5 relays. Most relay operators
will be better served simply running a relay with their system tor process and
editing `/etc/tor/torrc`. Even most relay operators with many relays would
probably better served with ansible or something like it.

If you want to use something other than the `tor` in your `$PATH`, you can edit
`tor_bin` in `run-relays.sh` and run the relays with this script. `sudo` is
used so I can bind to privileged ports; note my use of `User` in `torrc-common`
to tell Tor to drop privileges ASAP.

The main script is `make-torrcs.sh`.  Relay data directories will live as
subdirectories of the pwd. The pwd is expected to have various `torrc-common*`
files in it.

The relay data directory (DD) names are taken from the first variable in the
script, `$relays`. The DD names can be different than their nick names. All the
basic info arrays at the top of the script need to have the same length. The
first item in each array is for the first relay, the second item in each is for
the second, etc.

The `torrc-common` file has some info specific to me, sorry. I spent too long
making configuration general for my purposes already (and writing this
document...); it wouldn't be prudent to spend more time making it even more
general.

Tip for getting `MyFamily` set correctly the first time your relays publish
their descriptors: set `PublishServerDescriptor 0`, run the relays for the
first time for a few seconds, stop them, `cat */fingerpring`, set `MyFamily` in
`torrc-common`like I have, set `PublishServerDescriptor 1`, and start them
again.
