import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.img,
    required this.name,
  });
  final String img;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: Colors.white, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(img),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                width: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
