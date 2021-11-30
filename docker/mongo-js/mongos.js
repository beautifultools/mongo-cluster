for (let i = 0; i < 10; i++) {
    const replicaConfigServers = i === 0 ? _getEnv('REPLICA_SERVERS') : _getEnv('REPLICA_SERVERS' + i);
    if (replicaConfigServers) {
        sh.addShard(replicaConfigServers);
    }
}