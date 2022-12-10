import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/image_model.dart';
import 'package:gymbro_web/model/workout_model.dart';
import 'package:gymbro_web/provider/move_provider.dart';

import '../../states/fetch_state.dart';

class WorkoutListPage extends ConsumerStatefulWidget {
  WorkoutListPage({super.key, required this.workouts, required this.indexA});
  List<WorkoutModel> workouts;
  int indexA;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkoutListPageState();
}

class _WorkoutListPageState extends ConsumerState<WorkoutListPage> {
  @override
  Widget build(BuildContext context) {
    final moveIMG = ref.watch(getImagesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.indexA.toString())),
      body: SafeArea(
          child: Column(
        children: [
          Builder(builder: (context) {
            if (moveIMG is Fetched<List<ImageModel>>) {
              final value = moveIMG.value;
              print(value);
              print(widget.workouts.length);
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return Row(
                    children: [
                      Text(widget.workouts[index].workouts[0].name),
                      Image.network(
                        value[index].move_img.toString(),
                        width: 10,
                        height: 10,
                      )
                    ],
                  );
                }),
                itemCount: widget.workouts.length - 1,
              );
            } else if (moveIMG is FetchError) {
              print("er");
            } else if (moveIMG is Fetching) {
              print("burdayım");
            }
            return const Text('bura');
          }),
        ],
      )),
    );
  }
}
