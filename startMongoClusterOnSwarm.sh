./prepareSwarm.sh
docker stack deploy mongo-cluster -c ./docker-compose/one-network/docker-compose.yml
