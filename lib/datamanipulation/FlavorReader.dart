
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:app/Theme.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlavorReader {
  final String filename;
  Map<String, String> _flavorMap;
  Future _completed;

  FlavorReader(this.filename) {
    _completed = read();
  }

  read() async {
    final entryList = await File(filename).openRead()
      .transform(utf8.decoder)
      .transform(new CsvToListConverter(shouldParseNumbers: false))
      .where((event) => event.length == 2)
      .map((event) => MapEntry<String, String>(event[0], event[1]))
      .toList();

    _flavorMap = Map.fromEntries(entryList);
  }

  Future get initialized => _completed;

  Future<String> row(String row) async {
    await initialized;
    return _flavorMap[row] ?? "Row not found";
  }

  Future<void> printRow(String r) async {
    String val = await row(r);
    print(val);
  }
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);

  @override void onChange(Change change) {
    print(change);
    super.onChange(change);
  }
}

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('${cubit.runtimeType} $error $stackTrace');
    super.onError(cubit, error, stackTrace);
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count) {
          return Center(
            child: Column(
              children: [
                Text(
                  '$count',
                  style: TextStyle(fontSize: 24.0),
                ),
                CuliButton("Increment", onPressed: () => counterBloc.add(CounterEvent.increment)),
                CuliButton("Decrement", onPressed: () => counterBloc.add(CounterEvent.decrement)),
              ],
            ),
          );
        },
      ),
    );
  }
}


main() {
  runApp(MaterialApp(
      home: BlocProvider(
        lazy: false,
        create: (BuildContext context) => CounterBloc(),
        child: CounterPage(),
      )
    )
  );
}

// main() async {
//   print("Starting main");
//   final reader = new FlavorReader("assets/test.csv");
//   reader.printRow("row1");
//   reader.printRow("row2");
//   reader.printRow("row3");
//   // reader.printAll();
//   // print(reader.getText("row1"));
//   // print(reader.getText("row2"));
//   // print(reader.getText("row3"));
// }