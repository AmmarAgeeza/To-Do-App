import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:todo/ui/theme.dart';

import '../size_config.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top:10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            margin: const EdgeInsets.only(top: 5),
            height: 52,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    style: titleStyle,
                    readOnly: widget != null ? true : false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subtitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: context.theme.backgroundColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: context.theme.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
