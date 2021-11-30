#!/bin/bash
set -m 
if [ "$MONGO_TYPE" = "mongos" ]
then
    
    mongos --configdb $CONFIG_SERVERS --bind_ip 0.0.0.0 --port 27017 --keyFile ./security/mongodb-keyfile &

    while [[ "$(mongo --eval 'sh.status()' localhost:27017/test --quiet -u $(getAdminUserId) -p $(getAdminUserPassword) --authenticationDatabase admin)" != *"$REPLICA_CHECKER"* ]]
    do
        mongo localhost:27017/admin ./mongo-js/mongos.js --quiet -u $(getAdminUserId) -p $(getAdminUserPassword) --authenticationDatabase admin
        sleep 5
    done
elif [ "$MONGO_TYPE" = "config" ]
then
    mongod --configsvr --replSet $(getConfigReplicaName) --bind_ip 0.0.0.0 --port 27017 --dbpath /data/db --keyFile ./security/mongodb-keyfile &
elif [ -n "$MONGO_TYPE" ]
then
    mongod --shardsvr --replSet "$MONGO_TYPE" --bind_ip 0.0.0.0 --port 27017 --dbpath /data/db --keyFile ./security/mongodb-keyfile &

    if [ "$IS_PRIMARY" = "true" ]
    then
        while [[ "$(mongo --eval 'sh.status()' $(getMongosIp):27017/test --quiet -u $(getAdminUserId) -p $(getAdminUserPassword) --authenticationDatabase admin)" != *"$REPLICA_CHECKER"* ]]
        do
            mongo $(getMongosIp):27017/admin ./mongo-js/mongos.js --quiet -u $(getAdminUserId) -p $(getAdminUserPassword) --authenticationDatabase admin
            sleep 5
        done
    fi
fi

fg %1