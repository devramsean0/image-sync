const fs = require('fs');
const { execSync } = require('child_process')

const tauriConfPath = 'desktop/src-tauri/tauri.conf.json';

// Read the tauri.conf.json file
fs.readFile(tauriConfPath, 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading tauri.conf.json:', err);
    return;
  }

  // Parse the JSON data
  let tauriConf;
  try {
    tauriConf = JSON.parse(data);
  } catch (parseError) {
    console.error('Error parsing tauri.conf.json:', parseError);
    return;
  }

  // Get the current version from tauri.conf.json
  const currentVersion = tauriConf.package && tauriConf.package.version;

  if (!currentVersion) {
    console.error('Unable to find the current version in tauri.conf.json');
    return;
  }
  const gitSHA = execSync('git rev-parse HEAD').toString().trim();
  // Modify the version (for example, appending "gitSHA")
  const newVersion = `${currentVersion}-${gitSHA}`;  // You can replace this with the actual logic to get Git commit SHA

  // Update the version in tauri.conf.json
  tauriConf.package.version = newVersion;

  // Convert back to JSON string
  const updatedTauriConf = JSON.stringify(tauriConf, null, 2);

  // Write the updated tauri.conf.json file
  fs.writeFile(tauriConfPath, updatedTauriConf, 'utf8', (writeErr) => {
    if (writeErr) {
      console.error('Error writing updated tauri.conf.json:', writeErr);
    } else {
      console.log(`Version updated successfully to ${newVersion}`);
    }
  });
});