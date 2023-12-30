import { Button, Text, View } from 'react-native';
import { styles } from '../style';
import { TextInput } from 'react-native-gesture-handler';
import { saveSetting } from '../lib/localSettings';
import { useState } from 'react';

export default function Page() {
  const [webserverURL, setWebserverURL] = useState("image-sync.sean.cyou")
  return (
    <>
      <Text style={styles.titleText}>
        Settings
      </Text>
      <Text>
        Changes to settings on this page currently aren't respected by the app.
      </Text>
      {/* Webserver URL field*/}
      <View>
        <Text>Webserver URL:</Text>
        <TextInput
          style={styles.input}
          onChangeText={setWebserverURL}
        />
      </View>
      <Button
        onPress={() => {
          saveSetting("webserverURL", webserverURL)
          console.log("Saved webserverURL:", webserverURL)
        }}
        title="Save"
      />
    </>
  )
}
