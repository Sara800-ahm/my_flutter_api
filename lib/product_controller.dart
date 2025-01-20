import 'package:get/get.dart';
import 'api_service.dart';
import 'product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      var fetchedProducts = await _apiService.fetchProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

 void addProduct(Product product) async {
  try {
    await _apiService.addProduct(product);

    // أضف المنتج الجديد مباشرةً إلى القائمة المحلية
    products.add(product);

    // إغلاق نافذة الحوار
    Get.back();

    // رسالة نجاح
    Get.snackbar('Success', 'Product added successfully');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}


  void updateProduct(Product product) async {
  try {
    await _apiService.updateProduct(product);

    // تحديث المنتج في القائمة المحلية
    int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
    }

    // إغلاق نافذة الحوار
    Get.back();

    // رسالة نجاح
    Get.snackbar('Success', 'Product updated successfully');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}


 void deleteProduct(int id) async {
  try {
    await _apiService.deleteProduct(id);

    // حذف المنتج من القائمة المحلية
    products.removeWhere((product) => product.id == id);

    // رسالة نجاح
    Get.snackbar('Success', 'Product deleted successfully');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}
}