class HasuraCustom {
  apply({required List moves, required List area}) {
    return {
      'query': '''
  mutation MyMutation {
  insert_gym_moves(objects: {move_area: "$area", move_name: "$moves"}) {
    affected_rows
  }



      ''',
    };
  }
}
