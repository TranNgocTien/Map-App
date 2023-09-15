// import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:map_app/stream_camera/utils/marker_list_data.dart';

import 'package:map_app/components/multiSelectDialog.dart';

// import 'package:map_app/components/multiSelectDialog.dart';
class SendMultipleCamera extends StatefulWidget {
  const SendMultipleCamera({super.key});

  @override
  State<SendMultipleCamera> createState() => _SendMultipleCameraState();
}

class _SendMultipleCameraState extends State<SendMultipleCamera> {
  List<MarkerList> _selectedItems = [];
  
           
              
  void _showMultiSelect(BuildContext context) async {
    final List<MarkerList> results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(items: markers);
        });
    if (results != null) {
      setState(() {
       
      
        _selectedItems = results;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height:30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.onTertiaryContainer),
            onPressed: () {
              Navigator.of(context).pop(markers);
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Send all Camera',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.onTertiaryContainer),
            onPressed: () {
              _showMultiSelect(context);
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Choose camera',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: ()  {
           
           

              Navigator.pop(context, _selectedItems);
            

            },
            child: Text(
              'Send',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    color: Colors.white,
                  ),
            ),
          ),

          const Divider(height: 30),

          Wrap(
            children: _selectedItems
                .map(
                  (e) => Chip(
                    label: Text(e.address),
                  ),
                )
                .toList(),
          )

          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20),
          //   child: Material(
          //     child: InkWell(
          //       onTap: () {

          //         // Navigator.of(context).push(
          //         //   MaterialPageRoute(
          //         //     builder: (context) => CameraListToSend(),
          //         //   ),
          //         // );
          //       },
          //       splashColor:
          //           Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          //       child: Ink(
          //         child: Center(
          //           child: Text(
          //             'Choose camera',
          //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //                   color: Colors.black,
          //                 ),
          //           ),
          //         ),
          //         color: Theme.of(context).colorScheme.onBackground,
          //         height: MediaQuery.of(context).size.height * 0.1,
          //         width: double.infinity,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}


// MultiSelectDialogField(
//                 items: _items,
//                 title: Text("Animals"),
//                 selectedColor: Colors.blue,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.all(Radius.circular(40)),
//                   border: Border.all(
//                     color: Colors.blue,
//                     width: 2,
//                   ),
//                 ),
//                 buttonIcon: Icon(
//                   Icons.pets,
//                   color: Colors.blue,
//                 ),
//                 buttonText: Text(
//                   "Favorite Animals",
//                   style: TextStyle(
//                     color: Colors.blue[800],
//                     fontSize: 16,
//                   ),
//                 ),
//                 onConfirm: (results) {
//                   //_selectedAnimals = results;
//                 },
//               ),