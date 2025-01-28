import 'package:get/get.dart';
import 'api_service.dart';
import 'product.dart';
import 'database_service.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() {
    syncWithLocalDatabase();
    super.onInit();
  }

  Future<void> syncWithLocalDatabase() async {
    try {
      var localProducts = await _databaseService.fetchProducts();
      products.assignAll(localProducts);

      var apiProducts = await _apiService.fetchProducts();
      for (var product in apiProducts) {
        await _databaseService.insertProduct(product);
      }

      products.assignAll(await _databaseService.fetchProducts());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void addProduct(Product product) async {
    try {
      await _apiService.addProduct(product);
      await _databaseService.insertProduct(product);
      products.add(product);
      Get.back();
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void updateProduct(Product product) async {
    try {
      await _apiService.updateProduct(product);
      await _databaseService.insertProduct(product);
      int index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
      }
      Get.back();
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      await _databaseService.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
