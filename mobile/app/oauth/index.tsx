import * as React from 'react';
import * as WebBrowser from 'expo-web-browser';
import { makeRedirectUri, useAuthRequest } from 'expo-auth-session';
import { Button } from 'react-native';

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
        if (response?.type === 'success') {
          const { code } = response.params;
        }
      }, [response]);
    
      return (
        <Button
          disabled={!request}
          title="Login"
          onPress={() => {
            promptAsync();
          }}
        />
      );
}