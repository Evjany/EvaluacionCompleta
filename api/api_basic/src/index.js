/**
 * Author: DIEGO CASALLAS
 * Date: 01/01/2026
 * Description: Index file for the API - NODEJS
 */
import app from './app/app.js';
import dotenv from 'dotenv';

dotenv.config({ path: '../env' });
const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});