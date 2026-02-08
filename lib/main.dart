import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'features/photos/data/datasources/photo_remote_datasource.dart';
import 'features/photos/data/repositories/photo_repository_impl.dart';
import 'features/photos/domain/usecases/get_photos_usecase.dart';
import 'features/photos/presentation/bloc/photo_bloc.dart';
import 'features/photos/presentation/pages/photo_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection setup
  final httpClient = http.Client();
  final photoRemoteDataSource = PhotoRemoteDataSourceImpl(client: httpClient);
  final photoRepository = PhotoRepositoryImpl(remoteDataSource: photoRemoteDataSource);
  final getPhotosUseCase = GetPhotosUseCase(photoRepository);
  final photoBloc = PhotoBloc(getPhotosUseCase: getPhotosUseCase);

  runApp(MyApp(photoBloc: photoBloc));
}

class MyApp extends StatelessWidget {
  final PhotoBloc photoBloc;

  const MyApp({super.key, required this.photoBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider.value(
        value: photoBloc,
        child: const PhotoListPage(),
      ),
    );
  }
}
