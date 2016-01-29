var s3 = require('s3');

var client = s3.createClient({
  s3Options: {
    accessKeyId: process.env.ACCESS_KEY,
    secretAccessKey: process.env.SECRET_KEY,
  },
});

var schemaUploader = client.uploadDir({
  localDir: './schemas',
  s3Params: {
    Bucket: 'snowplow-pact-iglu-schemas',
    Prefix: 'schemas',
  },
});

var pathsUploader = client.uploadDir({
  localDir: './jsonpaths',
  s3Params: {
    Bucket: 'snowplow-pact-iglu-jsonpaths',
    Prefix: 'jsonpaths',
  },
});

schemaUploader.on('error', err =>
  console.error('Unable to sync schemas:', err.stack)
);
pathsUploader.on('error', err =>
  console.error('Unable to sync json paths:', err.stack)
);

schemaUploader.on('end', err =>
  console.log('Schemas uploaded')
);
pathsUploader.on('end', err =>
  console.log('jsonpaths uploaded')
);
