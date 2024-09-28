import 'package:flutter/material.dart';
import 'package:expenses/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> transactions;
  final void Function(String) onRemove;
  
  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty 
    ? LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Nenhuma Transação Cadastrada!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),
            Container(
              height: constraints.maxHeight * 0.6,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
            )
          ],
        );
      }
    )
    : ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, index) {
        final tr = transactions[index];
        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(
                  child: Text(
                    'R\$${tr.value}',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ),
              ),
            ),
            title: Text(
              tr.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
                DateFormat('d MMM y').format(tr.date)
            ),
            trailing: MediaQuery.of(context).size.width > 480 ?
            ElevatedButton.icon(
              onPressed: () => onRemove(tr.id),
              icon: Icon(Icons.delete),
              label: Text('Excluir'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error
              ),
              
            ) : IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => onRemove(tr.id),
            ),
          ),
        );
      },
    );
  }
}