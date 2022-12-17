const { promisify } = require('util');
const { TrrOutParser } = require('./trr-out-parser');
const exec = promisify(require('child_process').exec)

// Install Docker in EC2 instances
async function run() {

  // Obtain output
  const trrOut = await exec('terraform output -json')
  // To JSON
  const trrJson = JSON.parse(trrOut.stdout)
  // Parser
  const parser = new TrrOutParser(trrJson)

  for (const stage of parser.stages) {
    console.log("stage: ", stage)
    const url = parser.value("api_proxies", stage);
    const cmd = `ssh -o "StrictHostKeyChecking no" -i terraform-keys ubuntu@${url} "sudo apt-get update && sudo apt-get -y install docker.io"`;

    console.log("> " + cmd);
    console.log(await exec(cmd))
  }
};

run().then(
  console.log
)