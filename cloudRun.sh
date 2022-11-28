#!/bin/bash

#aduakap@gmail.com

GOOGLE_CLOUD_PROJECT="qwiklabs-gcp-01-5eb7e239ac02"

gcloud services enable run.googleapis.com

gcloud config set compute/region us-central1

LOCATION="us-central1"

git clone https://github.com/paullo240/helloworld.git

cd helloworld

cat <<< '
{
  "name": "helloworld",
  "description": "Simple hello world sample in Node",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "author": "Google LLC",
  "license": "Apache-2.0",
  "dependencies": {
    "express": "^4.17.1"
  }
} ' > package.json

cat <<< '
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
app.get('/', (req, res) => {
  const name = process.env.NAME || 'World';
  res.send(`Hello ${name}!`);
});
app.listen(port, () => {
  console.log(`helloworld: listening on port ${port}`);
}); ' > index.js



gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud container images list

docker run -d -p 8080:8080 gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud run deploy --image gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld --allow-unauthenticated --region=$LOCATION

gcloud container images delete gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld

gcloud run services delete helloworld --region=us-central1