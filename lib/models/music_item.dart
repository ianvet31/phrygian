/// Model for a music item (sheet music, tabs, etc.)
class MusicItem {
  final String title;
  final String? artist;
  final String? genre;
  final String filePath; // Asset path to the PDF
  final MusicType type;
  final String? thumbnailPath;
  final String? description;

  const MusicItem({
    required this.title,
    this.artist,
    this.genre,
    required this.filePath,
    required this.type,
    this.thumbnailPath,
    this.description,
  });
}

enum MusicType {
  sheetMusic,
  guitarTabs,
  songbook,
}

extension MusicTypeExtension on MusicType {
  String get displayName {
    switch (this) {
      case MusicType.sheetMusic:
        return 'Sheet Music';
      case MusicType.guitarTabs:
        return 'Guitar Tabs';
      case MusicType.songbook:
        return 'Songbook';
    }
  }
  
  String get icon {
    switch (this) {
      case MusicType.sheetMusic:
        return '🎼';
      case MusicType.guitarTabs:
        return '🎸';
      case MusicType.songbook:
        return '📖';
    }
  }
}
