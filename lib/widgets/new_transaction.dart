import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransaction;

  NewTransaction(this.newTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isNotEmpty && (enteredAmount > 0)) {
      widget.newTransaction(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );

      Navigator.of(context).pop();
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Platform.isIOS
                ? CupertinoTextField(
                    placeholder: 'Title',
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                  )
                : TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                    // autofocus: true,
                  ),
            Platform.isIOS
                ? CupertinoTextField(
                    placeholder: 'Amount',
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _submitData(),
                  )
                : TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _submitData(),
                    // autofocus: true,
                  ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMd().format(_selectedDate),
                    ),
                  ),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _showDatePicker();
                          },
                        )
                      : FlatButton(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            _showDatePicker();
                          },
                        ),
                ],
              ),
            ),
            Platform.isIOS
                ? CupertinoButton(
                    child: Text(
                      'Add Transaction',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.button.color),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: _submitData,
                  )
                : RaisedButton(
                    child: Text('Add Transaction'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: _submitData,
                  ),
          ],
        ),
      ),
    );
  }
}
