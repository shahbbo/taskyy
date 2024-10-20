import 'package:taskyy/shared/network/local/cache_helper.dart';


String? tokenId = CacheHelper.getData(key: 'TokenId');

String? refreshToken = CacheHelper.getData(key: 'refreshToken');

String? uid = CacheHelper.getData(key: 'ID');

bool? onBoardingg = CacheHelper.getData(key: 'onBoarding');