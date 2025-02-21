
extension StringExtension on String {
  String get toNoneDiacritics {
    const _nonVietnamese = 'aAeEoOuUiIdDyY';
    final _vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ|a'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ|A'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ|e'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ|E'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ|o'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ|O'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ|u'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ|U'),
      RegExp(r'ì|í|ị|ỉ|ĩ|i'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ|I'),
      RegExp(r'đ|d'),
      RegExp(r'Đ|D'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ|y'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ|Y')
    ];
    var result = this;
    for (int i = 0; i < _nonVietnamese.length; ++i) {
      result = result.replaceAll(_vietnameseRegex[i], _nonVietnamese[i]);
    }
    return result;
  }
}