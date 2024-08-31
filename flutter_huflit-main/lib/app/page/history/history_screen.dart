import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/bill.dart';
import 'package:app_api/app/page/history/history_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<BillModel>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository()
        .getHistory(prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BillModel>>(
      future: _getBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Text(
                'Lịch sử đơn hàng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final itemBill = snapshot.data![index];
                    return _billWidget(itemBill, context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await APIRepository()
            .getHistoryDetail(bill.id, prefs.getString('token').toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryDetail(bill: temp)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/images/bg67.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.zero, // Remove margin to fit within the Container
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người đặt hàng : ' + bill.fullName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors
                              .black, // Adjust text color for better readability
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Tổng tiền : ' +
                            NumberFormat('#,##0').format(bill.total) +
                            ' VNĐ',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors
                              .black, // Adjust text color for better readability
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Ngày đặt: ' + bill.dateCreated,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors
                              .black, // Adjust text color for better readability
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
