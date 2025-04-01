const { GoogleAuth } = require('google-auth-library');

const auth = new GoogleAuth({
            keyFile: './service_account.json',
        scopes: 'https://www.googleapis.com/auth/firebase.messaging'});

async function getAccessToken() {
  const client = await auth.getClient();
  const accessToken = await client.getAccessToken();
  return accessToken.token;
}

getAccessToken().then(token => {
    console.log('Generated OAuth2 token:', token);
    // Use the token in your Firebase request
}).catch(error => {
    console.error('Error generating token:', error);
});