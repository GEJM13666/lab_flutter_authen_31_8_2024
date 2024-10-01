import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../variables.dart'; // Update this import with your actual variables file
import '../providers/user_provider.dart'; // Import your UserProvider
import '../controllers/auth_service.dart'; // Import your AuthService if needed

class ProductService {
  // Centralized method for handling responses
Future<void> _handleResponse(http.Response response, UserProvider userProvider) async {
  if (response.statusCode == 200 || response.statusCode == 201) {
    // Success, do nothing
    return;
  } else if (response.statusCode == 403) {
    // Handle 403 - Forbidden
    await AuthService().refreshToken(userProvider);
  } else if (response.statusCode == 401) {
    // Handle 401 - Unauthorized
    userProvider.onLogout(); // Log out the user
    throw Exception('Unauthorized, redirecting to logout.');
  } else {
    throw Exception('Error: ${response.statusCode} - ${response.body}');
  }
}



  Future<List<ProductModel>> fetchProducts(UserProvider userProvider) async {
    final response = await http.get(
      Uri.parse('$apiURL/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.accessToken}', // Add access token here
      },
    );

    await _handleResponse(response, userProvider); // Handle response

    // Parse the JSON response and return a list of ProductModel
    List<dynamic> productList = jsonDecode(response.body);
    return productList.map((json) => ProductModel.fromJson(json)).toList();
  }

  // Add a new product

  Future<void> addProduct(ProductModel product, UserProvider userProvider) async {
  final response = await http.post(
    Uri.parse('$apiURL/api/product'), // Adjust this URL
    headers: {
      'Authorization': 'Bearer ${userProvider.accessToken}',
      'Content-Type': 'application/json',
    },
    body: json.encode(product.toJson()),
  );

  await _handleResponse(response, userProvider); // Handle response
}


  

  Future<void> updateProduct(ProductModel product, UserProvider userProvider) async {
    final response = await http.put(
      Uri.parse('$apiURL/api/product/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.accessToken}', // Use access token
      },
      body: jsonEncode(product.toJson()),
    );

    await _handleResponse(response, userProvider); // Handle response
  }

  // Delete method
  Future<void> deleteProduct(String productId, UserProvider userProvider) async {
    final response = await http.delete(
      Uri.parse('$apiURL/api/product/$productId'),
      headers: {
        'Authorization': 'Bearer ${userProvider.accessToken}', // Use access token
        'Content-Type': 'application/json', // Ensure you're setting the content type
      },
    );

    await _handleResponse(response, userProvider); // Handle response
  }
}
