import cookieParser from 'cookie-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import { loginRoute } from './routes/login.js';
import { callbackRoute } from './routes/callback.js';
import { refreshTokenRoute } from './routes/refresh-token.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3030;

app.use(express.static(new URL('./public', import.meta.url).pathname))
   .use(cors())
   .use(cookieParser());

app.get('/login', loginRoute);
app.get('/callback', callbackRoute);
app.post('/refresh_token', refreshTokenRoute);

app.listen(PORT, () => {
  console.log(`-- Server is running on port ${PORT}`);
});