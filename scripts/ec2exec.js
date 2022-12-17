const { promisify } = require('util');
const { TrrOutParser } = require('./utils/trr-out-parser');
const exec = promisify(require('child_process').exec)

const sshPrivKeyPath = "terraform-keys";
const sshUser = `ubuntu`
const argStage = process.argv[2]
const argCmd = process.argv[3]

if (!argStage || !argCmd) {
  console.log("Usage: node scripts/ec2exec.js <stage:dev|prod> <command>")
  !argStage && console.error("[*] <stage> not found.")
  !argCmd && console.error("[*] <command> not found.")

  console.log("\nExample:");
  console.log("> node scripts\ec2-exec.js dev \"sudo docker ps\"");
  process.exit()
}

// Run command in EC2 instance
async function run() {

  // Obtain output
  const trrOut = await exec('terraform output -json')
  // To JSON
  const trrJson = JSON.parse(trrOut.stdout)
  // Parser
  const parser = new TrrOutParser(trrJson)

  const url = parser.value("api_proxies", argStage);
  const cmd = `ssh -o "StrictHostKeyChecking no" -i ${sshPrivKeyPath} ${sshUser}@${url} "${argCmd}"`;
  console.log("> " + cmd);

  const res = await exec(cmd)
  console.log("stdout")
  console.log("==============")
  console.log(res.stdout)
  console.log("stderr")
  console.log("==============")
  console.log(res.stderr)
};

run().then(
  _ => console.log("Finish.")
)