import 'package:dropdown_search/dropdown_search.dart';
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

  final List<String> genres = [
    "Romance",
    "Drama",
    "Action",
    "Comedy",
    "Fantasy",
    "Horror",
    "Mystery",
    "Thriller",
    "Adventure",
    "Sci-Fi",
    "Historical",
    "Slice of Life",
    "Psychological",
    "Supernatural",
    "Detective",
    "Sports",
    "Crime",
    "Tragedy",
    "Military",
    "Paranormal",
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    authorController = TextEditingController(text: widget.item.author);
    selectedGendre = widget.item.gendre;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Novel Item")),
      body: BlocProvider(
        create: (context) => EditItemCubit(),
        child: BlocConsumer<EditItemCubit, EditItemState>(
          listener: (context, state) {
            if (state is EditItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context, true);
              });
            } else if (state is EditItemError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // <-- ditambahkan
                    ),
                  ),

                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: "Enter title"),
                  ),
                  SizedBox(height: 16),

                  Text(
                    "Author",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: authorController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(hintText: "Enter author"),
                  ),
                  SizedBox(height: 16),

                  Text(
                    "Gendre",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  DropdownSearch<String>(
                    items: genres,
                    selectedItem: selectedGendre,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                      menuProps: MenuProps(backgroundColor: Colors.black),
                      itemBuilder: (context, item, isSelected) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.purpleAccent
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select genre",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    dropdownBuilder: (context, selectedItem) {
                      return Text(
                        selectedItem ?? "Select",
                        style: TextStyle(color: Colors.white),
                      );
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedGendre = value;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        final author = authorController.text.trim();
                        if (title.isEmpty ||
                            author.isEmpty ||
                            selectedGendre == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Semua field harus diisi"),
                              backgroundColor: Colors.orange,
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
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
