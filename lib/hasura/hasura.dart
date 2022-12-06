import 'package:gymbro_web/hasura/hasura_action.dart';
import 'package:gymbro_web/hasura/hasura_mutation.dart';
import 'package:gymbro_web/hasura/hasura_query.dart';
import 'package:gymbro_web/hasura/type_def.dart';

class Hasura {
  Hasura.query({
    required List<HasuraQuery> this.actions,
  }) : variables = null;

  Hasura.queryById({
    required String table,
    required int id,
    required Set returning,
  })  : variables = null,
        actions = [
          HasuraQuery.byId(
            table: table,
            id: id,
            returning: returning,
          ),
        ];

  Hasura.queryList({
    required String table,
    JsonMap? where,
    required Set returning,
  })  : variables = null,
        actions = [
          HasuraQuery.list(
            table: table,
            where: where,
            returning: returning,
          ),
        ];

  Hasura.mutation({
    this.variables,
    required List<HasuraMutation> this.actions,
  });

  Hasura.insert({
    this.variables,
    required String table,
    required JsonMap object,
    required Set returning,
  }) : actions = [
          HasuraMutation.insert(
            table: table,
            object: object,
            returning: returning,
          ),
        ];

  Hasura.updateById({
    this.variables,
    required String table,
    required int id,
    required JsonMap parameters,
    required Set returning,
  }) : actions = [
          HasuraMutation.updateById(
            table: table,
            id: id,
            parameters: parameters,
            returning: returning,
          ),
        ];

  Hasura.update({
    this.variables,
    required String table,
    required JsonMap parameters,
    required Set returning,
  }) : actions = [
          HasuraMutation.update(
            table: table,
            parameters: parameters,
            returning: returning,
          ),
        ];

  Hasura.deleteById({
    this.variables,
    required String table,
    required int id,
    required Set returning,
  }) : actions = [
          HasuraMutation.deleteById(
            table: table,
            id: id,
            returning: returning,
          ),
        ];

  final JsonMap? variables;
  final List<HasuraAction> actions;

  String get _parsedVariables {
    final variables = this.variables;
    return variables == null
        ? ''
        : '(${variables.keys.map((k) => '\$$k: jsonb').join(', ')})';
  }

  JsonMap get body {
    final type = actions.first is HasuraMutation ? 'mutation' : 'query';
    return {
      'variables': variables,
      'query': '''
        $type $_parsedVariables {
          ${actions.join('\n')}
        }
      ''',
    };
  }
}
