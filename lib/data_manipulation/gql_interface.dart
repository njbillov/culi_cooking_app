import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../theme.dart';

class GraphQLWrapper {
  static GraphQLWrapper _wrapper;
  final GraphQLClient _client;

  GraphQLWrapper._(this._client);

  static Future<bool> setEndpoints(
      {String httpUri =
          // 'http://192.168.86.32:8080/graphql',
          'http://ec2-54-235-235-19.compute-1.amazonaws.com:8080/graphql',
      String authUri = ""}) async {
    if (_wrapper != null) {
      print("Connecting a new client");
    }
    final httpLink = HttpLink(uri: httpUri);

    Link link;

    if (authUri.isNotEmpty) {
      final authLink = AuthLink(getToken: () async => authUri);

      link = authLink.concat(httpLink);
    } else {
      link = httpLink;
    }
    _wrapper =
        GraphQLWrapper._(GraphQLClient(link: link, cache: InMemoryCache()));

    final results = await _wrapper._client.queryManager
        .query(QueryOptions(documentNode: gql('{hello}')));
    if (results.hasException) {
      if (results.exception.clientException is NetworkException) {
        // log(results.source.toString());
      }
      log(results.exception.toString());
    }
    log(results.data.toString());
    return results.data != null;
  }

  static Future<Map<String, dynamic>> query(String query,
      {Map<String, dynamic> variables}) async {
    if (_wrapper == null) {
      print("GraphQL wrapper client is not set.");
      return null;
    }
    variables ??= {};
    final queryOptions = QueryOptions(
      documentNode: gql(query),
      fetchPolicy: FetchPolicy.noCache,
      variables: variables,
    );

    final results = await _wrapper._client.query(queryOptions);

    // print(results.data);

    return results.data;
  }

  static Future<Map<String, dynamic>> mutate(String query,
      {Map<String, dynamic> variables}) async {
    if (_wrapper == null) {
      print("GraphQL wrapper client is not set.");
      return null;
    }

    variables ??= {};
    final mutationOptions = MutationOptions(
      documentNode: gql(query),
      fetchPolicy: FetchPolicy.noCache,
      variables: variables,
    );

    final results = await _wrapper._client.mutate(mutationOptions);

    // print(results.data);

    return results.data;
  }
}

enum RandomEvent { getRandom }

class RandomBloc extends Bloc<RandomEvent, double> {
  RandomBloc() : super(0);

  static const String query = r'''
    query {
      random
    }
    ''';

  @override
  Stream<double> mapEventToState(RandomEvent event) async* {
    switch (event) {
      case RandomEvent.getRandom:
        print("Fetching remote random number");
        final results = await GraphQLWrapper.query(query);
        print(results);
        final rand = results['random'] as double;
        await Future.delayed(Duration(milliseconds: (rand * 1000).ceil()));
        yield rand;
        break;
    }
  }
}

class RandomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    final randomBloc = BlocProvider.of<RandomBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<RandomBloc, double>(
        builder: (context, randomNumber) {
          return Center(
            child: Column(
              children: [
                Text(
                  '$randomNumber',
                  style: TextStyle(fontSize: 24.0),
                ),
                CuliButton("Get Random Number", onPressed: () {
                  print("Pressing button");
                  randomBloc.add(RandomEvent.getRandom);
                })
              ],
            ),
          );
        },
      ),
    );
  }
}

const String helloQuery = r'''
  query {
    hello(name: "Nicky")
  }
''';

void main() async {
  print(await GraphQLWrapper.setEndpoints());
  final data = await GraphQLWrapper.query(r'query { hello(name: "Nicky") }');
  print(data['hello']);
  runApp(MaterialApp(
      home: BlocProvider(
    create: (context) => RandomBloc(),
    child: RandomPage(),
  )));
//
//   final httpLink = HttpLink(uri: 'http://localhost:8080/graphql');
//
//   final Link link = httpLink;
//
//   final QueryManager manager = QueryManager(link: link, cache: InMemoryCache());
//
//   final queryResults = await manager.query(QueryOptions(
//     documentNode: gql(r'''
//   query {
//     hello(name: "Nicky")
//   }
// '''),
//     )
//   );
//
//   print(queryResults.data);
}
