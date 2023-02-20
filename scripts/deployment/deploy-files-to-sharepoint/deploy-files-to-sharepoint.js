#!/usr/bin/env node

const path = require('path');
const fs = require('fs').promises;
const { spsave } = require('spsave');

async function main() {
  const coreOptions = {
    siteUrl: process.argv[2],
  };

  const credentialOptions = {
    clientId: process.env.SHAREPOINT_CLIENT_ID,
    clientSecret: process.env.SHAREPOINT_CLIENT_SECRET,
  };

  const basePath = process.argv[4];

  async function pushFile(filePath, fileName, fileContent) {
    console.log(filePath, fileName, fileContent);

    const fileOptions = {
      filePath: filePath.replace(new RegExp(`^\\.\\/?${ basePath }\\/`), ''),
      fileName,
      fileContent
    };

    console.log(fileOptions);

    await spsave(coreOptions, credentialOptions, fileOptions);
  }

  async function processDir(dirPath) {
    const entities = await fs.readdir(dirPath);
    for (const entity of entities) {
      const entityFullPath = path.join(dirPath, entity);
      const stat = await fs.stat(entityFullPath);

      if (stat.isDirectory()) {
        await processDir(entityFullPath);
        continue;
      }

      const fileContent = await fs.readFile(entityFullPath);
      await pushFile(dirPath, entity, fileContent);
    }
  }

  await processDir(basePath);
}

main().then(() => {
  console.log('Successfully uploaded files to SharePoint.');
  process.exit(0);
}, (e) => {
  console.error('An error occurred while uploading files to SharePoint:');
  console.error(e);
  process.exit(-1);
});
