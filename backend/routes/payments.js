const express = require('express');
const { body, validationResult } = require('express-validator');
const Payment = require('../models/Payment');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

// Get all payments (Admin)
router.get('/', protect, authorize('admin'), async (req, res, next) => {
  try {
    const payments = await Payment.find().sort({ createdAt: -1 }).populate('projectId', 'title');
    res.json(payments);
  } catch (error) {
    next(error);
  }
});

// Get single payment
router.get('/:id', protect, async (req, res, next) => {
  try {
    const payment = await Payment.findById(req.params.id).populate('projectId');

    if (!payment) {
      return res.status(404).json({ message: 'Payment not found' });
    }

    res.json(payment);
  } catch (error) {
    next(error);
  }
});

// Create payment (PromptPay / Bank Transfer)
router.post(
  '/',
  protect,
  [
    body('amount').isFloat({ gt: 0 }).withMessage('Amount must be greater than zero'),
    body('method').isIn(['promptpay', 'credit_card', 'bank_transfer']).withMessage('Invalid payment method'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { amount, method, projectId, description } = req.body;

      // Generate transaction ID
      const transactionId = `TXN-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

      const payment = await Payment.create({
        amount,
        method,
        projectId: projectId || null,
        description: description || '',
        transactionId,
        status: 'pending',
      });

      res.status(201).json({
        message: 'Payment created successfully',
        payment,
        // Generate payment instruction based on method
        paymentDetails: generatePaymentDetails(method, amount, transactionId),
      });
    } catch (error) {
      next(error);
    }
  }
);

// Update payment status (Admin)
router.put(
  '/:id',
  protect,
  authorize('admin'),
  [
    body('status').isIn(['pending', 'paid', 'failed']).withMessage('Invalid status'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const payment = await Payment.findByIdAndUpdate(
        req.params.id,
        { status: req.body.status },
        { new: true, runValidators: true }
      );

      if (!payment) {
        return res.status(404).json({ message: 'Payment not found' });
      }

      res.json(payment);
    } catch (error) {
      next(error);
    }
  }
);

// Get PromptPay QR Code (placeholder)
router.get('/promptpay/qr/:id', async (req, res, next) => {
  try {
    const payment = await Payment.findById(req.params.id);

    if (!payment || payment.method !== 'promptpay') {
      return res.status(404).json({ message: 'Payment not found or not PromptPay' });
    }

    // Placeholder - in production, use a PromptPay QR library
    res.json({
      message: 'PromptPay QR Code',
      amount: payment.amount,
      transactionId: payment.transactionId,
      // qrCode: generatePromptPayQR(payment),
    });
  } catch (error) {
    next(error);
  }
});

// Helper function to generate payment details
function generatePaymentDetails(method, amount, transactionId) {
  const baseDetails = {
    amount,
    transactionId,
    currency: 'THB',
  };

  switch (method) {
    case 'promptpay':
      return {
        ...baseDetails,
        method: 'PromptPay',
        instructions: [
          'Open PromptPay app or banking app',
          'Scan QR code below',
          `Pay ${amount} THB`,
          `Reference: ${transactionId}`,
        ],
        recipientName: 'Rn Archangel Works',
      };
    case 'bank_transfer':
      return {
        ...baseDetails,
        method: 'Bank Transfer',
        bankDetails: {
          bankName: 'Bangkok Bank', // Replace with actual bank
          accountName: 'Rn Archangel Works',
          accountNumber: 'XXXXXXXXXX', // Replace with actual account
          branch: 'Bangkok Branch',
        },
        instructions: [
          `Transfer ${amount} THB to above account`,
          `Reference: ${transactionId}`,
          'Send proof of payment to support@rnarchangelworks.com',
        ],
      };
    case 'credit_card':
      return {
        ...baseDetails,
        method: 'Credit Card',
        paymentGateway: 'Stripe / 2C2P', // Replace with actual gateway
        instructions: [
          'Use payment form to enter card details',
          'Process will be completed instantly',
          `Amount: ${amount} THB`,
        ],
      };
    default:
      return baseDetails;
  }
}

module.exports = router;
