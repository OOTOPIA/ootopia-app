import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class GeneralConfig extends Equatable {
  String name;
  String value;

  GeneralConfig({required this.name, required this.value});

  factory GeneralConfig.fromJson(Map<String, dynamic> parsedJson) {
    return GeneralConfig(
      name: parsedJson['name'],
      value: parsedJson['value'],
    );
  }

  @override
  List<Object> get props => [
        name,
        value,
      ];
}

class GeneralConfigName {
  static final String transferOOZToPostLimit = "transfer_ooz_to_post_limit";
}
