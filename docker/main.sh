#!/bin/bash

export DEFAULT_ADMIN_USER_ID="adminUser"
export DEFAULT_ADMIN_USER_PASSWORD="adminUserPassword"
export DEFAULT_USER_ID="user"
export DEFAULT_USER_PASSWORD="userPassword"

getAdminUserId(){
    local ADMIN_ID=$DEFAULT_ADMIN_USER_ID
    
    if [ -n "$ADMIN_USER_ID" ]
    then
        ADMIN_ID=$ADMIN_USER_ID    
    fi

    echo $ADMIN_ID
}

getAdminUserPassword(){
    local ADMIN_PASSWORD=$DEFAULT_ADMIN_USER_PASSWORD

    if [ -n "$ADMIN_USER_PASSWORD" ]
    then
        ADMIN_PASSWORD=$ADMIN_USER_PASSWORD
    fi

    echo $ADMIN_PASSWORD
}

getUserId(){
    local UID=$DEFAULT_USER_ID
    
    if [ -n "$USER_ID" ]
    then
        UID=$USER_ID    
    fi

    echo $UID
}

getUserPassword(){
    local UPWD=$DEFAULT_USER_PASSWORD
    
    if [ -n "$USER_PASSWORD" ]
    then
        UPWD=$USER_PASSWORD    
    fi

    echo $UPWD
}

getMongosIp(){
    local RTN_MONGOS_IP=mongos
    
    if [ -n "$MONGOS_IP" ]
    then
        RTN_MONGOS_IP=$MONGOS_IP
    fi

    echo $RTN_MONGOS_IP
}

getConfigReplicaName(){
    echo $(echo "$CONFIG_SERVERS" | cut -f 1 -d "/")
}

export -f getAdminUserId
export -f getAdminUserPassword
export -f getUserId
export -f getUserPassword
export -f getMongosIp
export -f getConfigReplicaName

if [ -f /scripts/prepare.checker ]
then 
    echo "[INFO] PREPARE ALREADY COMPLETED" >> /scripts/prepare.checker
elif [ $IS_SKIP_PREPARE = "true" ]
then
    echo "[INFO] PREPARE IS SKIPPED" > /scripts/skip.checker
else
    /bin/bash ./shell/prepareMongo.sh
    echo "[INFO] PREPARE COMPLETED" > /scripts/prepare.checker
fi

/bin/bash ./shell/startMongo.sh
