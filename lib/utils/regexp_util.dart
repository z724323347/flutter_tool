/// 手机正则
final RegExp phoneReg = RegExp(r'^[1][3,4,5,6,7,8,9][0-9]{9}$');

/// 密码格式正则
final RegExp pwdReg =
    RegExp(r'^(?![a-zA-z]+$)(?!\d+$)(?![!@#$%^&*]+$)[a-zA-Z\d!@#$%^&*]+$');

/// 6位数验证码正则
final RegExp verifyReg = RegExp(r'^\d{6}$');

/// 视屏格式正则
final RegExp videoReg =
    RegExp(r'.(mp4)|(rmvb)|(flv)|(mpeg)|(avi)|(MP4)|(AVI)|(FLV)|(MPEG)$');

/// 身份证格式正则
final RegExp iDCardReg = RegExp(r'(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)');

/// 银行卡格式正则
final RegExp bankReg = RegExp(r'^\d{9,29}$');

///
///
/// 正则验证
class Validators {
  // 手机号码校验
  static bool isPhone(String phone) {
    return phoneReg.hasMatch(phone);
  }

  // 登录密码校验
  static bool isPwd(String pwd) {
    if (pwd.length < 6) {
      return false;
    } else {
      return pwdReg.hasMatch(pwd);
    }
  }

  // 6位数验证码校验
  static bool isCode(String code) {
    return verifyReg.hasMatch(code);
  }

  // 校验视频格式
  static bool isVideo(String videoUrl) {
    return videoReg.hasMatch(videoUrl);
  }

  // 身份证正则
  static bool isIDCard(String idCard) {
    return iDCardReg.hasMatch(idCard);
  }
}
