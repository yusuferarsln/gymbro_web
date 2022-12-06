import 'package:gymbro_web/hasura/hasura_action.dart';
import 'package:gymbro_web/hasura/type_def.dart';

class HasuraMutation extends HasuraAction {
  HasuraMutation({
    required super.method,
    required super.parameters,
    required super.returning,
  });

  HasuraMutation.insert({
    required String table,
    required JsonMap object,
    required Set returning,
  }) : super(
          method: 'insert_${table}_one',
          parameters: {'object': object},
          returning: returning,
        );

  HasuraMutation.updateById({
    required String table,
    required int id,
    required JsonMap parameters,
    required Set returning,
  }) : super(
          method: 'update_${table}_by_pk',
          parameters: {
            'pk_columns': {'id': id},
            ...parameters,
          },
          returning: returning,
        );

  HasuraMutation.update({
    required String table,
    required JsonMap parameters,
    required Set returning,
  }) : super(
          method: 'update_$table',
          parameters: parameters,
          returning: {MapEntry('returning', returning)},
        );

  HasuraMutation.deleteById({
    required String table,
    required int id,
    required Set returning,
  }) : super(
          method: 'delete_${table}_by_pk',
          parameters: {'id': id},
          returning: returning,
        );
}
