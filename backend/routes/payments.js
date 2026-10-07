const express = require('express');
const { body, validationResult } = require('express-validator');
const Payment = require('../models/Payment');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

router.get('/', protect, authorize('admin'), async (req, res, next) => {
  try {
    const payments = await Payment.find().sort({ createdAt: -1 });
    res.json(payments);
  } catch (error) {
    next(error);
  }
});

router.post(
  '/',
  protect,
  [
    body('amount').isFloat({ gt: 0 }).withMessage('Amount must be greater than zero'),
    body('method').notEmpty().withMessage('Payment method is required'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const payment = await Payment.create({
        ...req.body,
        status: 'pending',
      });

      res.status(201).json(payment);
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
