import 'dart:math';
import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {

  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // iconTheme: IconThemeData(
          //   // color: Colors.white
          // ),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData().textTheme.copyWith(
          titleMedium: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
            fontSize: 18
          ),
        )
      ).copyWith(
        
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      ),
      // theme: tema.copyWith(
      //   colorScheme: tema.colorScheme.copyWith(
      //     primary: Colors.purple,
      //     secondary: Colors.amber,
      //   ),
      //   floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //     backgroundColor: Colors.amber,
      //   ),
      //   textTheme: tema.textTheme.copyWith(
      //     titleMedium: TextStyle(
      //       fontFamily: 'OpenSans',
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.black,
      //     ),
      //   ),
      //   appBarTheme: AppBarTheme(
      //     titleTextStyle: TextStyle(
      //       fontFamily: 'OpenSans',
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _transactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
      ? GestureDetector(onTap: fn, child: Icon(icon))
      : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {

  final mediaQuery = MediaQuery.of(context);

  bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown
    // ]);

  final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
  final chartIcon = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;
  

    final actions = <Widget> [
      if(isLandscape)
        _getIconButton(
          _showChart ? iconList : chartIcon,
          () {
            setState(() {
            _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      )
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
    ? CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    ) as ObstructingPreferredSizeWidget : AppBar(
      title: Text(
        'Despesas Pessoais',
        // style: TextStyle(
        //   fontSize: 20 * MediaQuery.textScalerOf(context).scale(1)
        // ),  
      ),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
    // _transactions.map((tr) {
    //   print(tr.title);
    // }).toList();

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            // if(isLandscape)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Exibir Gráfico"),
            //     Switch.adaptive(
            //       activeColor: Theme.of(context).colorScheme.secondary,
            //       value: _showChart, 
            //       onChanged: (bool value) {
            //         // print("OOOOOOOW showChart ${value}");
            //         setState(() {
            //           _showChart = value;
            //         });
            //       }
            //     ),
            //   ],
            // ),
            if(_showChart || !isLandscape) 
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(_recentTransactions)
              ),
            if(!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      )
    );

    return Platform.isIOS
    ? CupertinoPageScaffold(
        navigationBar: appBar as ObstructingPreferredSizeWidget,
        child: bodyPage,
      )
    : Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButton: Platform.isIOS 
      ? Container()
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}