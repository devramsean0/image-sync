const fs = require('fs');

const configFile = `${process.cwd()}/src-tauri/tauri.conf.json`;

// Read the configuration file
fs.readFile(configFile, 'utf8', (err, data) => {
  if (err) {
    console.error(`Error reading ${configFile}: ${err}`);
    return;
  }

  try {
    // Parse the JSON data
    const config = JSON.parse(data);

    // Get the current version
    let version = config.package.version || '0.0.0';

    // Check if there is a 4th -<number>
    const versionParts = version.split('-');
    if (versionParts.length === 1) {
      // Add the -0 if there is no 4th part
      version += '-0';
    } else {
      // Increment the number in the 4th part by 1
      const numberPart = parseInt(versionParts[1]) + 1;
      version = `${versionParts[0]}-${numberPart}`;
    }

    // Update the version in the configuration
    config.package.version = version;

    // Write the updated configuration back to the file
    fs.writeFile(configFile, JSON.stringify(config, null, 2), 'utf8', (err) => {
      if (err) {
        console.error(`Error writing ${configFile}: ${err}`);
      } else {
        console.log(`Updated ${configFile} with new version: ${version}`);
      }
    });
  } catch (parseError) {
    console.error(`Error parsing ${configFile}: ${parseError}`);
  }
});
