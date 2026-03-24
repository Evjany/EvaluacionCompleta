import ProfileModel from '../models/profile.model.js';

export const getProfiles = async (req, res) => {
  const model = new ProfileModel();
  model.getAll(res);
};

export const getProfileById = async (req, res) => {
  const model = new ProfileModel();
  model.getById(req, res);
};

export const createProfile = async (req, res) => {
  const model = new ProfileModel();
  model.create(req, res);
};

export const updateProfile = async (req, res) => {
  const model = new ProfileModel();
  model.update(req, res);
};

export const deleteProfile = async (req, res) => {
  const model = new ProfileModel();
  model.delete(req, res);
};