# cloudant-es-bridge

This is a serverless function that moves data from a Cloudant database to an ElasticSearch cluster. Any adds/updates/deletes that happen on the Cloudant database are reflected in the ElasticSearch copy.

![schematic](images/cloudant-es-bridge.png)

## Pre-requisites

First we're going to need a Cloudant service. Sign up [here](https://www.ibm.com/cloud/cloudant) and make a note of your Cloudant URL, which will be of the form:

    https://USER:PASS@ACCOUNT.cloudant.com
    
Log into your Cloudant dashboard and create a new database.

Now we need to create an ElasticSearch instance. Sign up [here](https://compose.com/databases/elasticsearch), create a new user which should give you a URL of the following form:

    https://USERNAME:PASSWORD@xxx.composedb.com:PORT/

ElasticSearch stores its documents two levels down from here. At the top level we have "indexes" and each index can have a number of "types" in it, so our full URL will have this form:

    https://USERNAME:PASSWORD@xxx.composedb.com:PORT/INDEX/TYPE
   
See [Getting started with ElasticSearch on Compose](https://www.compose.com/articles/getting-started-with-elasticsearch-using-compose/) for the full low-down.
 
We'll need your Cloudant and ElasticSearch credentials for the next stage when we deploy our serverless bridge. As a last step, ensure you have the `bx wsk` tool installed by following the instructions [here](https://console.bluemix.net/openwhisk/learn/cli).

## Deploying

Clone the code:

    git clone https://github.com/ibm-watson-data-lab/cloudant-es-bridge
    cd cloudant-es-bridge

Create some environment variables containing your Cloudant and ElasticSearch credentials:

    export CLOUDANT_HOST="HOST.cloudant.com"
    export CLOUDANT_USERNAME="CLOUDANTUSERNAME"
    export CLOUDANT_PASSWORD="CLOUDANTPASSWORD"
    export CLOUDANT_DB="esbridge"
    export ELASTIC_URL="https://ESUSERNAME:ESPASSWORD@HOST.composedb.com:PORT/INDEX/TYPE"

Then run the deployment script:

   ./deploy.sh
   
## Undeploying

Run 

    ./undeploy.sh

