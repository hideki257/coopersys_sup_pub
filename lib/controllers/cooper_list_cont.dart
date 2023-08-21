import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cooper_data.dart';
import '../models/cooper.dart';

final cooperListContProvider = StreamProvider<List<Cooper>>((ref) {
  Stream stream = ref.watch(cooperDataProvider).strQrySnpCooperList();
  return stream.map<List<Cooper>>((qrySnp) =>
      qrySnp.docs.map<Cooper>((doc) => Cooper.fromMap(doc.data())).toList());
});
