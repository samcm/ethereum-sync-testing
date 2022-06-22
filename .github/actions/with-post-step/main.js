// Credit: https://github.com/pyTooling/Actions/blob/main/with-post-step/main.js
const { exec } = require("child_process");

function run(cmd) {
  exec(cmd, (error, stdout, stderr) => {
    if ( stdout.length !== 0 ) { console.log(`${stdout}`); }
    if ( stderr.length !== 0 ) { console.error(`${stderr}`); }
    if (error) {
      process.exitCode = error.code;
      console.error(`${error}`);
    }
  });
}

const key = process.env.INPUT_KEY.toUpperCase();

if ( process.env[`STATE_${key}`] !== undefined ) { // Are we in the 'post' step?
  run(process.env.INPUT_POST);
} else { // Otherwise, this is the main step
  console.log(`::save-state name=${key}::true`);
  run(process.env.INPUT_MAIN);
}