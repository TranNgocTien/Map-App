import 'package:flutter/material.dart';
import 'package:map_app/components/notify.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import './camera.dart';
import './list_tile.dart';

import 'package:map_app/stream_camera/name_list.dart';

class LiveStreamVideo extends StatefulWidget {
  const LiveStreamVideo({
    super.key,
  });
  //  final List<MarkerList> listMarker;
  @override
  State<LiveStreamVideo> createState() => _LiveStreamVideoState();
}

class _LiveStreamVideoState extends State<LiveStreamVideo> {
  void _openOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const Notifys(),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color.fromARGB(172, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Camera(),

              const SizedBox(
                height: 20,
              ),

              Text(
                'Search Queries',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,

                // child: ListView.builder(
                //   itemCount: listData.length,
                //   itemBuilder: (context, index) {
                //     return GestureDetector(
                //       onTap: () {
                //         print('${listData[index]['name']}');
                //       },
                //       child: ListTileWidget(
                //         img: listData[index]['img'] as String,
                //         name: listData[index]['name'] as String,
                //       ),
                //     );
                //   },
                // ),
                child: NameData(),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   width: MediaQuery.of(context).size.width * 0.35,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.white,
              //       style: BorderStyle.solid,
              //       width: 1.0,
              //     ),
              //   ),
              //   child: const Text(
              //     'Controller',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openOverlay();
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.notifications),
        ));
  }
}
// ListView.builder(itemBuilder:(BuildContext ctx, int index)(
//                   padding: const EdgeInsets.all(8),
//                   children: <Widget>[
//                     ...(listData)
//                         .map(
//                           (info) => ListTileWidget(
//                               img: info['img'] as String,
//                               name: info['name'] as String),
//                         )
//                         .toList(),
//                   ],
//                 )),