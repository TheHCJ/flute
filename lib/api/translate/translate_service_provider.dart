import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';

final translateServiceProvider = Provider(
  (ref) => TranslateService(),
  name: 'TranslateServiceProvider',
);
