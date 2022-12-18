const { promisify } = require('util');
const { TrrOutParser } = require('./utils/trr-out-parser');
const exec = promisify(require('child_process').exec)

const sshPrivKeyPath = "terraform-keys";
const sshUser = `ubuntu`
const installDepCmd = "sudo apt-get update && sudo apt-get -y install docker.io";

// Install Docker in EC2 instances
async function run() {

  // Obtain output
  const trrOut = await exec('terraform output -json')
  // To JSON
  const trrJson = JSON.parse(trrOut.stdout)
  // Parser
  const parser = new TrrOutParser(trrJson)

  for (const stage of parser.stages) {
    console.log("[*] On stage: ", stage)
    const url = parser.value("api_domains", stage);
    const cmd = `ssh -o "StrictHostKeyChecking no" -i ${sshPrivKeyPath} ${sshUser}@${url} "${installDepCmd}"`;

    console.log("> " + cmd);
    console.log(await exec(cmd))
  }
};

run().then(
  _ => console.log("Finish.")
)