import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentation/edit_item_type/cubit/edit_item_cubit.dart';

class EditItemPage extends StatefulWidget {
   final ItemType item;
const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  String? selectedGendre;

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Edit Item")),
      body: BlocProvider(
        create: (context) => EditItemCubit(),
        child: BlocConsumer<EditItemCubit, EditItemState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController = TextEditingController(
                      text: widget.item.title,
                    ),
                    decoration: InputDecoration(labelText: "title"),
                  ),
                  TextField(
                    controller: authorController = TextEditingController(
                      text: widget.item.author,
                    ),
                    decoration: InputDecoration(labelText: "author"),
                  ),
                  DropdownButtonFormField(
                    value: selectedGendre,
                    items: [
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(
                        value: "Non-Active",
                        child: Text("Non-Active"),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedGendre = val),
                  ),
                  SizedBox(height: 24), // ⬅️ Ini buat ngasih jarak ke bawah
                  ElevatedButton(
                    onPressed: () {
                      final title = titleController.text;
                      final author = authorController.text;
                      if (title.isEmpty ||
                          author.isEmpty ||
                          selectedGendre == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Semua field harus diisi"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      context.read<EditItemCubit>().update(
                        widget.item.id,
                        title,
                        author,
                        selectedGendre!,
                      );
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is EditItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(
                  context,
                ); // ⬅️ Langsung kembali ke halaman sebelumnya (home)
              });
            }
          },
        ),
      ),
    );
  }
}
