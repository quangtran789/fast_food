import 'package:app_api/app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  int _quantity = 1;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _onSave(ProductModel product) async {
    await _databaseService.insertProduct(
      Cart(
        productID: product.id,
        name: product.name,
        des: product.description,
        price: product.price,
        img: product.imageUrl,
        count: _quantity,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} thêm vào giỏ hàng thành công.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onFavorite(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name} đã thêm vào danh sách yêu thích.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _decreaseQuantity,
                              child: Icon(Icons.remove,
                                  size: 20, color: Colors.black),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '$_quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            GestureDetector(
                              onTap: _increaseQuantity,
                              child: Icon(Icons.add,
                                  size: 20, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'en_US', symbol: '')
                            .format(product.price * _quantity),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => _onFavorite(product),
                  label: Text('Yêu thích'),
                  icon: Icon(Icons.favorite),
                  backgroundColor: Colors.red,
                ),
                FloatingActionButton.extended(
onPressed: () => _onSave(product),
                  label: Text('Thêm vào giỏ hàng'),
                  icon: Icon(Icons.shopping_cart),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
