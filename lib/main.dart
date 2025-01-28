import 'package:flutter/material.dart';
import 'product_form.dart';
import 'package:get/get.dart';
import 'product_controller.dart';
import 'product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRUD with GetX',
      home: ProductScreen(),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return Center(child: Text('No Products Found'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Edit Product',
                        content: ProductForm(
                          product: product,
                          onSubmit: controller.updateProduct,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => controller.deleteProduct(product.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.defaultDialog(
            title: 'Add Product',
            content: ProductForm(
              onSubmit: controller.addProduct,
            ),
          );
        },
      ),
    );
  }
}
