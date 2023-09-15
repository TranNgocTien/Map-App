import 'package:flutter/material.dart';
import 'package:map_app/components/autocomplete_prediction.dart';
import 'package:map_app/components/location_list_tile.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_app/stream_camera/utils/marker_list_data.dart';
import 'package:map_app/features/location_service.dart';
import 'package:map_app/components/network_utility.dart';
import 'package:map_app/components/place_auto_complete_response.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  List<AutocompletePrediction> placePredictions = [];

  void placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": LocationService().key,
    });

    String? response = await NetworkUtility.fetchUrl(uri);
    print(response);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      print(result);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  String stAddress = '';

  var _enteredAddress = '';
  var _enteredName = '';
  var _enteredLinkCamera = '';
  var lat;
  var lng;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<Location> locations = await locationFromAddress(_enteredAddress);

      setState(() {
        stAddress = locations.last.longitude.toString() +
            " " +
            locations.last.latitude.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(stAddress),
          duration: const Duration(seconds: 3),
        ),
      );
      markers.add(
        MarkerList(
          title: _enteredName,
          longitude: locations.last.longitude,
          latitude: locations.last.latitude,
          address: _enteredAddress,
          linkCamera: _enteredLinkCamera,
        ),
      );
      Navigator.of(context).pop(
        MarkerList(
          title: _enteredName,
          latitude: locations.last.latitude,
          longitude: locations.last.longitude,
          address: _enteredAddress,
          linkCamera: _enteredLinkCamera,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                maxLength: 60,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 60) {
                    return 'Must be between 1 and 60 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                maxLength: 60,
                decoration: const InputDecoration(
                  label: Text('Camera link Url'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 60) {
                    return 'Must be between 1 and 60 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredLinkCamera = value!;
                },
              ),
              TextFormField(
                onChanged: (value) {
                  placeAutoComplete(value);
                },
                style: const TextStyle(color: Colors.white, fontSize: 20),
                maxLength: 60,
                decoration: const InputDecoration(
                  label: Text('Address'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 60) {
                    return 'Must be between 1 and 60 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredAddress = value!;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: placePredictions.length,
                  itemBuilder: (context, index) => LocationListTile(
                    location: placePredictions[index].description!,
                    press: () {},
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('AddItem'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
