import 'dart:convert';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/app/page/home/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ProductBuilder1 extends StatefulWidget {
  const ProductBuilder1({Key? key}) : super(key: key);

  @override
  State<ProductBuilder1> createState() => _ProductBuilder1State();
}

class _ProductBuilder1State extends State<ProductBuilder1> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  final formatCurrency = NumberFormat('#,##0', 'vi_VN');
  String _searchQuery = '';

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ProductModel> products = await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );

    if (_searchQuery.isNotEmpty) {
      products = products
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return products;
  }

  User user = User.userEmpty();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  List<ProductModel> _shuffleProducts(List<ProductModel> products) {
    var random = Random();
    for (int i = products.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      var temp = products[i];
      products[i] = products[j];
      products[j] = temp;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg67.jpg'), // Thay đổi đường dẫn tới hình nền của bạn
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the screen
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TÌM VÀ ĐẶT MÓN THEO Ý CỦA BẠN',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm sản phẩm...',
                    fillColor: Colors.grey[200], // Màu nền của TextField
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 175,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.85,
                        ),
                        items: [
                          'assets/images/image.png',
                          'assets/images/post2.jpg',
                          'assets/images/post3.jpg',
                          'assets/images/post4.jpg',
                        ].map((imgPath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage(imgPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Sản phẩm HOT của tháng",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 180,
                        child: FutureBuilder<List<ProductModel>>(
                          future: _getProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              // Xáo trộn danh sách sản phẩm trước khi hiển thị
                              List<ProductModel> shuffledProducts =
                                  _shuffleProducts(snapshot.data!);

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: shuffledProducts.length,
                                itemBuilder: (context, index) {
                                  final itemProduct = shuffledProducts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                  product: itemProduct),
                                        ),
                                      );
                                    },
                                    child: _buildProductHorizontal(
                                        itemProduct, context),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text("No products available."),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Danh sách sản phẩm",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<List<ProductModel>>(
                          future: _getProducts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final itemProduct = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                  product: itemProduct),
                                        ),
                                      );
                                    },
                                    child: _buildProduct(itemProduct, context),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text("No products available."),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductHorizontal(ProductModel pro, BuildContext context) {
    // Dummy rating data
    final double rating = 4.5; // Example rating

    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(pro.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${formatCurrency.format(pro.price)} đ',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    // Dummy rating data
    final double rating = 4.5; // Example rating

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(pro.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '${formatCurrency.format(pro.price)} đ',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  // Rating section
                  Row(
                    children: [
                      _buildStarRating(rating),
                      const SizedBox(width: 8.0),
                      Text(
                        '$rating',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      _onSave(pro);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shadowColor: Colors.black.withOpacity(0.3),
                      elevation: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add_shopping_cart, size: 27),
                          SizedBox(width: 8),
                          Text(
                            'Thêm vào giỏ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    const int maxRating = 5;
    return Row(
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20.0,
        );
      }),
    );
  }
}
