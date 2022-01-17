import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // use this code if you want to force your App to run on a specific orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // We can also return CupertinoApp() based on the Platform
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          caption: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (element) {
        return element.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate != null ? chosenDate : DateTime.now(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      // isScrollControlled: true,
      context: ctx,
      builder: (bCtx) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
          ),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Delete Transaction'),
            content: Text('Transaction will be deleted, continue?'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _userTransactions
                        .removeWhere((element) => element.id == id);
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  bool _showChart = false;
  final double _switchHeight = 25;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: Make some changes based on the state of App
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    size: 32,
                  ),
                  onTap: () {
                    _startNewTransaction(context);
                  },
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  size: 32,
                ),
                onPressed: () {
                  _startNewTransaction(context);
                },
              ),
            ],
          );

    double _mainHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final pageBody = SafeArea(
      // Respect the Top area in iOS which is not usable for Apps, that's just for Navigation Bar
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              height: _switchHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption.fontSize),
                  ),
                  Switch.adaptive(
                    // Some widgets have this constructor to get the default style of different platforms ( Android / iOS )
                    value: _showChart,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  )
                ],
              ),
            ),
            if (isLandscape)
              (_showChart
                  ? Container(
                      height: (_mainHeight - _switchHeight),
                      child: Chart(_recentTransactions),
                    )
                  : Container(
                      height: (_mainHeight - _switchHeight),
                      child: TransactionList(
                          _userTransactions, _deleteTransaction),
                    )),
            if (!isLandscape)
              (_showChart
                  ? Container(
                      height: (_mainHeight - _switchHeight) * 0.3,
                      child: Chart(_recentTransactions),
                    )
                  : SizedBox.shrink()),
            if (!isLandscape)
              (Container(
                height: (_mainHeight - _switchHeight) * (_showChart ? 0.7 : 1),
                child: TransactionList(_userTransactions, _deleteTransaction),
              )),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? SizedBox.shrink()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      size: 38,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _startNewTransaction(context);
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
