import '../models/music_item.dart';

/// Service to manage the music library
class MusicRepositoryService {
  static final MusicRepositoryService _instance = MusicRepositoryService._internal();
  
  factory MusicRepositoryService() {
    return _instance;
  }
  
  MusicRepositoryService._internal();

  // In-memory catalog of music items
  // In the future, this could load from a database or configuration file
  final List<MusicItem> _musicLibrary = [
    MusicItem(
      title: 'The Real Book - 6th Edition',
      artist: 'Various Jazz Standards',
      genre: 'Jazz',
      filePath: 'music/The_Real_Book_6th_Ed_.pdf',
      type: MusicType.songbook,
      description: 'Comprehensive collection of jazz standards with chord charts and melodies',
    ),
    // Add more music items here as you add files to the music folder
  ];

  /// Get all music items
  List<MusicItem> getAllMusic() {
    return List.unmodifiable(_musicLibrary);
  }

  /// Get music items filtered by type
  List<MusicItem> getMusicByType(MusicType type) {
    return _musicLibrary.where((item) => item.type == type).toList();
  }

  /// Search music by title, artist, or genre
  List<MusicItem> searchMusic(String query) {
    final lowerQuery = query.toLowerCase();
    return _musicLibrary.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
          (item.artist?.toLowerCase().contains(lowerQuery) ?? false) ||
          (item.genre?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get music items by genre
  List<MusicItem> getMusicByGenre(String genre) {
    return _musicLibrary.where((item) => item.genre?.toLowerCase() == genre.toLowerCase()).toList();
  }
}
