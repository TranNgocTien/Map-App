import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:map_app/stream_camera/utils/name_data.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:map_app/components/sendMqttMultipleCamera.dart';
class NameData extends StatefulWidget {
  const NameData({
    Key? key,
  }) : super(key: key);

  @override
  State<NameData> createState() => _NameDataState();
}

class _NameDataState extends State<NameData> {
  List<Name> _nameData = [];
  var _isLoading = true;
  String? _error;

  //mqtt
  final clientTopic1 = MqttServerClient('119.17.253.45', '1883');
  Future<int> mqtt() async {
    clientTopic1.logging(on: false);
    clientTopic1.keepAlivePeriod = 5;
    clientTopic1.connectTimeoutPeriod = 2000;
    clientTopic1.autoReconnect = true;
    clientTopic1.onAutoReconnect = onAutoReconnectTopic1;
    clientTopic1.onAutoReconnected = onAutoReconnectedTopic1;
    clientTopic1.onDisconnected = onDisconnectedTopic1;
    clientTopic1.onConnected = onConnected;
    clientTopic1.onSubscribed = onSubscribed;
    clientTopic1.pongCallback = pongTopic1;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('topic1/camera')
        // .withProtocolName('protocolName')

        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    print('Client1 connecting....');
    clientTopic1.connectionMessage = connMess;

    try {
      await clientTopic1.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::clientTopic1 exception - $e');
      clientTopic1.disconnect();
      exit(-1);
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket1 exception - $e');
      clientTopic1.disconnect();
      exit(-1);
    }

    if (clientTopic1.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto clientTopic1 connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto clientTopic1 connection failed - disconnecting, status is ${clientTopic1.connectionStatus}');
      clientTopic1.disconnect();
      exit(-1);
    }

    print('Sleeping....');

    await MqttUtilities.asyncSleep(80);

    print('Unsubscribing');
    clientTopic1.unsubscribe('test/t1');

    await MqttUtilities.asyncSleep(2);
    print('Disconnecting');

    clientTopic1.disconnect();

    return 0;
  }

  void onAutoReconnectTopic1() {
    print(
        'EXAMPLE::onAutoReconnect client 1 callback - Client 1 auto reconnection sequence will start');
  }

  void onAutoReconnectedTopic1() {
    print(
        'EXAMPLE::onAutoReconnected client 1 callback - Client 1 auto reconnection sequence has completed');
  }

  void onDisconnectedTopic1() {
    print('EXAMPLE::OnDisconnected client1 callback - Client disconnection');
    if (clientTopic1.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  void onConnected() {
    print('Connected');
  }

  void pongTopic1() {
    print('EXAMPLE::Ping response client1 callback invoked');
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void publishMess(String str) {
    if (clientTopic1.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      clientTopic1.connect();
    }

    const pubTopic = 'test/t1';

    final builder = MqttClientPayloadBuilder();
    builder.addString(str);
    clientTopic1.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
    print(builder);
  }
  void publishMessList(List<String> list) {
    print('Vao ham********************************************');
    if (clientTopic1.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      clientTopic1.connect();
    }

    const pubTopic = 'test/t1';

    final builder = MqttClientPayloadBuilder();
    list.map(((e) {  
    builder.addString(e);
    clientTopic1.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
    print('$builder ***********************************');
    }));
  }

//end mqtt
  void _loadItem() async {
    final url = Uri.http('119.17.253.45', '/live/name.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later!';
      });
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Name> loadedItems = [];

    for (var item in listData.entries) {
      loadedItems.add(
        Name(
          name: item.value['name'],
          imageUrl: item.value['imageUrl'].toString(),
        ),
      );
    }

    print(loadedItems);

    setState(() {
      _isLoading = false;
      _nameData = loadedItems;
    });
  }

  void sortItems(Map<String, dynamic> loadedItems) {
    var sortedByKeyMap = Map.fromEntries(loadedItems.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

List<MarkerList> _itemsSelectedAdress=[];
List<String> _itemSelectedAdressString=[];

void addAdressString(List<MarkerList> _itemSelected){
  for(var item  in _itemSelected){
    _itemSelectedAdressString.add(item.address);
  }
}

void _openOverlay(BuildContext context) async {
  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>const  SendMultipleCamera()
    ).then((values) {
      
      _itemsSelectedAdress=values;
      addAdressString(_itemsSelectedAdress);
     
    publishMessList(_itemSelectedAdressString);
    });
    
  }

  @override
  void initState() {
    _loadItem();
    mqtt();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    clientTopic1.disconnect();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No request yet.'),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_nameData.isNotEmpty) {
      content = ListView.builder(
          itemCount: _nameData.length,
          itemBuilder: ((context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: (){
                     _openOverlay(context);
                      publishMess(_nameData[index].name);

                    

                   

                    // setState(() {
                    //   if (widget.selectedName != null) {
                    //     widget.publishMess(_nameData[index].name);
                    //   } else {
                    //     widget.publishMess('Tran Tan Tai');
                    //   }

                    //   widget.redIcon = false;
                    // });
                  },
                  title: Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60 / 2),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_nameData[index].imageUrl),
                            )),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _nameData[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }));
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return SizedBox(
      child: content,
    );
  }
}
