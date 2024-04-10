import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/music/models.dart';

void main() {
  group('FavoriteMusicData Serialization Tests', () {
    test('Serialization Test', () {
      final favoriteMusicData = FavoriteMusicData(
        musicIds: {'id1', 'id2'},
        updatedOn: DateTime.now(),
      );

      final json = favoriteMusicData.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['musicIds'], isA<List>());
      expect(json['musicIds'], equals(['id1', 'id2']));
      expect(json['updatedOn'], isA<String>());
    });

    test('Deserialization Test', () {
      final json = {
        "musicIds": ["id1", "id2"],
        "updatedOn": "2022-04-01T10:00:00Z"
      };

      final favoriteMusicData = FavoriteMusicData.fromJson(json);

      expect(favoriteMusicData, isA<FavoriteMusicData>());
      expect(favoriteMusicData.musicIds, isA<Set<String>>());
      expect(favoriteMusicData.musicIds, equals({'id1', 'id2'}));
      expect(favoriteMusicData.updatedOn, isA<DateTime>());
    });
  });
}
