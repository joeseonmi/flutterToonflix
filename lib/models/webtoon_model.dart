import 'package:flutter/material.dart';

class WebtoonModel {
  final String id, title, thumb;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
