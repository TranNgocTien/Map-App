import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:map_app/pick_image/models/imageData.dart';

import 'dart:convert';

import 'package:map_app/pick_image/screens/image_detail.dart';

class ImageNotify extends StatefulWidget {
  const ImageNotify({super.key});

  @override
  State<ImageNotify> createState() => _ImageNotifyState();
}

class _ImageNotifyState extends State<ImageNotify> {
  List<ImageData> _imageData = [];
  List<ImageDetailLocation> _imageDetail = [];
  var _isLoading = true;

  String? _error;

  void _loadItem() async {
    final url = Uri.http('119.17.253.45', '/live/history.json');
    final response = await http.get(url);
    if (!mounted) return;
    if (response.statusCode >= 400) {
      if (mounted) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later';
        });
      }
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<ImageDetailLocation> imageDetailLocation = [];
    final List<ImageData> loadedItems = [];

    var name = '';

    for (var item in listData.entries) {
      name = item.key;
      for (var person in item.value.entries) {
        loadedItems.add(
          ImageData(
            idCam: person.value['idcam'],
            address: person.value['address'],
            imageUrl: person.value['imageUrl'],
            nameOfPersonImage: name,
          ),
        );
      }
    }

    for (var index = 0; index < loadedItems.length; index++) {
      List<Location> locations =
          await locationFromAddress(loadedItems[index].address);
      if (!mounted) return;
      imageDetailLocation.add(
        ImageDetailLocation(
          latitude: locations.last.latitude,
          longitude: locations.last.longitude,
          address: loadedItems[index].address,
        ),
      );
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _imageDetail = imageDetailLocation;
        _imageData = loadedItems;
      });
    }
  }

  @override
  void initState() {
    _loadItem();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No request yet.'),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_imageData.isNotEmpty) {
      content = ListView.builder(
        itemCount: _imageData.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(_imageData[index].imageUrl),
            ),
            title: Text(
              _imageData[index].nameOfPersonImage,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              _imageData[index].address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            trailing: Text(
              _imageData[index].idCam,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ImageDetailScreen(
                    imageDetailLocation: _imageDetail[index],
                    imageData: _imageData[index],
                  ),
                ),
              );
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 10,
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Search Results',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(172, 0, 0, 0),
        child: content,
      ),
    );
  }
}
