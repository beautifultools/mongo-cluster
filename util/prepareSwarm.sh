echo "######################## Docker Swarm Init Start ########################"
docker swarm init
docker network create --driver overlay mongo-cluster-net
echo "######################## Docker Swarm Init End ########################"
