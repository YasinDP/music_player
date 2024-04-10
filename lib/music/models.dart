import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/app_colors.dart';
import 'package:music_player/core/constants/assets.dart';
import 'package:music_player/core/utils/convertors.dart';

class Music {
  final String id;
  final String title;
  final String image;
  final Uint8List? imageBytes;
  final String path;
  final MusicCategory category;
  final String artist;
  final bool isFavorite;
  final bool isAsset;

  const Music({
    required this.id,
    required this.title,
    required this.image,
    this.imageBytes,
    required this.path,
    required this.category,
    required this.artist,
    this.isFavorite = false,
    this.isAsset = false,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        image: json["image"] ?? "",
        path: json["path"] ?? "",
        category:
            MusicCategory.values.firstWhere((e) => e.name == json["category"]),
        artist: json["artist"] ?? "",
        isFavorite: json["isFavorite"] ?? false,
        isAsset: json["isAsset"] ?? false,
      );

  Color get primaryColor => AppColor.primary;

  Music updateWith({bool? isFavorite}) => Music(
        id: id,
        title: title,
        image: image,
        path: path,
        category: category,
        artist: artist,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}

enum MusicCategory {
  all(Assets.allMusicIcon),
  hipHop(Assets.hipoHopIcon),
  rock(Assets.rockIcon),
  pop(Assets.popIcon),
  classic(Assets.classicalIcon),
  electronic(Assets.electronicIcon),
  ambient(Assets.ambientIcon);

  final String image;
  const MusicCategory(this.image);
}

class FavoriteMusicData {
  final Set<String> musicIds;
  final DateTime updatedOn;

  const FavoriteMusicData({
    required this.musicIds,
    required this.updatedOn,
  });

  factory FavoriteMusicData.fromJson(Map<String, dynamic> json) =>
      FavoriteMusicData(
        musicIds: Convertor.getStringSet(json["musicIds"]),
        updatedOn: Convertor.getDateTime(json["updatedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "musicIds": musicIds.toList(),
        "updatedOn": updatedOn.toIso8601String(),
      };
}
