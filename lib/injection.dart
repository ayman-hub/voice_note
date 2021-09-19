



import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:voice_note/voice/data/data_sources/local_data/record.dart';
import 'package:voice_note/voice/data/remote_data/firebase_remote_data.dart';
import 'package:voice_note/voice/data/repositories/data_repositry.dart';
import 'package:voice_note/voice/domain/repositories/domain_repositry.dart';

import 'voice/data/data_sources/local_data/shared_preferences.dart';
import 'voice/domain/use_cases/case.dart';




final sl = GetIt.instance;

Future<void> init()async{
  //! feature
  // for bloc
  // * cases
  sl.registerLazySingleton(
          () => Cases(domainRepositry: sl())); //? need domain repositry



  // * repository
  sl.registerLazySingleton<DomainRepositry>(
          () => DataRepositry(remoteData: sl(),getSharedPreference: sl(), record: sl()));

  //! external
  sl.registerLazySingleton(() => RemoteData(firestore: sl()));
  sl.registerLazySingleton(() => GetSharedPreference(sharedPreferences: sl()));
  sl.registerLazySingleton(() => Record(sl()));
  // * database from local data source
  //sl.registerLazySingleton(() => DBHelper());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => RecordMp3.instance);
  await GetStorage.init();
  final sharedPreferences = GetStorage();
  sl.registerLazySingleton<GetStorage>(() => sharedPreferences);
}
