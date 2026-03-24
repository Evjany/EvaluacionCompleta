/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Application setup for the API - NODEJS
**/
import express from 'express';
import userRoutes from '../routes/user.routes.js';
import cors from 'cors';
import userStatusRoutes from '../routes/userStatus.routes.js';
import roleRoutes from '../routes/role.routes.js';
import userApiRoutes from '../routes/apiUser.routes.js';
import modelRoutes from '../routes/module.routes.js';

// Create an instance of the Express application
const app = express();
// Define the base path for the API
const NAME_API = '/api_v1';
// Middleware to handle JSON
app.use(cors());
app.use(express.json());

// Routes for the API
app.use(NAME_API, userRoutes);
app.use(NAME_API, userStatusRoutes);
app.use(NAME_API, roleRoutes);
app.use(NAME_API, userApiRoutes);
app.use(NAME_API, modelRoutes);

// Handle 404 errors for undefined routes
app.use((req, res, next) => {
  res.status(404).json({
    message: 'Endpoint losses 404, not found'
  });
});

export default app;