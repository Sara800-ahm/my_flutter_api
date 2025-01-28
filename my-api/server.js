const express = require('express');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const cors = require('cors');

// إعداد Express
const app = express();
app.use(express.json());
app.use(cors()); // السماح لتطبيقات Flutter بالاتصال بـ API

// إعداد Swagger
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Product API',
      version: '1.0.0',
      description: 'API for managing products',
    },
  },
  apis: ['./server.js'], // الإشارة إلى هذا الملف لتحديد التوثيق
};

const swaggerDocs = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// قاعدة بيانات وهمية
let products = [];
let idCounter = 1;

/**
 * @swagger
 * /products:
 *   get:
 *     summary: Get all products
 *     responses:
 *       200:
 *         description: A list of products
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                   name:
 *                     type: string
 *                   price:
 *                     type: number
 */
app.get('/products', (req, res) => {
  res.json(products);
});

/**
 * @swagger
 * /products:
 *   post:
 *     summary: Add a new product
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               price:
 *                 type: number
 *     responses:
 *       201:
 *         description: Product added
 */
app.post('/products', (req, res) => {
  const { name, price } = req.body;
  const newProduct = { id: idCounter++, name, price };
  products.push(newProduct);
  res.status(201).json({ message: 'Product added', product: newProduct });
});

/**
 * @swagger
 * /products/{id}:
 *   put:
 *     summary: Update a product
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: The ID of the product to update
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               price:
 *                 type: number
 *     responses:
 *       200:
 *         description: Product updated
 */
app.put('/products/:id', (req, res) => {
  const { id } = req.params;
  const { name, price } = req.body;
  const product = products.find(p => p.id === parseInt(id));
  if (!product) {
    return res.status(404).json({ message: 'Product not found' });
  }
  product.name = name;
  product.price = price;
  res.json({ message: 'Product updated', product });
});

/**
 * @swagger
 * /products/{id}:
 *   delete:
 *     summary: Delete a product
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: The ID of the product to delete
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Product deleted
 */
app.delete('/products/:id', (req, res) => {
  const { id } = req.params;
  const index = products.findIndex(p => p.id === parseInt(id));
  if (index === -1) {
    return res.status(404).json({ message: 'Product not found' });
  }
  const deletedProduct = products.splice(index, 1);
  res.json({ message: 'Product deleted', product: deletedProduct[0] });
});

// تشغيل الخادم على البورت 3000
app.listen(3000, () => {
  console.log('Server is running on http://192.168.148.12:3000');
});
