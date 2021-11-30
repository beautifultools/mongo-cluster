#!/bin/bash
# start server
if [ "$MONGO_TYPE" = "mongos" ]
then 
    mongos --configdb $CONFIG_SERVERS --bind_ip 0.0.0.0 --port 27017 &
elif [ "$MONGO_TYPE" = "config" ]
then
    mongod --configsvr --replSet $(getConfigReplicaName) --bind_ip 0.0.0.0 --port 27017 --dbpath /data/db &
elif [ -n "$MONGO_TYPE" ]
then
    mongod --shardsvr --replSet "$MONGO_TYPE" --bind_ip 0.0.0.0 --port 27017 --dbpath /data/db &
fi

# config server
if [ -n "$MONGO_TYPE" ]
then
    while [ "$(mongo --eval 'db.runCommand("ping").ok' localhost:27017/test --quiet)" != "1" ]
    do
            sleep 5
    done

    if [ "$MONGO_TYPE" = "mongos" ]
    then 
        mongo localhost:27017/admin ./mongo-js/user-admin.js
        sleep 10
    elif [ "$MONGO_TYPE" = "config" ]
    then
        if [ "$IS_PRIMARY" = "true" ]
        then
            mongo localhost:27017/admin ./mongo-js/config.js
        fi
        
        while [ "$(mongo --eval 'db.runCommand("ping").ok' $(getMongosIp):27017/test --quiet)" != "1" ]
        do
            sleep 1
        done
        sleep 10
    else
        while [ "$(mongo --eval 'rs.status().ok' localhost:27017/test --quiet)" != "1" ]
        do
            if [ "$IS_PRIMARY" = "true" ]
            then
                mongo localhost:27017/admin ./mongo-js/replica.js
            fi
            sleep 5
        done
    
        mongo localhost:27017/admin ./mongo-js/user-admin.js
        mongo localhost:27017/DOP_ATTRIBUTION ./mongo-js/user-general.js
        mongo localhost:27017/DOP_LANDING ./mongo-js/user-general.js
    fi
fi

# shutdown server
if [ "$MONGO_TYPE" = "mongos" ]
then
    mongo localhost:27017/admin shutdown-mongos.js &
else
    mongod --shutdown &
fi

while [ true ]
do
    IS_RUNNING=$(mongo --eval 'db.runCommand("ping").ok' localhost:27017/test --quiet)
    if [[ "$IS_RUNNING" == *"SocketException"* ]]
    then 
        break
    else
        echo "sleep :: $IS_RUNNING" >> ./result.txt
        sleep 1    
    fi
done