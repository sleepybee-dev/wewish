import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_registry.dart';

class RegiRepository {

  Future<List<RegistryItem>> fetchRegistry(String keyword) async {
    QuerySnapshot<RegistryItem>? snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.nickname', isGreaterThanOrEqualTo: keyword)
        .withConverter<RegistryItem>(
      fromFirestore: (snapshots, _) =>
          RegistryItem.fromJson(snapshots.data()!),
      toFirestore: (registry, _) => registry.toJson(),
    )
        .limit(20).get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

}