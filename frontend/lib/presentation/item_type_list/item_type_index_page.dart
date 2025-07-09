import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentation/add_item_type/add_item_type.dart';
import 'package:flutter_pos/presentation/edit_item_type/edit_item_page.dart';
import 'package:flutter_pos/presentation/item_type_list/cubit/item_type_index_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemTypeIndexCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.title)),
            body: BlocBuilder<ItemTypeIndexCubit, ItemTypeIndexState>(
              builder: (context, state) {
                if (state is ItemTypeIndexLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: state.itemTypes.length,
                      itemBuilder: (context, index) {
                        ItemType itemType = state.itemTypes[index];
                        return Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.purple, width: 1),
                          ),
                          child: ListTile(
                            title: Text(
                              itemType.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemType.gendre ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Text(
                                  itemType.author,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditItemPage(item: itemType),
                                      ),
                                    );
                                    context.read<ItemTypeIndexCubit>().index();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    bool confirmed = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          62,
                                          62,
                                          62,
                                        ),
                                        title: Text(
                                          'Confirmation',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this novel?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  132,
                                                  108,
                                                  172,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  255,
                                                  132,
                                                  108,
                                                  172,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed) {
                                      await context
                                          .read<ItemTypeIndexCubit>()
                                          .delete(itemType.id);
                                      context
                                          .read<ItemTypeIndexCubit>()
                                          .index();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is ItemTypeIndexError) {
                  return Center(child: Text(state.message));
                }

                if (state is ItemTypeIndexLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const SizedBox();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddItemTypePage()),
                );
                if (result != null) {
                  context.read<ItemTypeIndexCubit>().index();
                }
              },
              child: Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 82, 56, 128),
              foregroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
