import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/provider/move_provider.dart';
import 'package:gymbro_web/services/api_service.dart';

import '../../model/move_model.dart';
import '../../states/fetch_state.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  WorkoutPage({super.key, required this.gymID});
  int gymID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkoutPageState();
}

List<bool> selected = [false, false, false, false];
Map<String, dynamic> valueFromWidget = {};

List<Map> valuesFor = [];

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  @override
  void initState() {
    super.initState();
    funX();
  }

  int userID = 0;

  void funX() async {
    final bla = await api.getUserID();
    setState(() {
      userID = bla;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(moveProvider('CHEST'));
    final workoutStateShoulder = ref.watch(moveProvider('SHOULDER'));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.gymID);
          api.addWorkout(valuesFor, userID, widget.gymID);
        },
        child: const Icon(Icons.arrow_right),
      ),
      appBar: AppBar(title: const Text('Workout')),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            child: Column(
              children: [
                IgnorePointer(
                  ignoring: selected[0],
                  child: ExpansionTile(
                    key: GlobalKey(),
                    title: const Text('Chest'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(builder: (context) {
                          if (workoutState is Fetched<List<MoveModel>>) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final workoutMove = workoutState.value[index];
                                return Column(
                                  children: [
                                    MoveTileWidget(workoutMove: workoutMove),
                                  ],
                                );
                              },
                              itemCount: workoutState.value.length,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  color: selected[0] == false ? Colors.white : Colors.black,
                  child: IconButton(
                      color: selected[0] == false ? Colors.green : Colors.white,
                      onPressed: () {
                        setState(() {
                          selected[0] = !selected[0];
                          print(valuesFor);
                        });
                      },
                      icon: const Icon(Icons.done)),
                ),
                // CHEST //
                IgnorePointer(
                  ignoring: selected[1],
                  child: ExpansionTile(
                    key: GlobalKey(),
                    title: const Text('SHOULDER'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(builder: (context) {
                          if (workoutStateShoulder
                              is Fetched<List<MoveModel>>) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final workoutMove =
                                    workoutStateShoulder.value[index];
                                return Column(
                                  children: [
                                    MoveTileWidget(workoutMove: workoutMove),
                                  ],
                                );
                              },
                              itemCount: workoutStateShoulder.value.length,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  color: selected[1] == false ? Colors.white : Colors.black,
                  child: IconButton(
                      color: selected[1] == false ? Colors.green : Colors.white,
                      onPressed: () {
                        print(valuesFor);
                        setState(() {
                          selected[1] = !selected[1];
                          print(valuesFor);
                        });
                      },
                      icon: const Icon(Icons.done)),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class MoveTileWidget extends StatefulWidget {
  const MoveTileWidget({
    super.key,
    required this.workoutMove,
  });

  final MoveModel workoutMove;

  @override
  State<MoveTileWidget> createState() => _MoveTileWidgetState();
}

class _MoveTileWidgetState extends State<MoveTileWidget> {
  TextEditingController setController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

  IconData selectedIcon = Icons.arrow_right;
  bool selected = false;
  MaterialColor selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selectedColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.workoutMove.moveName.length >= 10
                ? Text(widget.workoutMove.moveName.split("-").first)
                : Text(widget.workoutMove.moveName),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 40,
                  color: Colors.white,
                  child: TextField(
                    maxLength: 2,
                    controller: setController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), counterText: ''),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('x'),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 60,
                  height: 40,
                  color: Colors.white,
                  child: TextField(
                    maxLength: 2,
                    controller: repeatController,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (selected == true) {
                        selected = false;
                        selectedIcon = Icons.arrow_right;
                        selectedColor = Colors.blue;
                        removefromList(
                            int.parse(setController.text),
                            int.parse(repeatController.text),
                            widget.workoutMove.moveName,
                            widget.workoutMove.moveArea,
                            widget.workoutMove.id);
                      } else {
                        selected = true;
                        selectedIcon = Icons.arrow_back;
                        selectedColor = Colors.green;
                        addtoList(
                            int.parse(setController.text),
                            int.parse(repeatController.text),
                            widget.workoutMove.moveName,
                            widget.workoutMove.moveArea,
                            widget.workoutMove.id);
                      }
                    });
                  },
                  icon: Icon(selectedIcon),
                  iconSize: 35,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void addtoList(int set, int repeat, String name, String area, int id) async {
  Map<String, dynamic> newMap = {
    'name': name,
    'setc': set,
    'repeat': repeat,
    'area': area,
    'id': id
  };

  valuesFor.add(newMap);
}

void removefromList(int set, int repeat, String name, String area, int id) {
  valuesFor.removeWhere((element) => element['name'] == name);
}
