import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _voucherController = TextEditingController();
  double _discount = 0.0;
  String _paymentMethod = '';
  String _selectedBank = '';

  List<String> banks = ['Techcombank', 'Vietcombank', 'ACB', 'VietinBank'];

  Future<List<Cart>> get _getProducts async {
    return await _databaseHelper.products();
  }

  void _applyVoucher(String voucher) {
    Map<String, double> vouchers = {
      'DISCOUNT10': 0.1,
      'DISCOUNT20': 0.2,
      'DISCOUNT99': 0.9,
    };

    setState(() {
      if (vouchers.containsKey(voucher)) {
        _discount = vouchers[voucher]!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Voucher áp dụng thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _discount = 0.0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Voucher không hợp lệ!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  double _calculateTotal(List<Cart> products) {
    double total =
        products.fold(0, (sum, item) => sum + item.price * item.count);
    return total * (1 - _discount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: FutureBuilder<List<Cart>>(
              future: _getProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final itemProduct = snapshot.data![index];
                      return _buildProduct(itemProduct, context);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildPriceDetails(),
                const SizedBox(height: 10),
                TextField(
                  controller: _voucherController,
                  decoration: InputDecoration(
                    labelText: 'Nhập mã voucher',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _showVoucherConfirmationDialog(
                            context, _voucherController.text);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    List<Cart> products = await _getProducts;
                    double total = _calculateTotal(products);
                    _showPaymentMethodsDialog(context, total);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Thanh Toán",
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
    controller.forward();

    return FadeTransition(
      opacity: animation,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    DatabaseHelper().deleteProduct(pro.productID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${pro.name} đã được xóa khỏi giỏ hàng'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(pro.img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pro.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      NumberFormat('#,##0').format(pro.price),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    DatabaseHelper().minus(pro);
                  });
                },
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.amber.shade800,
                ),
              ),
              Text(
                pro.count.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    DatabaseHelper().add(pro);
                  });
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceDetails() {
    return FutureBuilder<List<Cart>>(
      future: _getProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Giỏ hàng trống"));
        }
        List<Cart> products = snapshot.data!;
        double total = _calculateTotal(products);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Container(
            key: ValueKey<double>(total),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(product.name),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${NumberFormat('#,##0').format(product.price)} x ${product.count}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            NumberFormat('#,##0')
                                .format(product.price * product.count),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tổng cộng:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      NumberFormat('#,##0').format(total),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVoucherConfirmationDialog(BuildContext context, String voucher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác Nhận Mã Voucher"),
          content:
              Text("Bạn có chắc chắn muốn áp dụng mã voucher \"$voucher\"?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Xác Nhận"),
              onPressed: () {
                Navigator.of(context).pop();
                _applyVoucher(voucher);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodsDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn phương thức thanh toán'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Thanh toán khi nhận hàng'),
                value: 'cod',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                  Navigator.of(context).pop();
                  _confirmPayment(total, 'cod');
                },
              ),
              RadioListTile<String>(
                title: const Text('Thanh toán bằng chuyển khoản ngân hàng'),
                value: 'bank',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                  Navigator.of(context).pop();
                  _showBankSelectionDialog(context, total);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBankSelectionDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn ngân hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: banks.map((bank) {
              return RadioListTile<String>(
                title: Text(bank),
                value: bank,
                groupValue: _selectedBank,
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value!;
                  });
                  Navigator.of(context).pop();
                  _confirmPayment(total, 'bank', _selectedBank);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _confirmPayment(double total, String paymentMethod, [String bank = '']) {
    String paymentDetails = paymentMethod == 'cod'
        ? 'Thanh toán khi nhận hàng'
        : 'Ngân hàng: $bank';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận thanh toán'),
          content: Text(
              'Tổng cộng: ${NumberFormat('#,##0').format(total)}\nPhương thức thanh toán: $paymentDetails\n\nBạn có chắc chắn muốn thanh toán không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Call the function to perform the actual payment process
                _performPayment(total, paymentMethod, bank);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  void _performPayment(double total, String paymentMethod, String bank) async {
    // Thực hiện logic thanh toán ở đây
    // Sau khi thanh toán thành công, lưu đơn hàng vào cơ sở dữ liệu hoặc gọi API lưu đơn hàng

    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Cart> temp = await _databaseHelper.products();
    // Gọi API thanh toán với thông tin tổng tiền, phương thức thanh toán và danh sách sản phẩm
    await APIRepository().addBill(
        temp, pref.getString('token').toString(), total,
        paymentMethod: paymentMethod);
    _databaseHelper.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Đã thanh toán thành công với phương thức: $paymentMethod'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
