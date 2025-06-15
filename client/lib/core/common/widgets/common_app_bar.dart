import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../utils/assets_paths.dart';

class CommonAppBar extends StatelessWidget {
  final void Function(String) onFieldSubmitted;
  const CommonAppBar({super.key, required this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration:
            const BoxDecoration(gradient: GlobalVariables.appBarGradient),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                    height: 42,
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      child: TextFormField(
                        onFieldSubmitted: onFieldSubmitted,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black38, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            hintText: 'Search Amazon.in',
                            hintStyle: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                            prefixIcon: const InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image(
                                  image: AssetImage(
                                      ImagePaths.instance.cameraLogoPath)),
                            )),
                      ),
                    )),
              ),
              Row(
                children: [
                  Container(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Icon(Icons.mic_none_outlined)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
