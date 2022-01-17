import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TxCard extends StatefulWidget {
  final Transaction transaction;
  final Function deleteTx;

  const TxCard({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  @override
  State<TxCard> createState() => _TxCardState();
}

class _TxCardState extends State<TxCard> {
  // Color _bgColor;

  @override
  void initState() {
    // const availableColors = [
    //   Colors.red,
    //   Colors.black,
    //   Colors.blue,
    //   Colors.purple,
    // ];

    // _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 8,
      ),
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              child: CircleAvatar(
                // backgroundColor: _bgColor,
                radius: 25,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: FittedBox(
                    child: Text(
                      '\$${widget.transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd  hh:mm:ss')
                        .format(widget.transaction.date),
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            MediaQuery.of(context).size.width > 360
                ? FlatButton.icon(
                    icon: Icon(
                      Icons.delete,
                      size: 24,
                    ),
                    label: Text('Delete'),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () {
                      widget.deleteTx(widget.transaction.id);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    iconSize: 32,
                    onPressed: () {
                      widget.deleteTx(widget.transaction.id);
                    },
                  )
          ],
        ),
      ),
    );
  }
}
