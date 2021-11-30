const generalUserId = _getEnv('USER_ID') || _getEnv('DEFAULT_USER_ID')
const generalUserPassword = _getEnv('USER_PASSWORD') || _getEnv('DEFAULT_USER_PASSWORD')

for (let i = 0; i < 60; i++) {
    if (db.isMaster().secondary) {
        sleep(2000)
    } else {
        const result = db.createUser(
            {
                user: generalUserId,
                pwd: generalUserPassword,
                roles: ["readWrite", "dbAdmin"]
            }
        )
        print("result " + JSON.stringify(result))
    }
}

function sleep(delay) {
    const start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}