#!/bin/bash

# This looks at redis and grabs all the host elements we need
# to build a config.ini before starting ndb_mgmd, super basic service discovery

if [ $# -ne 3 ]; then
  echo "Usage: $0 ndb_mgmd_qty ndbd_qty mysqld_qty"
  echo "This script will wait for each of the qty of hosts above to exist"
  echo "in Redis before writing config.ini and starting the ndb_mgmd"
  exit 1
fi

# TODO: parse out various lists in redis, such as:
# mysql-cluster:NDBD
# mysql-cluster:NDB_MGMD
# mysql-cluster:MYSQLD
