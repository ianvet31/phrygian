# Music Library Feature

## Overview
The Phrygian app now includes a **Music Library** feature alongside the guitar tuner. Users can browse and view sheet music, guitar tabs, and songbooks in PDF format.

## Features

### 1. Bottom Navigation
- **Tuner Tab**: Access the guitar tuner (existing functionality)
- **Music Library Tab**: Browse and view your music collection

### 2. Music Library Screen
- **Browse**: View all music items in your library
- **Search**: Find music by title, artist, or genre
- **Filter**: Filter by type (Sheet Music, Guitar Tabs, Songbook)
- **Card View**: Each item displays with icon, title, artist, and genre badge

### 3. PDF Viewer
- **Asset Loading**: Opens PDFs from the app's assets
- **Navigation Controls**: First/Previous/Next/Last page buttons
- **Zoom Controls**: Zoom in/out functionality
- **Page Counter**: Shows current page and total pages
- **Responsive**: Works on Web, Android, and iOS

## Architecture

### Models
- **MusicItem** (`lib/models/music_item.dart`)
  - Properties: title, artist, genre, filePath, type, thumbnailPath, description
  - MusicType enum: sheetMusic, guitarTabs, songbook

### Services
- **MusicRepositoryService** (`lib/services/music_repository_service.dart`)
  - Manages the music library catalog
  - Methods: getAllMusic(), getMusicByType(), searchMusic(), getMusicByGenre()
  - Currently uses in-memory storage (can be upgraded to database)

### Screens
- **MainNavigation** (`lib/main.dart`)
  - Bottom navigation between Tuner and Music Library
  - Uses IndexedStack to preserve state

- **MusicLibraryScreen** (`lib/screens/music_library_screen.dart`)
  - Search bar with real-time filtering
  - Filter chips for music types
  - Card-based list view
  - Empty state messaging

- **PdfViewerScreen** (`lib/screens/pdf_viewer_screen.dart`)
  - PDF rendering with Syncfusion Flutter PDFViewer
  - Page navigation controls
  - Zoom controls
  - Loading indicator

## Adding Music to the Library

### 1. Add PDF files to the `music/` folder
```
music/
  Your_Sheet_Music.pdf
  Guitar_Tabs_Book.pdf
```

### 2. Declare assets in `pubspec.yaml`
```yaml
flutter:
  assets:
    - music/Your_Sheet_Music.pdf
    - music/Guitar_Tabs_Book.pdf
```

### 3. Add entry to `MusicRepositoryService`
```dart
MusicItem(
  title: 'Your Sheet Music Title',
  artist: 'Composer Name',
  genre: 'Classical',
  filePath: 'music/Your_Sheet_Music.pdf',
  type: MusicType.sheetMusic,
  description: 'Brief description',
),
```

### 4. Run `flutter pub get`

## Dependencies

### Syncfusion Flutter PDFViewer
- **Package**: `syncfusion_flutter_pdfviewer: ^28.1.33`
- **Purpose**: Cross-platform PDF rendering
- **Platforms**: Web, Android, iOS, Windows, macOS
- **Features**: Zoom, pan, page navigation, text selection

### Why Syncfusion?
- ✅ Works on Web (important for testing without Mac/device)
- ✅ Works on Android and iOS
- ✅ No native code modifications required
- ✅ Rich feature set (zoom, search, annotations possible)
- ✅ Good performance with large PDFs

## Usage

### Browsing Music
1. Tap the **Music Library** tab in the bottom navigation
2. Browse the list of available music
3. Use the search bar to find specific titles, artists, or genres
4. Tap filter chips to show only specific types (Sheet Music, Tabs, Songbooks)

### Viewing PDFs
1. Tap any music item in the library
2. PDF opens in full-screen viewer
3. Use zoom buttons (+ / -) to adjust size
4. Use navigation buttons to move between pages:
   - |◀ First page
   - ◀ Previous page
   - ▶ Next page
   - ▶| Last page
5. Current page is shown in the app bar

## Platform Support

### Web
✅ **Fully Working**
- PDF rendering via Syncfusion web implementation
- All navigation and zoom features functional
- No additional setup required

### Android
✅ **Ready**
- PDF rendering via native Android implementation
- Requires Android SDK 21+ (already configured)
- Test on real device or emulator

### iOS
✅ **Ready**
- PDF rendering via native iOS implementation
- Requires iOS 11+ (standard Flutter requirement)
- Test on real device or simulator (requires Mac)

## Future Enhancements

### Database Integration
- Replace in-memory catalog with SQLite database
- Persistent storage of favorites/bookmarks
- User annotations and notes

### Music Organization
- Favorites/bookmarks system
- Recent items
- Practice lists
- Custom collections/playlists

### Advanced PDF Features
- Text search within PDFs
- Bookmarks/annotations
- Page thumbnails
- Dark mode for PDFs

### Content Management
- Download music from online library
- Backup/sync music collection
- Share music items

### Offline Support
- Download PDFs for offline viewing
- Cached thumbnails
- Progressive loading for large files

## Troubleshooting

### PDF Not Loading
- Verify file path in `MusicRepositoryService` matches actual file location
- Ensure PDF is declared in `pubspec.yaml` assets section
- Run `flutter pub get` after adding new assets
- Check console for error messages

### Performance Issues
- Large PDFs (>50 pages) may take time to load initially
- Consider compressing PDFs for better performance
- Implement lazy loading for large music libraries

### Web-Specific
- PDFs load from assets bundle (no CORS issues)
- Zoom may be slower on older browsers
- Test on latest Chrome/Edge for best performance

### Mobile-Specific
- Large PDFs may use significant memory
- Consider implementing page caching strategies
- Test on actual devices for realistic performance

## Testing Checklist

- [x] Navigation between Tuner and Music Library
- [x] Search functionality
- [x] Filter by type
- [x] Open PDF viewer
- [x] Page navigation (first/prev/next/last)
- [x] Zoom controls
- [x] Page counter display
- [x] Back navigation from PDF viewer
- [ ] Test on Android device
- [ ] Test on iOS device
- [ ] Test with multiple PDFs
- [ ] Test with large PDFs (100+ pages)
