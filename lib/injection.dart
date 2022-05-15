import 'package:get_it/get_it.dart';

import 'networking/handler/api_base_handler.dart';
import 'networking/network/network_info.dart';
import 'repository/coco/data/datasources/coco_search_remote_darasource.dart';
import 'repository/coco/data/repositories/search_repository_impl.dart';
import 'repository/coco/domain/repositories/search_repository.dart';
import 'repository/coco/domain/usecases/search_coco_dataset.dart';
import 'repository/coco/presentation/bloc/explorer_bloc.dart';
import 'repository/coco/presentation/providers/search_tags_provider.dart';

final servLocator = GetIt.instance;

void init() {
  //! Core
  servLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  servLocator.registerLazySingleton<ApiHandler>(() => SimpleApiHandler());

  //! Features ...

  //! Search Tags Provider
  servLocator.registerLazySingleton(() => SearchTagsProvider());

  //! COCO Dataset Explorer Feature
  //! Explorer Bloc
  servLocator.registerFactory(
    () => ExplorerBloc(searchCocoDataset: servLocator()),
  );

  //! SearchCocoaDataset Usecase
  servLocator.registerLazySingleton(
    () => SearchCocoDataset(repository: servLocator()),
  );

  //! Search Repository
  servLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: servLocator()),
  );

  //! Coca Search datasources
  servLocator.registerLazySingleton<CocoSearchRemoteDataSource>(
    () => CocoSearchRemoteDataSourceImpl(
      apiHandler: servLocator(),
      networkInfo: servLocator(),
    ),
  );
}
