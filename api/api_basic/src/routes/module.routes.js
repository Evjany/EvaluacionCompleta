/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026   
*Description: This file defines the routes for user management. It includes routes for creating, retrieving, updating, and deleting users. The routes are handled by the corresponding controller functions imported from 'user.controller.js'. The `verifyToken` middleware is used to ensure that only authenticated users can access certain routes.
**/
import { Router } from 'express';
import { showModule, showUserId, addUser, updateUser, deleteUser } from '../controllers/module.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/module';


router.route(apiName)
  .get(verifyToken,showModule) // Get user
  .post(verifyToken,addUser); // Add user

router.route(`${apiName}/:id`)
  .get(verifyToken,showUserId)  // Get user by Id
  .put(verifyToken,updateUser)  // Update user by Id
  .delete(verifyToken,deleteUser); // Delete user by Id

export default router;