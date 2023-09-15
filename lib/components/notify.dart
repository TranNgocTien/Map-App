import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:map_app/components/notifyData.dart';
import 'dart:convert';

class Notifys extends StatefulWidget {
  const Notifys({Key? key}) : super(key: key);

  @override
  State<Notifys> createState() => _NotifysState();
}

class _NotifysState extends State<Notifys> {
  List<NotifyData> _notifyData = [];
  var _isLoading = true;
  String? _error;
  // Future<List<NotifyData>> fetchNotifyData() async {
  //   // var url = 'http://119.17.253.45/live/output.json';
  //   // var response = await http.get(url as Uri);

  //   // var notifys = <NotifyData>[];

  //   // if (response.statusCode == 200) {
  //   //   var notifysJson = json.decode(response.body);
  //   //   for (var notifyJson in notifysJson) {
  //   //     notifys.add(NotifyData.fromJson(notifyJson));
  //   //   }
  //   // }

  //   // print(notifys);
  //   // return notifys;

  //   String data = await DefaultAssetBundle.of(context)
  //       .loadString('119.17.253.45/live/noti.json');

  //   List mapData = jsonDecode(data);
  //   print(mapData);
  //   List<NotifyData> notifysData =
  //       mapData.map((notifyData) => NotifyData.fromJson(notifyData)).toList();

  //   return notifysData;
  // }

  void _loadItem() async {
    final url = Uri.http('119.17.253.45', '/live/noti.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data.Please try again later';
      });
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<NotifyData> loadedItems = [];
    for (var item in listData.entries) {
      loadedItems.add(
        NotifyData(
          id: item.key,
          name: item.value['name'],
          time: item.value['time'],
          type: item.value['type'],
        ),
      );
    }
    print(loadedItems);

    setState(() {
      _isLoading = false;

      _notifyData = loadedItems;
    });
  }

  void sortItems(Map<String, dynamic> loadedItems) {
    var sortedByKeyMap = Map.fromEntries(loadedItems.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

  @override
  void initState() {
    // fetchNotifyData().then((value) {
    //   setState(() {
    //     _notifyData.addAll(value);
    //   });
    // });
    _loadItem();
    // fetchNotifyData();
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

    if (_notifyData.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _notifyData[index].type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        _notifyData[index].time,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        _notifyData[index].name,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        itemCount: _notifyData.length,
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: content,
    );
  }
}
