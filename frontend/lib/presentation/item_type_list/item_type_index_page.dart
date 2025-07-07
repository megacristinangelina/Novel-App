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
                          child: ListTile(
                            title: Text(itemType.title),
                            subtitle: Text(itemType.gendre!),
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
                                        title: Text('Konfirmasi'),
                                        content: Text(
                                          'Yakin ingin menghapus item ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text('Hapus'),
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

                return const SizedBox(); // fallback jika state tidak dikenali
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddItemTypePage(), // ✅ ganti ke halaman tambah
                  ),
                );
                if (result != null) {
                  context
                      .read<ItemTypeIndexCubit>()
                      .index(); // refresh setelah tambah
                }
              },
              child: Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 207, 148, 217),
            ),
          );
        },
      ),
    );
  }
}
