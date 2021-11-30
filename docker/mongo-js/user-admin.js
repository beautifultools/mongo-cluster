const adminUserId = _getEnv('ADMIN_USER_ID') || _getEnv('DEFAULT_ADMIN_USER_ID');
const adminUserPassword = _getEnv('ADMIN_USER_PASSWORD') || _getEnv('DEFAULT_ADMIN_USER_PASSWORD');

for (let i = 0; i < 60; i++) {
    if (db.isMaster().secondary) {
        sleep(2000)
    } else {
        db.createUser(
            {
                user: adminUserId,
                pwd: adminUserPassword,
                roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase", "clusterAdmin"]
            }
        )
    }
}

function sleep(delay) {
    const start = new Date().getTime();
    while (new Date().getTime() < start + delay);
}