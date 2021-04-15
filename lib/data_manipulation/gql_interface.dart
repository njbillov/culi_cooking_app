import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLWrapper {
  static GraphQLWrapper _wrapper;
  final GraphQLClient _client;

  GraphQLWrapper._(this._client);

  // This is the current API endpoint
  static Future<bool> setEndpoints(
      {String httpUri =
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
