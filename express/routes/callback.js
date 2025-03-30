import axios from 'axios';
import fs from 'fs';
import path from 'path';
import { saveTokenFilePath } from '../common/const.js';

export async function callbackRoute(req, res) {
  const code = req.query.code;

  const authOptions = {
    method: 'post',
    url: 'https://accounts.spotify.com/api/token',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    data: new URLSearchParams({
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: process.env.SPOTIFY_REDIRECT_URI,
      client_id: process.env.SPOTIFY_CLIENT_ID,
      client_secret: process.env.SPOTIFY_CLIENT_SECRET,
    }).toString(),
  };

  try {
    const response = await axios(authOptions);
    const { access_token, token_type, expires_in, scope, refresh_token } = response.data;

    // Calculate the expiration timestamp
    const expires_at = Math.floor(Date.now() / 1000) + expires_in;

    // Create the token object
    const tokenData = {
      access_token,
      token_type,
      expires_in,
      scope,
      expires_at,
      refresh_token,
    };

    // Save the token data to a file
    const filePath = path.resolve(saveTokenFilePath);
    console.log(`Saving token data to ${filePath}`);
    fs.writeFileSync(filePath, JSON.stringify(tokenData, null, 2));

    // Redirect to the frontend with the token data
    const redirectUrl = `/#access_token=${access_token}&token_type=${token_type}&expires_in=${expires_in}&scope=${scope}&refresh_token=${refresh_token}`;
    res.redirect(redirectUrl);
  } catch (error) {
    console.error('Error during callback:', error.response?.data || error.message);
    res.status(error.response?.status || 500).send({
      error: 'Failed to exchange authorization code for tokens',
    });
  }
}