import axios from 'axios';
import fs from 'fs';
import path from 'path';
import { saveTokenFilePath } from '../common/const.js';

export async function refreshTokenRoute(req, res) {
  const client_id = process.env.SPOTIFY_CLIENT_ID;
  const client_secret = process.env.SPOTIFY_CLIENT_SECRET;
  const refresh_token = req.query.refresh_token;

  const authOptions = {
    method: 'post',
    url: 'https://accounts.spotify.com/api/token',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ' + Buffer.from(client_id + ':' + client_secret).toString('base64'),
    },
    data: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
    }).toString(),
  };

  try {
    const response = await axios(authOptions);
    const { access_token, token_type, expires_in, scope, refresh_token: new_refresh_token } = response.data;

    // Calculate the expiration timestamp
    const expires_at = Math.floor(Date.now() / 1000) + expires_in;

    // Create the token object
    const tokenData = {
      access_token,
      token_type,
      expires_in,
      scope,
      expires_at,
      refresh_token: new_refresh_token || refresh_token, // Use the new refresh token if provided
    };

    // Save the token data to a file
    const filePath = path.resolve(saveTokenFilePath);
    fs.writeFileSync(filePath, JSON.stringify(tokenData, null, 2));

    // Send the token data as the response
    res.send(tokenData);
  } catch (error) {
    console.error('Error refreshing token:', error.response?.data || error.message);
    res.status(error.response?.status || 500).send({
      error: 'Failed to refresh token',
    });
  }
}