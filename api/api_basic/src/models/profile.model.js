import db from '../config/db.js';

export default class ProfileModel {

  async getAll(res) {
    try {
      const [rows] = await db.query('SELECT * FROM profiles');
      res.json(rows);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getById(req, res) {
    try {
      const { id } = req.params;
      const [rows] = await db.query('SELECT * FROM profiles WHERE Profile_id = ?', [id]);
      res.json(rows[0]);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async create(req, res) {
    try {
      const data = req.body;
      await db.query('INSERT INTO profiles SET ?', [data]);
      res.json({ message: 'Profile created' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async update(req, res) {
    try {
      const { id } = req.params;
      const data = req.body;
      await db.query('UPDATE profiles SET ? WHERE Profile_id = ?', [data, id]);
      res.json({ message: 'Profile updated' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async delete(req, res) {
    try {
      const { id } = req.params;
      await db.query('DELETE FROM profiles WHERE Profile_id = ?', [id]);
      res.json({ message: 'Profile deleted' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}