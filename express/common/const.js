import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

// Get the directory name of the current module
const __dirname = dirname(fileURLToPath(import.meta.url));

export const stateKey = 'spotify_auth_state';
export const saveTokenFilePath = resolve(__dirname, '../token.json');