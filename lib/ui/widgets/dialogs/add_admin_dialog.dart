import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/s_user_model.dart';
import 'package:gymbro_web/provider/gym_provider.dart';

import '../../../services/api_service.dart';
import '../../../states/fetch_state.dart';

class AddAdminDialog extends ConsumerStatefulWidget {
  AddAdminDialog({super.key, required this.gymID});
  int gymID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends ConsumerState<AddAdminDialog> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(setAdminProvider, ((previous, next) {
      if (next is Fetched<bool>) {
        var result = next.value;
        result == true
            ? ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Admin Yapıldı')))
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Eklenirken hata oluştu')));
      } else if (next is FetchError) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Eklenirken hata oluştu')));
      } else {
        print('waiting');
      }
    }));

    return AlertDialog(
      title: const Text('Add admin'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 700,
          child: ListBody(
            children: <Widget>[
              const Text('Search User'),
              Container(
                width: 100,
                height: 40,
                color: Colors.white,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), counterText: ''),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .read(getUsersProvider.notifier)
                        .fetch(emailController.text);
                  },
                  child: const Text('Ara')),
              Builder(builder: (context) {
                var users = ref.watch(getUsersProvider);
                if (users is Fetched<List<SUserModel>>) {
                  final value = users.value;
                  print('ss');
                  print(value);

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${value[index].id}'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(value[index].email),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(setAdminProvider.notifier)
                                    .setAdmin(value[index].id);
                                api.registerAdmin(
                                    value[index].id, widget.gymID);
                                Navigator.pop(context);
                              },
                              child: const Text('Admin Yap'),
                            ));
                      },
                      itemCount: value.length,
                    ),
                  );
                } else if (users is Fetching) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text('error');
                }
              })
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
