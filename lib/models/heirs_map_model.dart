import 'package:men/models/states_models.dart';
import 'heir_processor_model.dart';


Map<String, HeirProcessor> heirsMap = {
  'الزوج': HusbandProcessor(),
  'الزوجة': WifeProcessor(),
  'الأب': FatherProcessor(),
  'الأم' : MotherProcessor(),
  'الجد': PaternalGrandfatherProcessor(),
  'الجدة لأب': PaternalGrandmotherProcessor(),
  'الجدة لأم': MaternalGrandmotherProcessor(),
  'البنت': DaughterProcessor(),
  'بنت الابن': SonsDaughterProcessor(),
  'الابن': SonProcessor(),
  'ابن الابن': SonsSonProcessor(),
  'الأخت الشقيقة': FullSisterProcessor(),
  'الأخت لأب': PaternalSisterProcessor(),
  'الأخوة لأم': MaternalSiblingsProcessor(),
  'الأخ الشقيق': FullBrotherProcessor(),
  'الأخ لأب': PaternalBrotherProcessor(),
  'ابن الأخ الشقيق': FullBrothersSonProcessor(),
  'ابن الأخ لأب': PaternalBrothersSonProcessor(),
  'العم الشقيق': FullUncleProcessor(),
  'العم لأب': PaternalUncleProcessor(),
  'ابن العم الشقيق': FullCousinProcessor(),
  'ابن العم لأب': PaternalCousinProcessor(),
};