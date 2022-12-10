import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/constants/appcolors.dart';
import 'package:gymbro_web/model/request_model.dart';
import 'package:gymbro_web/services/api_service.dart';

import '../../model/basic_user_model.dart';
import '../../provider/user_provider.dart';
import '../../states/fetch_state.dart';

class RequestPage extends ConsumerStatefulWidget {
  const RequestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<RequestPage> {
  @override
  int userID = 0;
  int gymID = 0;
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final memberState = ref.watch(memberRequestProvider);

    ref.listen(userProvider, (previous, next) {
      if (next is Fetched<List<BasicUserModel>>) {
        var nextV = next.value;
        userID = nextV[0].id;
        print(userID);
        ref.read(gymIDProvider.notifier).fetch(userID);
      } else if (next is Fetching) {
        print('Fetching');
      } else {
        print('error');
      }
    });

    ref.listen(
      gymIDProvider,
      (previous, next) {
        if (next is Fetched<int>) {
          var value = next.value;
          gymID = value;
          print(gymID);
          ref.read(memberRequestProvider.notifier).fetch(gymID);
        } else if (next is Fetching) {
          print('Fetching');
        } else {
          print('error');
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Üye İstekleri',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.appBar,
        actions: [
          IconButton(
              onPressed: () async {
                print(gymID);
                await ref.read(memberRequestProvider.notifier).fetch(gymID);
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
            if (memberState is Fetched<List<RequestModel>>) {
              final value = memberState.value;

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
                                  Text('İsim: ${value[index].user.user_name}'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      'Email: ${value[index].user.user_email}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      var bla = await api.handleRequest(
                                          value[index].user.id, 1);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('İstek Onaylandı')));
                                      setState(() {
                                        ref
                                            .read(
                                                memberRequestProvider.notifier)
                                            .fetch(gymID);
                                      });
                                    },
                                    icon: const Icon(Icons.done),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        var bla = await api.handleRequest(
                                            value[index].user.id, 2);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('İstek Reddedildi')));
                                        setState(() {
                                          ref
                                              .read(memberRequestProvider
                                                  .notifier)
                                              .fetch(gymID);
                                        });
                                      },
                                      icon: const Icon(Icons.remove_circle))
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
            } else if (memberState is FetchError) {
              print("er");
            } else if (memberState is Fetching) {
              return const CircularProgressIndicator();
            }
            return const CircularProgressIndicator();
          }),
          ElevatedButton(onPressed: () {}, child: const Text('s'))
        ],
      ),
    );
  }
}
