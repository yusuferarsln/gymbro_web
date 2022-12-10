import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/registered_gym_model.dart';
import 'package:gymbro_web/provider/gym_provider.dart';
import 'package:gymbro_web/states/fetch_state.dart';
import 'package:gymbro_web/ui/widgets/dialogs/add_admin_dialog.dart';

class GymBroDashboard extends ConsumerStatefulWidget {
  const GymBroDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GymBroDashboardState();
}

class _GymBroDashboardState extends ConsumerState<GymBroDashboard> {
  @override
  Widget build(BuildContext context) {
    final gymList = ref.watch(gymProvider);
    ref.listen(gymAddProvider, ((previous, next) {
      print('state şu');
      print(next.runtimeType);
      if (next is Fetched<bool>) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Gym eklendi')));
      } else if (next is FetchError) {
        print('hata');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Eklenirken hata oluştu')));
      }
    }));

    ref.listen(gymDeleteProvider, ((previous, next) {
      print('state şu');
      print(next.runtimeType);
      if (next is Fetched<bool>) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Gym Silindi')));
      } else if (next is FetchError) {
        print('hata');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Silinirken hata oluştu')));
      }
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('GYMBRO ADMIN DASHBOARD'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      _showMyDialog(context);
                      ref.read(gymProvider.notifier).fetch();
                      setState(() {});
                    },
                    icon: const Icon(Icons.add)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        ref.read(gymProvider.notifier).fetch();
                      });
                    },
                    icon: const Icon(Icons.refresh)),
              ),
            ],
          ),
          Builder(builder: (context) {
            if (gymList is Fetched<List<RecordedGymsModel>>) {
              final value = gymList.value;
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Text(value[index].id.toString()),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.network(
                            value[index].gymImage,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(value[index].gymName),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(value[index].gymMemberCount.toString()),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(value[index].gymAddress.toString()),
                              const SizedBox(
                                height: 50,
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _deleteDiaalog(
                                            context, value[index].id);

                                        ref.read(gymProvider.notifier).fetch();
                                        setState(() {});
                                      },
                                      child: const Text('Delete Gym')),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _addAdminDialog(
                                            context, value[index].id);
                                      },
                                      child: const Text('Add Admin')),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: value.length,
                ),
              );
            } else if (gymList is Fetching) {
              return const CircularProgressIndicator();
            } else {
              return const Text('error');
            }
          })
        ],
      ),
    );
  }

  Future<void> _showMyDialog(context) async {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController addresscontroller = TextEditingController();
    TextEditingController imagecontroller = TextEditingController();
    TextEditingController membercontroller = TextEditingController();
    TextEditingController toolcontroller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add New Gym'),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 700,
              child: ListBody(
                children: <Widget>[
                  const Text('Gym Name'),
                  Container(
                    width: 500,
                    height: 40,
                    color: Colors.white,
                    child: TextField(
                      controller: namecontroller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), counterText: ''),
                    ),
                  ),
                  const Text('Gym Address'),
                  Container(
                    width: 500,
                    height: 40,
                    color: Colors.white,
                    child: TextField(
                      controller: addresscontroller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), counterText: ''),
                    ),
                  ),
                  const Text('Gym Image'),
                  Container(
                    width: 500,
                    height: 40,
                    color: Colors.white,
                    child: TextField(
                      controller: imagecontroller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), counterText: ''),
                    ),
                  ),
                  const Text('Gym Member Count'),
                  Container(
                    width: 100,
                    height: 40,
                    color: Colors.white,
                    child: TextField(
                      controller: membercontroller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), counterText: ''),
                    ),
                  ),
                  const Text('Gym Tool Count'),
                  Container(
                    width: 100,
                    height: 40,
                    color: Colors.white,
                    child: TextField(
                      controller: toolcontroller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), counterText: ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ekle'),
              onPressed: () {
                ref.read(gymAddProvider.notifier).fetch(
                    addresscontroller.text,
                    imagecontroller.text,
                    int.parse(membercontroller.text),
                    namecontroller.text,
                    int.parse(toolcontroller.text));
                ref.read(gymProvider.notifier).fetch();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDiaalog(context, gymID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kaydı silmek istediğine emin misin?'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 700,
              child: ListBody(
                children: const <Widget>[],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  ref.read(gymDeleteProvider.notifier).fetch(gymID);
                  ref.read(gymProvider.notifier).fetch();
                  Navigator.of(context).pop();
                },
                child: const Text('Evet')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Hayır'))
          ],
        );
      },
    );
  }

  Future<void> _addAdminDialog(context, gymID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddAdminDialog(
          gymID: gymID,
        );
      },
    );
  }
}
