import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/add_item_type/cubit/add_item_cubit.dart';

class AddItemTypePage extends StatefulWidget {
  const AddItemTypePage({Key? key}) : super(key: key);

  @override
  State<AddItemTypePage> createState() => _AddItemTypePageState();
}

class _AddItemTypePageState extends State<AddItemTypePage> {
final titleController = TextEditingController();
  String? selectedGendre;
  final authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add item type")),
      body: BlocProvider(
        create: (context) => AddItemCubit(),
        child: BlocConsumer<AddItemCubit, AddItemState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(label: Text("Title")),
                ), // TextField
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(label: Text("Author")),
                ), // TextField
                DropdownButtonFormField(
                  items:
                      [
                        {"value": "Active", "label": "Active"},
                        {"value": "Non-Active", "label": "Non-Active"},
                      ].map((e) {
                        return DropdownMenuItem(
                          child: Text(e['label']!),
                          value: e['value'],
                        );
                      }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      selectedGendre = val!;
                    });
                  },
                ), // DropdownButtonFormField
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    final author = authorController.text;
                    debugPrint(title);
                    debugPrint(author);

                    if (title.isEmpty ||
                        author.isEmpty ||
                        selectedGendre == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Semua field harus diisi"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    context.read<AddItemCubit>().submit(
                      title,
                      author,
                      selectedGendre!,
                    );
                  },
                  child: Text("Simpan"),
                ), // ElevatedButton
              ],
            );
          },
          listener: (context, state) {
            if (state is AddItemSuccess) {
              final snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ); // SnackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context, true);
            }
            if (state is AddItemError) {
              final snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ); // SnackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ), // BlocConsumer
      ), // BlocProvider
    ); // Scaffold
  }
}

