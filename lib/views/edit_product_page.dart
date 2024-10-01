import 'package:flutter/material.dart';
import '../models/product_model.dart'; // Import your ProductModel
import '../controllers/product_service.dart'; // Import your ProductService
import '../providers/user_provider.dart'; // Import your UserProvider
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  late String _productName;
  late String _productType;
  late int _price;
  late String _unit;

  @override
  void initState() {
    super.initState();
    _productName = widget.product.productName;
    _productType = widget.product.productType;
    _price = widget.product.price;
    _unit = widget.product.unit;
  }

  void _editProduct() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final updatedProduct = ProductModel(
        id: widget.product.id, // Use the existing product ID
        productName: _productName,
        productType: _productType,
        price: _price,
        unit: _unit,
      );

      try {
        await _productService.updateProduct(updatedProduct, userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _productName,
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (value) {
                  _productName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _productType,
                decoration: InputDecoration(labelText: 'Product Type'),
                onChanged: (value) {
                  _productType = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _price = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _unit,
                decoration: InputDecoration(labelText: 'Unit'),
                onChanged: (value) {
                  _unit = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
