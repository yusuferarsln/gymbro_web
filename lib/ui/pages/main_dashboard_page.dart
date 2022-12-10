import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/constants/appcolors.dart';
import 'package:gymbro_web/extensions/context_extension.dart';
import 'package:gymbro_web/model/m_user_model.dart';
import 'package:gymbro_web/model/workout_model.dart';
import 'package:gymbro_web/provider/move_provider.dart';
import 'package:gymbro_web/services/api_service.dart';
import 'package:gymbro_web/ui/pages/workout_list_page.dart';
import 'package:gymbro_web/ui/pages/workout_page.dart';

import '../../provider/user_provider.dart';
import '../../states/fetch_state.dart';

class MainDashboardPage extends ConsumerStatefulWidget {
  const MainDashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainDashboardPageState();
}

class _MainDashboardPageState extends ConsumerState<MainDashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fun1();
    fun2(userID);
    ref.read(membersProvider.notifier).fetch(gymID);
  }

  int userID = 0;
  int gymID = 0;

  void fun1() async {
    final bla = await api.getUserID();
    fun2(bla);
    setState(() {
      userID = bla;
    });
  }

  void fun2(int userID) async {
    final bla = await api.getGymID(userID);
    setState(() {
      gymID = bla;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final memberStateX = ref.watch(membersProvider);
    print(gymID);
    print(userID);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Üyeler',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.appBar,
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  print(gymID);
                  ref.read(membersProvider.notifier).fetch(gymID);
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: AppColors.black,
              )),
        ],
      ),
      body: Column(
        children: [
          Builder(builder: (context) {
            if (memberStateX is Fetched<List<MUsermodel>>) {
              final value = memberStateX.value;

              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('ID: ${value[index].user.id}'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text('İsim: ${value[index].user.user_email}'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text('Email: ${value[index].user.user_name}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _UserInteractions(context, gymID);
                                      setState(() {
                                        ref
                                            .read(getProgramProvider.notifier)
                                            .fetch(gymID, userID);
                                      });
                                    },
                                    icon: const Icon(Icons.display_settings),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: value.length,
              );
            } else if (memberStateX is FetchError) {
              print("er");
            } else if (memberStateX is Fetching) {
              print("burdayım");
            }
            return const Text('bura');
          }),
        ],
      ),
    );
  }

  Future<void> _UserInteractions(context, int gymID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return _UserInteractionDialog(gymID);
      },
    );
  }
}

class _UserInteractionDialog extends StatefulWidget {
  _UserInteractionDialog(this.gymID);
  int gymID;

  @override
  State<_UserInteractionDialog> createState() => _UserInteractionDialogState();
}

class _UserInteractionDialogState extends State<_UserInteractionDialog> {
  @override
  Widget build(BuildContext context) {
    return UserInteractionWidget(
      gymID: widget.gymID,
    );
  }
}

class UserInteractionWidget extends ConsumerStatefulWidget {
  UserInteractionWidget({super.key, required this.gymID});
  int gymID;

  @override
  ConsumerState<UserInteractionWidget> createState() =>
      _UserInteractionWidgetState();
}

class _UserInteractionWidgetState extends ConsumerState<UserInteractionWidget> {
  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(getProgramProvider);
    return AlertDialog(
      title: const Text('Programları Görüntüle / Ekle'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 1000,
          child: ListBody(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      context.go(WorkoutPage(
                        gymID: widget.gymID,
                      ));
                    },
                    icon: const Icon(Icons.add)),
              ),
              Builder(builder: (context) {
                if (workouts is Fetched<List<WorkoutModel>>) {
                  final value = workouts.value;
                  print(value);

                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Program ID : ${index + 1}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          context.go(WorkoutListPage(
                                            workouts: value,
                                            indexA: index,
                                          ));
                                          ref
                                              .read(getImagesProvider.notifier)
                                              .fetch(value[index]
                                                  .workouts[index]
                                                  .id);
                                        },
                                        icon:
                                            const Icon(Icons.display_settings),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: value.length,
                  );
                } else if (workouts is FetchError) {
                  print("er");
                } else if (workouts is Fetching) {
                  print("burdayım");
                }
                return const Text('bura');
              }),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Çık'))
      ],
    );
  }
}
