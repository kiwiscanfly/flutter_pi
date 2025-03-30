import { stateKey } from '../common/const.js';
import crypto from 'crypto';

const generateRandomString = (length) =>
  crypto.randomBytes(60).toString('hex').slice(0, length);

export async function loginRoute(req, res) {
  const state = generateRandomString(16);
  res.cookie(stateKey, state);

  // Your application requests authorization
  const params = new URLSearchParams({
    response_type: 'code',
    client_id: process.env.SPOTIFY_CLIENT_ID,
    scope: process.env.SPOTIFY_SCOPES,
    redirect_uri: process.env.SPOTIFY_REDIRECT_URI,
    state: state,
  });

  res.redirect(`https://accounts.spotify.com/authorize?${params.toString()}`);
}