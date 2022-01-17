import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  TransactionList(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraint) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: constraint.maxHeight * 0.06,
                  ),
                  Container(
                    height: constraint.maxHeight * 0.1,
                    child: Text(
                      'No transaction added yet!',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: constraint.maxHeight * 0.02,
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 20),
                    height: constraint.maxHeight * 0.4,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TxCard(
                key: ValueKey(transactions[index].id),
                transaction: transactions[index],
                deleteTx: _deleteTransaction,
              );
            },
            itemCount: transactions.length,
          );
  }
}
