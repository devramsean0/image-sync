import * as React from 'react';
import * as WebBrowser from 'expo-web-browser';
import * as SecureStore from 'expo-secure-store';
import { makeRedirectUri, useAuthRequest } from 'expo-auth-session';
import { Button, Platform } from 'react-native';

WebBrowser.maybeCompleteAuthSession();
const discovery = {
    authorizationEndpoint: 'https://humane-bluejay-overly.ngrok-free.app/oauth/authorize',
    tokenEndpoint: 'https://humane-bluejay-overly.ngrok-free.app/oauth/token',
};

export default function Page() {
    const [request, response, promptAsync] = useAuthRequest(
        {
            clientId: 'aU2BDujfyInkfwMSA5ox-dDs4x4hEQzDl_J5AKYhlhI',
            scopes: [
                'collections',
                'images'
            ],
            redirectUri: makeRedirectUri({
                scheme: 'image-sync'
            }),
        },
        discovery
    )
    React.useEffect(() => {
        if (response && response.type === 'success') {
          const auth = response.params;
          const storageValue = JSON.stringify(auth);
          if (Platform.OS !== 'web') {
            SecureStore.setItemAsync('auth', storageValue)
          }
        }
      }, [response]);
      
      return (
        <>
          <Button
            disabled={!request}
            title="Login"
            onPress={() => {
              promptAsync();
            }}
          />
        </>
      );
}