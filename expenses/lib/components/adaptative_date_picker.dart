import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {

  final DateTime? selectedDate;
  final dynamic onDateChanged;

  AdaptativeDatePicker({
    this.selectedDate,
    this.onDateChanged,
  });

   _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null) {
        return;
      }

      onDateChanged(pickedDate);
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
    ? Container(
      height: 180,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        minimumDate: DateTime(2022),
        maximumDate: DateTime.now(),
        onDateTimeChanged: onDateChanged,
      ),
    )
    : Container(
      height: 70,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget> [
          Expanded(
            child: Text(
              selectedDate == null 
              ? 'Nenhuma data selecionada!'
              : 'Data Selecionada: ${DateFormat('dd/MM/y').format(selectedDate as DateTime)}'
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.purple,
            ),
            child: Text(
              'Selecionar Data',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () => _showDatePicker(context)
          )
        ],
      ),
    );
  }

}