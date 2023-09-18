const { PutObjectCommand, S3Client } = require('@aws-sdk/client-s3');
const readdir = require('recursive-readdir');
const fs = require('fs').promises;
const path = require('path');

const MIME_TYPES = {
  '.css': 'text/css',
  '.gif': 'image/gif',
  '.gz': 'application/gzip',
  '.htm': 'text/html',
  '.html': 'text/html',
  '.jpeg': 'image/jpeg',
  '.jpg': 'image/jpeg',
  '.js': 'application/javascript',
  '.json': 'application/json',
  '.pdf': 'application/pdf',
  '.png': 'image/png',
  '.sh': 'text/x-shellscript',
  '.svg': 'image/svg+xml',
  '.tar': 'application/x-tar',
  '.txt': 'text/plain',
  '.webp': 'image/webp',
  '.xml': 'application/xml',
  '.zip': 'application/zip',
};

const IGNORED_PATHS = [
  '.DS_Store',
  'node_modules',
  'package.json',
  'package-lock.json',
];

async function upload(client, bucket, file, key) {
  const input = {
    Bucket: bucket,
    Key: key,
    Body: await fs.readFile(file),
  };

  const extension = path.extname(file);
  if (MIME_TYPES[extension]) {
    input.ContentType = MIME_TYPES[extension];
  }

  try {
    await client.send(new PutObjectCommand(input));
    return true;
  }
  catch (e) {
    console.error(e);
    return false;
  }
}

async function main() {
  const sourcePath = process.argv[2];
  const region = process.argv[3];
  const endpoint = process.argv[4];
  const bucket = process.argv[5];

  const client = new S3Client({
    endpoint,
    region,
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    }
  });

  let errorCount = 0;
  const files = await readdir(sourcePath, IGNORED_PATHS);
  const bareSourcePath = sourcePath.replace(/^\.\//, '');
  console.log(`Uploading ${ files.length } files.`);
  for (const file of files) {
    console.log(`Processing file "${ file }"...`);
    const key = file.replace(new RegExp(`^(\.\/)?${ bareSourcePath }(\/)?`), '');
    console.log(`Uploading to s3://${ key }...`);
    const result = await upload(client, bucket, file, key);
    if (!result) {
      errorCount++;
    }
  }

  if (errorCount > 0) {
    throw new Error('One or more errors occurred while uploading files to S3.');
  }
}

main().then(() => {
  console.log('fin.');
  process.exit(0);
}, (e) => {
  console.log('doh.', e);
  process.exit(-1);
});
