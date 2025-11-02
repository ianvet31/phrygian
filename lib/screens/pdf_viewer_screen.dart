import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../models/music_item.dart';

class PdfViewerScreen extends StatefulWidget {
  final MusicItem musicItem;

  const PdfViewerScreen({
    super.key,
    required this.musicItem,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openAsset(widget.musicItem.filePath),
      );
      
      // Wait a bit to ensure controller is ready
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading PDF: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.musicItem.title,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            if (!_isLoading && _errorMessage == null && _pdfController != null)
              ValueListenableBuilder<int>(
                valueListenable: _pdfController!.pageListenable,
                builder: (context, currentPage, _) {
                  return Text(
                    'Page $currentPage of ${_pdfController!.pagesCount}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  );
                },
              ),
          ],
        ),
        backgroundColor: const Color(0xFF1a1a1a),
        foregroundColor: Colors.white,
        actions: [
          // Fit to screen
          if (!_isLoading && _errorMessage == null)
            IconButton(
              icon: const Icon(Icons.fit_screen),
              onPressed: () {
                // pdfx handles zoom via pinch gestures
                // No programmatic zoom methods available
              },
              tooltip: 'Pinch to Zoom',
            ),
        ],
      ),
      body: _isLoading
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading PDF...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : PdfViewPinch(
                  controller: _pdfController!,
                  padding: 10,
                  backgroundDecoration: const BoxDecoration(
                    color: Color(0xFF2a2a2a),
                  ),
                ),
      // Navigation controls
      bottomNavigationBar: !_isLoading && _errorMessage == null && _pdfController != null
          ? Container(
              color: const Color(0xFF1a1a1a),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ValueListenableBuilder<int>(
                valueListenable: _pdfController!.pageListenable,
                builder: (context, currentPage, _) {
                  final totalPages = _pdfController!.pagesCount ?? 0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // First page
                      IconButton(
                        icon: const Icon(Icons.first_page, color: Colors.white),
                        onPressed: currentPage > 1
                            ? () {
                                _pdfController?.animateToPage(
                                  pageNumber: 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        tooltip: 'First Page',
                      ),
                      // Previous page
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: currentPage > 1
                            ? () {
                                _pdfController?.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        tooltip: 'Previous Page',
                      ),
                      // Page indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$currentPage / $totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Next page
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.white),
                        onPressed: currentPage < totalPages
                            ? () {
                                _pdfController?.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        tooltip: 'Next Page',
                      ),
                      // Last page
                      IconButton(
                        icon: const Icon(Icons.last_page, color: Colors.white),
                        onPressed: currentPage < totalPages
                            ? () {
                                _pdfController?.animateToPage(
                                  pageNumber: totalPages,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        tooltip: 'Last Page',
                      ),
                    ],
                  );
                },
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
