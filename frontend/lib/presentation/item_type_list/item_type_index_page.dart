import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentation/add_item_type/add_item_type.dart';
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
      create: (context) => ItemTypeIndexCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ), // AppBar
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(itemType.title),
                            Text(itemType.gendre ?? '-'),
                          ],
                        ),
                      ), // Padding
                    ); // Card
                  },
                ), // ListView.builder
              ); // Padding
            }
            return Container();
          },
        ), // BlocBuilder
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemTypePage()),
          ),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // FloatingActionButton
      ), // Scaffold
    ); // BlocProvider
  }
}