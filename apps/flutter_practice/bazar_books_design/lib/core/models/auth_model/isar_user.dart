import 'package:isar/isar.dart';

part 'isar_user.g.dart';

@collection
class IsarUser {
  Id id = Isar.autoIncrement;

  late String? userId;
  late String? name;
  late String? email;

  late bool isLoggedIn;
  late String? avatarUrl;
  late String? phoneNumber;

  List<FavoriteProduct>? favoriteProducts;

  IsarUser({
    this.userId,
    this.name,
    this.email,
    this.isLoggedIn = false,
    this.avatarUrl,
    this.phoneNumber,
    this.favoriteProducts,
  });
}

@embedded
class FavoriteProduct {
  late String productId;
  late String userId;
  late bool isFavorite;
}
