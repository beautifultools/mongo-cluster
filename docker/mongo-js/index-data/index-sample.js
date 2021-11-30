// get db
db = db.getSiblingDB('SAMPLE');

// create document
db.createCollection("SAMPLE_COLLECTION1");
db.createCollection("SAMPLE_COLLECTION2");

// create index
// * ATTR_ADID_ABUSE_CL
db.SAMPLE_COLLECTION1.createIndex({ "sampleIndexKey": 1 });
db.SAMPLE_COLLECTION2.createIndex({ "sampleIndexKey": 1 });

// insert data
db.SAMPLE_COLLECTION1.insert({
    "sampleIndexKey": "00000000-0000-0000-0000-000000000000",
    "sampleData": "data",
})

db.SAMPLE_COLLECTION2.insert({
    "sampleIndexKey": "11111111-1111-1111-1111-111111111111",
    "sampleData": "data",
})

// create user
db.createUser(
    {
        user: 'sample-user',
        pwd: 'sample-user-pw',
        roles: ["readWrite", "dbAdmin"]
    }
)