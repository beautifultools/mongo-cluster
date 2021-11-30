for (let i = 0; i < 10; i++) {
    const replicaConfigServers = i === 0 ? _getEnv('REPLICA_SERVERS') : _getEnv('REPLICA_SERVERS' + i);
    if (replicaConfigServers) {
        while (rs.status().ok !== 1) {
            addReplicaServer(replicaConfigServers);
            sleep(1000);
        }
    }
}

function addReplicaServer(replicaConfigServers) {
    const replicaName = replicaConfigServers.substring(0, replicaConfigServers.indexOf("/"));
    const servers = replicaConfigServers.substring(replicaConfigServers.indexOf("/") + 1).split(',');

    rs.initiate(
        {
            _id: replicaName,
            members: servers.map((serverIp, i) => ({ _id: i, host: serverIp }))
        }
    )

    print(rs.status())
}

function sleep(delay) {
    const start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}