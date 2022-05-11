import 'package:flutter/material.dart';

import 'package:ootopia_app/theme/light/colors.dart';

class CustomListTile extends StatelessWidget {
  final String leadingPath;
  final Widget? trailling;
  final String title;
  final String? label;
  final Widget? labelWidget;
  final Function onTap;
  final bool hasBottomDivider;
  final EdgeInsets? leadingPadding;
  const CustomListTile({
    Key? key,
    required this.title,
    required this.leadingPath,
    required this.onTap,
    this.label,
    this.trailling,
    this.labelWidget,
    this.leadingPadding,
    this.hasBottomDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12),
                ),
                labelWidget ??
                    Text(
                      label ?? '',
                      style: TextStyle(color: LightColors.grey, fontSize: 10),
                    ),
              ],
            ),
            leading: Padding(
              padding: leadingPadding ?? EdgeInsets.zero,
              child: Image.asset(
                leadingPath,
                width: 24,
              ),
            ),
            trailing: trailling ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black,
                ),
            onTap: () => onTap(),
          ),
        ),
        if (hasBottomDivider)
          Divider(
            thickness: 0.5,
            color: Colors.grey.shade300,
            indent: 16,
            endIndent: 16,
            height: 1,
          ),
      ],
    );
  }
}
