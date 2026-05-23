import '../enums/heir_type.dart';
import '../../data/processors/son_processor.dart';
import '../../data/processors/wife_processor.dart';
import '../../data/processors/mother_processor.dart';
import '../../data/processors/father_processor.dart';
import '../../data/processors/husband_processor.dart';
import '../../data/processors/daughter_processor.dart';
import '../../data/processors/sons_son_processor.dart';
import '../../data/processors/full_uncle_processor.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../data/processors/full_cousin_processor.dart';
import '../../data/processors/full_sister_processor.dart';
import '../../data/processors/grandfather_processor.dart';
import '../../data/processors/full_brother_processor.dart';
import '../../data/processors/sons_daughter_processor.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../data/processors/paternal_uncle_processor.dart';
import '../../data/processors/paternal_cousin_processor.dart';
import '../../data/processors/paternal_sister_processor.dart';
import '../../data/processors/paternal_brother_processor.dart';
import '../../data/processors/full_brothers_son_processor.dart';
import '../../data/processors/maternal_siblings_processor.dart';
import '../../data/processors/paternal_grandmother_processor.dart';
import '../../data/processors/maternal_grandmother_processor.dart';
import '../../data/processors/paternal_brothers_son_processor.dart';


class HeirsStats{
  static InheritanceState inheritanceState = InheritanceState(heirsItems: {});

  static Map<String, HeirProcessor> heirsMap = {
    'الزوج': HusbandProcessor(state: inheritanceState, heirType: HeirType.husband),
    'الزوجة': WifeProcessor(state: inheritanceState, heirType: HeirType.wife, count: 1),
    'الأب': FatherProcessor(state: inheritanceState, heirType: HeirType.father),
    'الأم': MotherProcessor(state: inheritanceState, heirType: HeirType.mother),
    'الجد': GrandfatherProcessor(state: inheritanceState, heirType: HeirType.grandfather),
    'الجدة لأب': PaternalGrandmotherProcessor(state: inheritanceState, heirType: HeirType.paternalGrandMother),
    'الجدة لأم': MaternalGrandmotherProcessor(state: inheritanceState, heirType: HeirType.maternalGrandmother),
    'البنت': DaughterProcessor(state: inheritanceState, count: 1, heirType: HeirType.daughter),
    'بنت الابن': SonsDaughterProcessor(state: inheritanceState, count: 1, heirType: HeirType.sonsDaughter),
    'الابن': SonProcessor(state: inheritanceState, count: 1, heirType: HeirType.son),
    'ابن الابن': SonsSonProcessor(state: inheritanceState, count: 1, heirType: HeirType.sonsSon),
    'الأخت الشقيقة': FullSisterProcessor(state: inheritanceState, count: 1, heirType: HeirType.fullSister),
    'الأخت لأب': PaternalSisterProcessor(state: inheritanceState, count: 1, heirType: HeirType.paternalSister),
    'الأخوة لأم': MaternalSiblingsProcessor(state: inheritanceState, count: 1, heirType: HeirType.maternalSiblings),
    'الأخ الشقيق': FullBrotherProcessor(state: inheritanceState, count: 1, heirType: HeirType.fullBrother),
    'الأخ لأب': PaternalBrotherProcessor(state: inheritanceState, count: 1, heirType: HeirType.paternalBrother),
    'ابن الأخ الشقيق': FullBrothersSonProcessor(state: inheritanceState, count: 1, heirType: HeirType.fullBrothersSon),
    'ابن الأخ لأب': PaternalBrothersSonProcessor(state: inheritanceState, count: 1, heirType: HeirType.paternalBrothersSon),
    'العم الشقيق': FullUncleProcessor(state: inheritanceState, count: 1, heirType: HeirType.fullUncle),
    'العم لأب': PaternalUncleProcessor(state: inheritanceState, count: 1, heirType: HeirType.paternalUncle),
    'ابن العم الشقيق': FullCousinProcessor(state: inheritanceState, count: 1, heirType: HeirType.fullCousin),
    'ابن العم لأب': PaternalCousinProcessor(state: inheritanceState, count: 1, heirType: HeirType.paternalCousin),
  };
}