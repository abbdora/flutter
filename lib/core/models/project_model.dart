import 'dart:ui';

import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String status;
  final int progress;
  final List<String> performers;
  final String detailedDescription;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.progress,
    required this.performers,
    required this.detailedDescription,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? status,
    int? progress,
    List<String>? performers,
    String? detailedDescription,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      performers: performers ?? this.performers,
      detailedDescription: detailedDescription ?? this.detailedDescription,
    );
  }

  static String getStatusByProgress(int progress) {
    if (progress == 0) return 'В планах';
    if (progress < 100) return 'В разработке';
    return 'Завершен';
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'В разработке':
        return Colors.blue;
      case 'Завершен':
        return Colors.green;
      case 'В планах':
        return Colors.orange;
      case 'На паузе':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }
}