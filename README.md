# Mongo DB Cluster With Docker

## Description

This is a docker image and compose files for mongo db cluster.
It is started because it took so long time to configure mongo db cluster using mongo db offical image.

## Structure

- docker
  - mongo-js
    Javascript files for setting config and loading data
  - security
    Keyfile for mongodb secure mode. this keyfile should be changed to your own file on production.
  - shell
    shell scripts for preparing and starting mongodb cluster
  - main.sh
    main shell script for running mongo db deamon.
- docker-compose
  - one-network
    a compose file for one host(local machine..) and docker swarm.
  - separated-network
    compose files for multi hosts.
- util
  util scripts

## How to Start

### Make Image

```bash
$ ./makeMongoImage.sh
```

### Start/Stop cluster by docker compose

```bash
# start cluster
$ ./startMongoClusterByCompose

# stop cluster
$ ./stopMongoClusterByCompose.sh

# stop cluster with removing volume
$ ./stopMongoClusterByCompose.sh -v
```

## Configuration

- MONGO_TYPE
  - mongos : used for mongos
  - config : used for config servers
  - {replica set name}
    - used for replica sets. All servers in the same replica set must have same MONGO_TYPE

- CONFIG_SERVERS
  - example : cfgrs/config1:27017,config2:27017,config3:27017

- REPLICA_SERVERS
  - example : replica1/rs1server1:27017,rs1server2:27017

- REPLICA_CHECKER

  - It is used to register replica set to mongos. It is basically setted to replica set containers.

  - It needs because there are differences between given REPLICA_SERVERS and setted REPLICA_SERVERS on order of servers.

    - example

      - Given : replica1/200.100.1.147:50001,200.100.1.146:50002,200.100.1.146:50003

      - Setted : replica1/200.100.1.146:50002,200.100.1.146:50003,200.100.1.147:50001

  - It is commonly prefix of REPLICA_SERVERS

    - eample : replica1/200.

- ADMIN_USER_ID
  - example : admin-user
  - default value : adminUser

- ADMIN_USER_PASSWORD
  - example : admin-user-pw
  - default value : adminUserPassword

## License

This is [MIT licensed](LICENSE).
