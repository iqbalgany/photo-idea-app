import 'dart:convert';

import 'package:photo_idea_app/data/models/source_model.dart';

class PhotoModel {
  final int? id;
  final int? width;
  final int? height;
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final int? photographerId;
  final String? avgColor;
  final SourceModel? source;
  final bool? liked;
  final String? alt;

  PhotoModel({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.source,
    this.liked,
    this.alt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        avgColor: json["avg_color"],
        source: json["src"] == null ? null : SourceModel.fromJson(json["src"]),
        liked: json["liked"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "avg_color": avgColor,
        "src": source?.toJson(),
        "liked": liked,
        "alt": alt,
      };

  factory PhotoModel.fromJsonSaved(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        source: json["src"] == null
            ? null
            : SourceModel.fromJson(
                jsonDecode(json["src"]),
              ),
      );

  Map<String, dynamic> toJsonSaved() => {
        "id": id,
        "src": jsonEncode(source?.toJson()),
      };
}
