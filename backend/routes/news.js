const express = require('express');
const { body, validationResult } = require('express-validator');
const News = require('../models/News');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const news = await News.find().sort({ publishedDate: -1 });
    res.json(news);
  } catch (error) {
    next(error);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const item = await News.findById(req.params.id);

    if (!item) {
      return res.status(404).json({ message: 'News item not found' });
    }

    res.json(item);
  } catch (error) {
    next(error);
  }
});

router.post(
  '/',
  protect,
  authorize('admin'),
  [
    body('title').notEmpty().withMessage('Title is required'),
    body('content').notEmpty().withMessage('Content is required'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const item = await News.create(req.body);
      res.status(201).json(item);
    } catch (error) {
      next(error);
    }
  }
);

router.put(
  '/:id',
  protect,
  authorize('admin'),
  async (req, res, next) => {
    try {
      const item = await News.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true,
      });

      if (!item) {
        return res.status(404).json({ message: 'News item not found' });
      }

      res.json(item);
    } catch (error) {
      next(error);
    }
  }
);

router.delete(
  '/:id',
  protect,
  authorize('admin'),
  async (req, res, next) => {
    try {
      const item = await News.findByIdAndDelete(req.params.id);

      if (!item) {
        return res.status(404).json({ message: 'News item not found' });
      }

      res.json({ message: 'News item deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
