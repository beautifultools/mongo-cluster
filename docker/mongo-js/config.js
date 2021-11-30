const envConfigServers = _getEnv('CONFIG_SERVERS');
if (envConfigServers) {
    while (rs.status().ok !== 1) {
        const rsName = envConfigServers.substring(0, envConfigServers.indexOf("/")) || "cfgrs";
        const servers = envConfigServers.substring(envConfigServers.indexOf("/") + 1).split(',');

        rs.initiate(
            {
                _id: rsName,
                configsvr: true,
                members: servers.map((serverIp, i) => ({ _id: i, host: serverIp }))
            }
        )
        sleep(1000)
    }
}

function sleep(delay) {
    const start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}