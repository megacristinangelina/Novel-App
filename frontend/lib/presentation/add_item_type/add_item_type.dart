import 'package:dropdown_search/dropdown_search.dart';
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
  final authorController = TextEditingController();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ⬅ latar hitam
      appBar: AppBar(
        title: const Text("Add Novel"),
        backgroundColor: const Color.fromARGB(255, 82, 56, 128),
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => AddItemCubit(),
        child: BlocConsumer<AddItemCubit, AddItemState>(
          listener: (context, state) {
            if (state is AddItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is AddItemError) {
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
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      hintText: "Enter author",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
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
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      menuProps: MenuProps(backgroundColor: Colors.black),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select genre",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    dropdownBuilder: (context, selectedItem) => Text(
                      selectedItem ?? "Select",
                      style: TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedGendre = value;
                      });
                    },
                  ),

                  SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 82, 56, 128),
                      ),
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

                        context.read<AddItemCubit>().submit(
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
