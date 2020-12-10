import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../Theme.dart';

class GraphQLWrapper {
  static GraphQLWrapper _wrapper;
  final GraphQLClient _client;

  GraphQLWrapper._(this._client);

  static Future<bool> setEndpoints({String httpUri = "http://localhost:8080/graphql", String authUri = ""}) async {
    if (_wrapper != null) {
      print("Client already connected");
      return false;
    }
    final httpLink = HttpLink(uri: httpUri);

    Link link;
    
    if(authUri.isNotEmpty) {
      final authLink = AuthLink(getToken: () async => authUri);

      link = authLink.concat(httpLink);
    }
    else {
      link = httpLink;
    }

    _wrapper = GraphQLWrapper._(GraphQLClient(link: link));

    return true;
  }

  static Future<Map<String, dynamic>> query(String query) async {
    if (_wrapper == null) {
      print("GraphQL wrapper client is not set.");
      return null;
    }

    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(query),
      fetchPolicy: FetchPolicy.noCache,
    );

    final results = await _wrapper._client.query(queryOptions);

    print(results.data);

    return results.data;
  }

  static Future<Map<String, dynamic>> mutate(String query) async {
    if (_wrapper == null) {
      print("GraphQL wrapper client is not set.");
      return null;
    }

    final MutationOptions mutationOptions = MutationOptions(
      documentNode: gql(query),
    );

    final results = await _wrapper._client.mutate(mutationOptions);

    print(results.data);

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
        await Future.delayed(new Duration(milliseconds: (rand * 1000).ceil()));
        yield rand;
        break;
    }
  }
}

class RandomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RandomBloc randomBloc = BlocProvider.of<RandomBloc>(context);

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
                }
                )
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

main() async {
  print(await GraphQLWrapper.setEndpoints());
  // final data = await GraphQLWrapper.query(r'query { hello(name: "Nicky") }');
  // print(data['hello']);
  runApp(MaterialApp(
    home: BlocProvider(
      create: (BuildContext context) => RandomBloc(),
      child: RandomPage(),
    )
  ));
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