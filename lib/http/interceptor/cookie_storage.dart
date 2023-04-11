import 'package:cookie_jar/cookie_jar.dart';
import 'package:encrypt/encrypt.dart';

import '../dio_utils.dart';

const String _key = 'LKosi_@#12332112LKosi_@#12332112';
const String _iv = ')jfkds_jfxxx)jfk';

final PersistCookieJar appCookieJar = PersistCookieJar(
  storage: CryptoCookieFileStorage('${DioUtils.dir}/app_cookie'),
);

class CryptoCookieFileStorage extends FileStorage {
  late Key _encryptKey;
  late IV _encryptIv;
  late Encrypter _encrypter;

  CryptoCookieFileStorage([String? dir]) : super(dir);

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    _encryptKey = Key.fromUtf8(_key);
    _encryptIv = IV.fromUtf8(_iv);
    _encrypter = Encrypter(AES(_encryptKey));

    return super.init(persistSession, ignoreExpires);
  }

  @override
  Future<void> write(String key, String value) {
    final String encryptedValue =
        _encrypter.encrypt(value, iv: _encryptIv).base64;
    return super.write(key, encryptedValue);
  }

  @override
  Future<String?> read(String key) {
    return super.read(key).then((String? value) {
      if (value == null) {
        return value;
      }
      try {
        return _encrypter.decrypt64(value, iv: _encryptIv);
      } catch (e) {
        print('<--->E $e');
        return null;
      }
    });
  }
}
