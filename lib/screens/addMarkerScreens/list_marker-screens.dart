import 'package:flutter/material.dart';

import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:map_app/screens/addMarkerScreens/addMarker.dart';
import 'package:map_app/stream_camera/utils/marker_list_data.dart';

class ListMarkerScreen extends StatefulWidget {
  const ListMarkerScreen({super.key});

  @override
  State<ListMarkerScreen> createState() => _ListMarkerScreenState();
}

class _ListMarkerScreenState extends State<ListMarkerScreen> {
  void _addItem() async {
    final newItem = await Navigator.of(context).push<MarkerList>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    print(newItem);
    if (newItem == null) {
      return;
    }

    setState(() {
      markers.add(newItem);
    });
  }

  void onRemoveGroceryItems(MarkerList item) {
    final itemIndex = markers.indexOf(item);
    setState(() {
      markers.remove(item);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Item delete.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            markers.insert(itemIndex, item);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Location Management'), actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ]),
        body: markers.isEmpty
            ? const Center(
                child: Text(
                  'You got no items yet!',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: markers.length,
                itemBuilder: (ctx, index) => Dismissible(
                  key: ValueKey(markers[index].id),
                  background: Container(
                    color:
                        Theme.of(context).colorScheme.error.withOpacity(0.75),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                  ),
                  onDismissed: (direction) {
                    onRemoveGroceryItems(markers[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Text(
                        markers[index].title,
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            markers[index].address.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            markers[index].linkCamera.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
