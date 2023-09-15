import 'package:flutter/material.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiSelectDialog extends StatefulWidget {
  const MultiSelectDialog({
    super.key,
    required this.items,
  });

  final List<MarkerList> items;
  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  final List<MarkerList> _selectedItems = [];

  void _itemChange(MarkerList itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Select Camera'),
        content: SingleChildScrollView(
          child: ListBody(
            children: widget.items.map((item) {
              return CheckboxListTile(
                value: _selectedItems.contains(item),
                onChanged: (isChecked) => _itemChange(item, isChecked!),
                title: Text(
                  item.address,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontFamily: GoogleFonts.lato().fontFamily),
                ),
                // subtitle:Text(item.id),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _cancel,
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
            ),
          ),
          ElevatedButton(
            style:ElevatedButton.styleFrom(backgroundColor:Colors.white),
              onPressed: _submit,
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontFamily: GoogleFonts.lato().fontFamily,
                ),
              )),
        ]);
  }
}
