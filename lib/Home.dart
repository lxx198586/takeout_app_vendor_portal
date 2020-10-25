import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Order.dart';

final items = List<DateTime>.generate(
    30,
        (i) =>
        DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
        ).add(Duration(days: -i)));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedYearMonthDay = '';

  String username = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String address = '';
  String phoneNumber = '';
  String memo = '';
  String subtotal = '';
  String tax = '';
  String total = '';
  String timestamp = '';
  String orderNames = '';
  String orderCounts = '';
  String _selectedDayOrder = '';
  String backgroundColorCode = '';
  List<dynamic> orderNamesList = [];
  List<dynamic> orderCountsList = [];

  List<String> _selectedDayOrders = [];
  List<String> _selectedDayOrdersBackgroundColor = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    Order(
                      username: username,
                      address: address,
                      phoneNumber: phoneNumber,
                      memo: memo,
                      subtotal: subtotal,
                      tax: tax,
                      total: total,
                      timestamp: timestamp,
                      orderNamesList: orderNamesList,
                      orderCountsList: orderCountsList,
                      selectedYearMonthDay: _selectedYearMonthDay,
                      selectedDayOrder: _selectedDayOrder,
                    ),
              ),
            );
          },
          child: Column(
            children: [
              Icon(Icons.print),
              Text('Click Here to Print'),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            // flex: 1,
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    _selectedDayOrders = [];
                    _selectedDayOrdersBackgroundColor = [];
                    _selectedYearMonthDay =
                    '${items[index].year}-${items[index].month}-${items[index]
                        .day}';

                    await firestore
                        .collection(_selectedYearMonthDay)
                        .get()
                        .then((snapshot) {
                      snapshot.docs.forEach((doc) {
                        _selectedDayOrders.add(doc.id);
                        _selectedDayOrdersBackgroundColor.add(doc['backgroundColor']);
                        // print(_selectedDayOrdersBackgroundColor);
                      });
                    });
                    setState(() {
                      _selectedDayOrders = _selectedDayOrders;
                      _selectedYearMonthDay = _selectedYearMonthDay;
                    });
                  },
                  title: Text(
                      '${items[index].month}-${items[index].day}-${items[index]
                          .year}'),
                );
              },
            ),
          ),
          const VerticalDivider(
            color: Colors.black,
            thickness: 5,
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _selectedDayOrders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    await firestore
                        .collection(_selectedYearMonthDay)
                        .doc('${_selectedDayOrders[index]}')
                        .get()
                        .then((snapshot) {
                      setState(() {
                        _selectedDayOrder = _selectedDayOrders[index];
                        subtotal = snapshot.data()['subtotal'];
                        tax = (double.parse('$subtotal') * 0.0875)
                            .toStringAsFixed(2);
                        total = (double.parse('$subtotal') * 1.0875)
                            .toStringAsFixed(2);
                        cvv = snapshot.data()['CVV'];
                        address = snapshot.data()['address'];
                        cardNumber = snapshot.data()['credit card number'];
                        expiryDate = snapshot.data()['expiry date'];
                        memo = snapshot.data()['memo'];
                        username = snapshot.data()['name'];
                        phoneNumber = snapshot.data()['phone number'];
                        orderNames = snapshot.data()['order names'];
                        orderCounts = snapshot.data()['order counts'];
                        Timestamp t = snapshot.data()['timestamp'];
                        DateTime d = t.toDate();
                        timestamp = d.toString();
                        backgroundColorCode =
                        snapshot.data()['backgroundColor'];
                        orderNamesList = json.decode(orderNames);
                        orderCountsList = json.decode(orderCounts);
                      });
                    });
                  },
                  title: Text(
                    '${_selectedDayOrders[index]}',
                    style: TextStyle(
                      backgroundColor: (_selectedDayOrdersBackgroundColor[index] == 'red') ?
                      Colors.red[200] :
                      Colors.transparent,
                    ),
                  ),
                );
              },
            ),
          ),

          const VerticalDivider(
            color: Colors.black,
            thickness: 5,
          ),
          Container(),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Customer Name: $username',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Address: $address',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Phone Number: $phoneNumber',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Order Time: $timestamp',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Memo: $memo',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Credit Card: $cardNumber',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Expiry Date: $expiryDate',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'CVV: $cvv',
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderNamesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${orderNamesList[index]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Order: ${orderCountsList[index]}',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Subtotal: \$$subtotal',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Tax: \$$tax',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Text(
                    'Total: \$$total',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
