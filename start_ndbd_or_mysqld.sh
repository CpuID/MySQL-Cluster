#!/bin/bash

# For each NDB node that starts (ndb_mgmd, ndbd or mysqld), put
# the type and IP address into redis. This allows us to
# dynamically build config.ini on the ndb_mgmd, super basic service discovery

# TODO: need netcat installed

if [ $# -ne 1 ]; then
  echo "Usage: $0 server_type ndb_mgmd_qty"
	echo "server_type can be any of 'NDB_MGMD', 'NDBD', or 'MYSQLD'"
  echo "The ndb_mgmd_qty should be the # of ndb_mgmd's we expect to start"
  exit 1
fi

server_type="$1"

case "$server_type" in
  "NDB_MGMD")
    echo "Server Type is NDB_MGMD"
    ;;
  "NDBD")
    echo "Server Type is NDBD"
    ;;
  "MYSQLD")
    echo "Server Type is MYSQLD"
    ;;
  *)
    echo "Error: Invalid Server Type Specified, must be one of 'NDB_MGMD', 'NDBD', or 'MYSQLD'"
    exit 1
esac

# Get the IP Address of our single network interface (assuming were using net=bridge here)
ip_address="$(hostname -i)"
echo "IP Address is ${ip_address}"

# Write to the relevant Redis list.
redis_write="LPUSH mysql-cluster:${server_type} ${ip_address}"
printf "$redis_write" | nc -q 1 redis 6379
echo "Written '${redis_write}' to Redis"

# We now need to wait for the expected ndb_mgmd's to come online and appear in redis.
while true; do
  echo "Waiting for required ndb_mgmd's to come online before starting ${server_type} with connect string..."
  # TODO
done
