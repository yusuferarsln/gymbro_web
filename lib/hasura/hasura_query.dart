import 'package:gymbro_web/hasura/hasura_action.dart';
import 'package:gymbro_web/hasura/type_def.dart';

class HasuraQuery extends HasuraAction {
  HasuraQuery({
    required super.method,
    required super.parameters,
    required super.returning,
  });

  HasuraQuery.byId({
    required String table,
    required int id,
    required Set returning,
  }) : this(
          method: '${table}_by_pk',
          parameters: {'id': id},
          returning: returning,
        );

  HasuraQuery.list({
    required String table,
    JsonMap? where,
    required Set returning,
  }) : this(
          method: table,
          parameters: {'where': where ?? {}},
          returning: returning,
        );
}
