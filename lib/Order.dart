import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order extends StatefulWidget {
  String username = '';
  String address = '';
  String phoneNumber = '';
  String memo = '';
  String subtotal = '';
  String tax = '';
  String total = '';
  String timestamp = '';
  String selectedYearMonthDay = '';
  String selectedDayOrder = '';
  List<dynamic> orderNamesList = [];
  List<dynamic> orderCountsList = [];

  Order({
    this.username,
    this.address,
    this.phoneNumber,
    this.memo,
    this.subtotal,
    this.tax,
    this.total,
    this.timestamp,
    this.orderNamesList,
    this.orderCountsList,
    this.selectedYearMonthDay,
    this.selectedDayOrder,
  });

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: FlatButton(
          onPressed: () async {
            await firestore
                .collection(widget.selectedYearMonthDay)
                .doc(widget.selectedDayOrder)
                .update({'backgroundColor': 'green'}).then((_) {});

            window.print();

            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.print),
              Text(' Print'),
            ],
          ),
        ),
      ),
      body: Container(
        width: 700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Row(
                children: [
                  Text('Customer Name: '),
                  Text(
                    '${widget.username}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Row(
                children: [
                  Text('Address: '),
                  Text(
                    '${widget.address}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Row(
                children: [
                  Text('Phone Number: '),
                  Text(
                    '${widget.phoneNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Text(
                'Order Time: ${widget.timestamp}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Text(
                'Memo: ${widget.memo}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Text(
                'Subtotal: \$${widget.subtotal}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Text(
                'Tax: \$${widget.tax}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Text(
                'Total: \$${widget.total}',
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 1),
                          child: Row(
                            children: [
                              Text('${widget.orderNamesList[index]}'),
                              Text('  x ${widget.orderCountsList[index]}'),
                            ],
                          ),
                        );
                      },
                      childCount: widget.orderNamesList.length,
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
}
