import 'package:flutter/material.dart';
import '../screens/news_detail_screen.dart';

class NewsTile extends StatefulWidget {
  final Map<String, dynamic> article;
  final bool initialSaved;
  final Function(bool) onSaveToggle;

  const NewsTile({
    super.key,
    required this.article,
    this.initialSaved = false,
    required this.onSaveToggle,
  });

  @override
  State<NewsTile> createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialSaved;
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    widget.onSaveToggle(_isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.article['urlToImage'] ?? widget.article['image'];
    final source = widget.article['source'] is Map ? widget.article['source']['name'] : widget.article['source'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailScreen(article: widget.article),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    imageUrl ?? "https://placehold.jp/24/333333/ffffff/300x200.png?text=NewsDroid",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Image not available", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article['title'] ?? 'No title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        source?.toString() ?? 'News Source',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  onPressed: _toggleSave,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
