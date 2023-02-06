import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_wish.dart';

class RegiRepository {
  Future<List<RegistryItem>> fetchRegistry(String keyword) async {

    QuerySnapshot<RegistryItem>? snapshot = await FirebaseFirestore.instance.collection('registry')
        .where('user.nicknameArray', arrayContainsAny: keyword.split(''))
        .withConverter<RegistryItem>(
          fromFirestore: (snapshots, _) =>
              RegistryItem.fromJson(snapshots.data()!),
          toFirestore: (registry, _) => registry.toJson(),
        )
        .limit(20)
        .get();

    return snapshot.docs.map((e) {
      RegistryItem registryItem = e.data();
      registryItem.registryId = e.id;
      return registryItem;
    }).toList();
  }

  Future<void> addRegistry(String userId, WishItem wishItem) async {
    await FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: userId)
        .limit(1)
        .get()
        .then((value) {
      value.docs[0].reference.update({
        'wishlist': FieldValue.arrayUnion([wishItem.toJson()])
      });
    });
  }
}
