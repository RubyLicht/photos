import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/photo_bloc.dart';
import '../bloc/photo_event.dart';
import '../bloc/photo_state.dart';
import '../widgets/photo_card.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({super.key});

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial photos
    context.read<PhotoBloc>().add(const PhotoEvent.loadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrolledTo80Percent()) {
      context.read<PhotoBloc>().add(const PhotoEvent.loadMoreRequested());
    }
  }

  bool _isScrolledTo80Percent() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Ready to load photos'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (photos, currentPage, hasReachedMax) {
              return _buildPhotoGrid(photos, false);
            },
            loadingMore: (photos, currentPage) {
              return _buildPhotoGrid(photos, true);
            },
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading photos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoGrid(List photos, bool isLoadingMore) {
    return GridView.builder(
      key: const PageStorageKey('photo_grid'),
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      addAutomaticKeepAlives: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.85,
      ),
      itemCount: photos.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          // Loading indicator at the end
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final photo = photos[index];
        return PhotoCard(
          key: ValueKey(photo.id),
          photo: photo,
        );
      },
    );
  }
}
