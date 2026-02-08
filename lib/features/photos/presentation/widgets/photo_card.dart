import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/photo.dart';

class PhotoCard extends StatefulWidget {
  final Photo photo;

  const PhotoCard({super.key, required this.photo});

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.photo.downloadUrl,
              cacheKey: widget.photo.id,
              fit: BoxFit.cover,
              // fadeInDuration: Duration.zero,
              // fadeOutDuration: Duration.zero,
              // placeholderFadeInDuration: Duration.zero,
              memCacheWidth: 300,
              memCacheHeight: 300,
              maxWidthDiskCache: 600,
              maxHeightDiskCache: 600,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.photo.author,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
