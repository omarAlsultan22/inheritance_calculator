enum HeirType {
  husband('الزوج'),
  wife('الزوجة'),
  father('الأب'),
  mother('الأم'),
  son('الابن'),
  daughter('البنت'),
  sonsSon('ابن الابن'),
  sonsDaughter('بنت الابن'),
  grandfather('الجد'),
  paternalGrandMother('الجدة لأب'),
  maternalGrandmother('الجدة لأم'),
  fullSister('الأخت الشقيقة'),
  paternalSister('الأخت لأب'),
  fullBrother('الأخ الشقيق'),
  paternalBrother('الأخ لأب'),
  maternalSiblings('الأخ لأم'),
  fullUncle('العم الشقيق'),
  paternalUncle('العم لأب'),
  fullBrothersSon('ابن الأخ الشقيق'),
  paternalBrothersSon('ابن الأخ لأب'),
  fullCousin('ابن العم الشقيق'),
  paternalCousin('ابن العم لأب'),
  ;

  const HeirType(this.heirName);

  final String heirName;

  String getPluralName(int count) {
    if (count == 1) return heirName;

    final pluralMap = {
      HeirType.wife: 'الزوجات',
      HeirType.daughter: 'البنات',
      HeirType.son: 'الابناء',
      HeirType.sonsSon: 'ابناء الابن',
      HeirType.sonsDaughter: 'بنات الابن',
      HeirType.fullSister: 'الأخوات الشقيقات',
      HeirType.paternalSister: 'الأخوات لأب',
      HeirType.maternalSiblings: 'الأخوة لأم',
      HeirType.fullBrother: 'الأخوة الأشقاء',
      HeirType.paternalBrother:'الأخوة لأب',
      HeirType.fullBrothersSon:'ابناء الأخوة الأشقاء',
      HeirType.paternalBrothersSon:'ابناء الأخوة لأب',
      HeirType.fullUncle:'الأعمام الأشقاء',
      HeirType.paternalUncle:'الأعمام لأب',
      HeirType.fullCousin:'أبناء العم الشقيق',
      HeirType.paternalCousin:'أبناء العم لأب',
    };

    return pluralMap[this] ?? '$heirName (متعدد)';
  }
}