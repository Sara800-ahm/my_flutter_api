import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSubmit;

  const ProductForm({Key? key, this.product, required this.onSubmit}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch, // توليد ID في حالة الإضافة
        name: nameController.text,
        price: double.parse(priceController.text),
      );

      widget.onSubmit(newProduct);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
