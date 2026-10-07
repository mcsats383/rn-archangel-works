const express = require('express');
const Project = require('../models/Project');
const Contact = require('../models/Contact');
const News = require('../models/News');
const Payment = require('../models/Payment');
const { protect, authorize } = require('../middleware/auth');

const router = express.Router();

router.get('/', protect, authorize('admin'), async (req, res, next) => {
  try {
    const [projectCount, contactCount, newsCount, paymentCount] = await Promise.all([
      Project.countDocuments(),
      Contact.countDocuments(),
      News.countDocuments(),
      Payment.countDocuments(),
    ]);

    res.json({
      totalProjects: projectCount,
      totalContacts: contactCount,
      totalNews: newsCount,
      totalPayments: paymentCount,
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
