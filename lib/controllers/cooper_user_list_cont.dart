import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/cooper_user_data.dart';
import '../models/cooper.dart';
import '../models/cooper_user.dart';

final cooperUserListContProvider =
    StreamProvider.family<List<CooperUser>, Cooper>((ref, cooper) {
  return ref.watch(cooperUserDataProvider).strCooperUserList(cooper.cooperId);
});
