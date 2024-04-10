import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:music_player/core/constants/strings.dart';
import 'package:music_player/music/models.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider with ChangeNotifier {
  final List<Music> _musics = [];
  List<Music> get musics => _musics;

  final Set<String> _favoriteMusicIds = {};
  Set<String> get favoriteMusicIds => _favoriteMusicIds;

  void toggleFavorite(String musicId) {
    if (_favoriteMusicIds.contains(musicId)) {
      _favoriteMusicIds.remove(musicId);
    } else {
      _favoriteMusicIds.add(musicId);
    }
    notifyListeners();
    saveFavoriteMusicsLocally();
    _lastToggled = DateTime.now();
    _isSyncPending = true;
  }

  DateTime? _lastToggled;
  bool _isSyncPending = false;

  MusicCategory _musicCategory = MusicCategory.all;
  MusicCategory get musicCategory => _musicCategory;
  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  void updateSearchQuery(String query) {
    EasyDebounce.debounce('search_query', const Duration(milliseconds: 800),
        () {
      _searchQuery = query;
      notifyListeners();
    });
  }

  void updateMusicCategory(MusicCategory category) {
    _musicCategory = category;
    notifyListeners();
  }

  Future<List<Music>> fetchMusics({
    required int offset,
    required int length,
  }) async {
    if (_musics.isEmpty) {
      await loadMusicsFromAssets();
      if (!kIsWeb) {
        // Web cannot have access to file system
        loadMusicsFromDeviceStorage();
      }
      notifyListeners();
    }
    return paginate(offset: offset, length: length);
  }

  List<Music> paginate({
    required int offset,
    required int length,
  }) {
    List<Music> filteredMusic = filteredMusics;
    if (offset < 0 || offset >= filteredMusic.length) {
      return [];
    }

    // Calculate the end index of the sublist
    int endIndex = offset + length;
    if (endIndex > filteredMusic.length) {
      endIndex = filteredMusic.length;
    }

    // Return the sublist from offset to endIndex
    return filteredMusic.sublist(offset, endIndex);
  }

  List<Music> get filteredMusics => _musics.where((music) {
        return (musicCategory == MusicCategory.all ||
                musicCategory == music.category) &&
            (_searchQuery.isEmpty ||
                music.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                music.artist
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()));
      }).toList();

  List<Music> get favoriteMusics =>
      _musics.where((music) => _favoriteMusicIds.contains(music.id)).toList();

  Future<void> loadMusicsFromAssets(
      {String filePath = "assets/musics.json"}) async {
    final response = await rootBundle.loadString(filePath);
    final musics =
        (jsonDecode(response) as List).map((e) => Music.fromJson(e)).toList();
    _musics.addAll(musics);
  }

  Future<void> loadMusicsFromDeviceStorage() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    bool hasPermission = false;
    hasPermission = await audioQuery.checkAndRequest(
      retryRequest: true,
    );
    if (!hasPermission) return;
    List<SongModel> songs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (var song in songs) {
      addMusicFromSongModel(song);
    }
  }

  void addMusicFromSongModel(SongModel song) async {
    if (song.isMusic != true) null;
    final OnAudioQuery audioQuery = OnAudioQuery();
    Uint8List? imageData =
        await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO);
    Music music = Music(
      id: song.id.toString(),
      title: song.title,
      image: "",
      imageBytes: imageData,
      path: song.data,
      category: assignCategory(_musics.length, songGenre: song.genre),
      artist: song.artist ?? "",
      isFavorite: false,
      isAsset: false,
    );

    _musics.add(music);
  }

  MusicCategory assignCategory(
    int prevAssignedIndex, {
    String? songGenre,
  }) {
    MusicCategory? category = MusicCategory.values.firstWhereOrNull(
        (e) => e.name.toLowerCase() == songGenre?.toLowerCase());
    if (category != null) return category;
    // Temp logic to assign category from category enum list based on index
    int categoryIndex = prevAssignedIndex % MusicCategory.values.length;
    return MusicCategory.values[categoryIndex];
  }

  void saveFavoriteMusicsOnline({
    bool triggerTimerOnFailure = true,
  }) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw "Couldnt fetch current user session";
      }
      await FirebaseFirestore.instance
          .collection(Strings.favoriteMusicsDBName)
          .add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'musicIds': _favoriteMusicIds,
        'updatedOn': DateTime.now(),
      });
      _isSyncPending = false;
    } catch (e) {
      debugPrint("saveFavoriteMusicsOnline error : $e");
      _isSyncPending = true;
      // initiate background sync when saving fails
      // and if triggerTimerOnFailure flag is true
      if (triggerTimerOnFailure) {
        _initiateBackgroundSync();
      }
    }
  }

  Future<FavoriteMusicData?> fetchFavoritesFromCloud() async {
    try {
      var snapshots = await FirebaseFirestore.instance
          .collection(Strings.favoriteMusicsDBName)
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy(
            "updatedOn",
            descending: true,
          )
          .get();
      var data = snapshots.docs
          .map((e) => FavoriteMusicData.fromJson(e.data()))
          .toList();
      return data.firstOrNull;
    } catch (e) {
      debugPrint("fetchFavoritesFromCloud error : $e");
      return null;
    }
  }

  void saveFavoriteMusicsLocally() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        Strings.favoriteMusicsDBName,
        jsonEncode(
          FavoriteMusicData(
            musicIds: _favoriteMusicIds,
            updatedOn: DateTime.now(),
          ).toJson(),
        ),
      );
      saveFavoriteMusicsOnline();
    } catch (e) {
      debugPrint("saveFavoriteMusicsLocally error : $e");
    }
  }

  Future<FavoriteMusicData?> fetchFavoritesFromLocalStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var storedData = prefs.getString(Strings.favoriteMusicsDBName);
      final FavoriteMusicData? favoritesData = storedData == null
          ? null
          : FavoriteMusicData.fromJson(jsonDecode(storedData));
      return favoritesData;
    } catch (e) {
      debugPrint("fetchFavoritesFromLocalStorage error : $e");
      return null;
    }
  }

  void syncFavoritesData() async {
    try {
      DateTime latestToggledData = DateTime.now();
      Set<String> latestFavoritesId = {};

      final onlineData = await fetchFavoritesFromCloud();
      final localData = await fetchFavoritesFromLocalStorage();

      print("online data ==> ${onlineData?.toJson()}");
      print("local data ==> ${localData?.toJson()}");

      // Determine the latest data among online, local, and existing session data
      if ((onlineData?.updatedOn ?? DateTime(0))
              .isAfter(localData?.updatedOn ?? DateTime(0)) &&
          (onlineData?.updatedOn ?? DateTime(0))
              .isAfter(_lastToggled ?? DateTime(0))) {
        latestFavoritesId = onlineData?.musicIds ?? {};
        latestToggledData = onlineData?.updatedOn ?? DateTime.now();
      } else if ((localData?.updatedOn ?? DateTime(0))
          .isAfter(_lastToggled ?? DateTime(0))) {
        latestFavoritesId = localData?.musicIds ?? {};
        latestToggledData = localData?.updatedOn ?? DateTime.now();
      } else {
        latestFavoritesId = _favoriteMusicIds;
        latestToggledData = _lastToggled ?? DateTime.now();
      }

      // Update session data with the latest data
      _favoriteMusicIds
        ..clear()
        ..addAll(latestFavoritesId);
      _lastToggled = latestToggledData;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error syncing favorites data: $e\n$stackTrace');
    }
  }

  void removeFavoritesData() async {
    try {
      _favoriteMusicIds.clear();
      _lastToggled = null;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(Strings.favoriteMusicsDBName);
    } catch (e) {
      debugPrint("removeFavoritesData error : $e");
    }
  }

  // Sync data periodically
  Timer? _bgSyncTimer;
  void _initiateBackgroundSync() {
    const duration = Duration(seconds: 5);
    // overrides timer if already running
    _bgSyncTimer = Timer.periodic(duration, (timer) async {
      if (_isSyncPending) {
        saveFavoriteMusicsOnline(
          // do not re-trigger timer on failure as its already running
          triggerTimerOnFailure: false,
        );
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _bgSyncTimer?.cancel();
    super.dispose();
  }
}
