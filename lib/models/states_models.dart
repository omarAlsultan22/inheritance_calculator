import 'heir_processor_model.dart';
import 'inheritance_state_model.dart';


class HusbandProcessor extends HeirProcessor{
  HusbandProcessor({super.state});

  @override
  void process() {

    if (!state!.done) {
      if (_checkBranches(state!)) {
        const text = "يرث الزوج الربع في حالة وجود فرع وارث ذكر أو أنثي";
        const share = 0.25;
        state!.addHeir("الزوج", text, share, 0);
        state!.heirsDone["الزوج"] = true;
        state!.done = true;
      } else {
        const text = "يرث الزوج النصف في حالة عدم وجود فرع وارث ذكر أو أنثي";
        const share = 0.5;
        state!.addHeir("الزوج", text, share, 0);
        state!.heirsDone["الزوج"] = true;
        state!.done = true;
      }
    }
  }
}

class WifeProcessor extends HeirProcessor{
  WifeProcessor({super.state, super.count});

  @override
  void process() {
    if (!state!.done) {
      final isSingleWife = count == 1;
      final heirName = isSingleWife ? "الزوجة" : "أكثر من زوجة";

      if (_checkBranches(state!)) {
        final text = "ترث $heirName الثمن في حالة وجود فرع وارث ذكر أو أنثي";
        const share = 0.125;
        state!.addHeir(heirName, text, share, 0);
        state!.heirsDone[heirName] = true;
        state!.done = true;
      } else {
        final text = "ترث $heirName الربع في حالة عدم وجود فرع وارث ذكر أو أنثي";
        const share = 0.25;
        state!.addHeir(heirName, text, share, 0);
        state!.heirsDone[heirName] = true;
        state!.done = true;
      }
    }
  }
}

class FatherProcessor extends HeirProcessor{
  FatherProcessor({super.state});
  @override
  void process() {
    if (state!.heirsItems.containsKey("الابن") || state!.heirsItems.containsKey("ابن الابن")) {
      const text = "يرث الأب السدس في وجود فرع وارث ذكر الابن أو ابن الابن";
      const share = 0.16;
      state!.addHeir("الأب", text, share, 1);
    }
    else if ((state!.heirsItems.containsKey("البنت") && state!.value == 0.0) ||
        (state!.heirsItems.containsKey("بنت الابن") && state!.value == 0.0)) {
      state!.value = 0.16;
      state!.extra -= state!.value;
    }
    else {
      const heir = "الأب";
      String text = "يرث الأب بالتعصيب في غياب الفرع الوارث أبناء أو بنات";

      if (state!.value > 1) {
        text = "يرث الأب السدس وتعصيب مع وجود فرع وارث أنثي البنت أو بنت الابن";
      }

      if (state!.heirsItems.containsKey("الأم") && !state!.isHere) {
        state!.isHere = true;
        state!.addHeir(heir, text, state!.extra + state!.value, 1);
      } else {
        state!.addHeir(heir, text, state!.extra + state!.value, 1);
      }
      state!.extra = 0.0;
    }
  }
}

class MotherProcessor extends HeirProcessor{
  MotherProcessor({super.state});

  @override
  void process() {
    if (state!.heirsItems.containsKey("البنت") ||
        state!.heirsItems.containsKey("بنت الابن") ||
        state!.heirsItems.containsKey("الأخت الشقيقة") ||
        state!.heirsItems.containsKey("الأخت لأب") ||
        state!.heirsItems.containsKey("الابن") ||
        state!.heirsItems.containsKey("ابن الابن") ||
        state!.heirsItems.containsKey("الأخ الشقيق")) {
      const text = "ترث الام السدس في وجود فرع وارث الابن أو ابن الابن أو البنت أو بنت الابن أو أخوة";
      const share = 0.16;
      state!.addHeir("الأم", text, share, 2);
    }
    else if (state!.heirsItems.containsKey("الزوج") || state!.heirsItems.containsKey("الزوجة")) {
      const text = "ترث الأم ثلث الباقي في أحد العمرتين مع الأب والزوج أو الزوجة";
      final share = state!.extra / 3;
      state!.addHeir("الأم", text, share, 2);
    }
    else {
      const share = 0.3;
      const text = "ترث الأم الثلث في غياب الفرع الوراث ذكور واناث والأخوة الأشقاء ذكور واناث والأخت لأب";
      state!.addHeir("الأم", text, share, 2);
    }
  }
}

class PaternalGrandfatherProcessor extends HeirProcessor{
  PaternalGrandfatherProcessor({super.state});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الأب")) {
      const text = "يحجب الجد بالأصل الوارث الذي يسبقه وهو الأب";
      state!.heirsDetails["الجد"] = text;
      return;
    }

    if (state!.heirsItems.containsKey("الابن") || state!.heirsItems.containsKey("ابن الابن")) {
      const text = "يرث الجد السدس في غياب الأب ومع وجود فرع وارث ذكر الابن أو ابن الابن";
      const share = 0.16;
      state!.addHeir("الجد", text, share, 1);
    }
    else if (state!.heirsItems.containsKey("البنت") || state!.heirsItems.containsKey("بنت الابن") && state!.value == 0) {
      state!.value = 0.16;
      state!.extra -= state!.value;
    }
    else {
      String text = "يرث الجد بالتعصيب في غياب الفرع الوارث أبناء أو بنات";
      if (state!.value > 1) {
        text = "يرث الجد السدس وتعصيب مع وجود فرع وارث أنثي البنت أو بنت الابن";
      }
      state!.addHeir("الجد", text, state!.extra + state!.value, 1);
    }
  }
}

class PaternalGrandmotherProcessor extends HeirProcessor{
  PaternalGrandmotherProcessor({super.state});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الأب") || state!.heirsItems.containsKey("الأم")) {
      const text = "تحجب الجدة لأم في حضور الأم والأصل الوارث وهو الأب";
      state!.heirsDetails["الجدة لأم"] = text;
      return;
    }

    if (state!.heirsItems.containsKey("الجدة لأب")) {
      const text = "ترث الجدة لأم مع الجدة لأب السدس في حالة غياب الأم والأب";
      const share = 0.16;
      state!.addHeir("الجدة لأم", text, share, 2);
    }
    else {
      const text = "ترث الجدة لأم السدس منفرده في حالة عدم وجود الأم أو الجدة لأم";
      const share = 0.16;
      state!.addHeir("الجدة لأم", text, share, 2);
    }
  }
}

class MaternalGrandmotherProcessor extends HeirProcessor{
  MaternalGrandmotherProcessor({super.state});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الأب") || state!.heirsItems.containsKey("الأم")) {
      const text = "تحجب الجدة لأب في حضور الأم والأصل الوارث وهو الأب";
      state!.heirsDetails["الجدة لأب"] = text;
      return;
    }

    if (state!.heirsItems.containsKey("الجدة لأم")) {
      const text = "ترث الجدة لأب مع الجدة لأم السدس في حالة غياب الأم والأب";
      const share = 0.16;
      state!.addHeir("الجدة لأب", text, share, 2);
    }
    else {
      const text = "ترث الجدة لأب السدس منفردة في حالة غياب الأب و الأم و الجدة لأم";
      const share = 0.16;
      state!.addHeir("الجدة لأب", text, share, 2);
    }
  }
}

class DaughterProcessor extends HeirProcessor{
  DaughterProcessor({super.state, super.count});

  @override
  void process() {
    final sonsCount = state!.heirsItems["الابن"]!.count;
    final isSingle = count == 1;

    if (sonsCount > 0) {
      final share = state!.extra / (sonsCount * 2 + count);
      final heirName = isSingle ? "البنت" : "$count من البنات";
      const text = "ترث البنات بالتعصيب في وجود المعصب لهم وهو الابن";
      state!.addHeir(heirName, text, share * count, 4);
    }
    else {
      final share = isSingle ? 0.5 : 0.66;
      final heirName = isSingle ? "البنت" : "$count من البنات";
      final text = isSingle
          ? "ترث البنت النصف في غياب المعصب لها وهو الابن"
          : "ترث البنات الثلثان في غياب المعصب لهم وهو الابن";

      state!.addHeir(heirName, text, share, 4);

      if (state!.heirsItems.containsKey("الأب")) {
        FatherProcessor()..process();
      } else {
        PaternalGrandfatherProcessor()..process();
      }
    }
  }
}

class SonsDaughterProcessor extends HeirProcessor{
  SonsDaughterProcessor({super.state, super.count});

  @override
  void process() {
    final isSingle = count == 1;

    if (state!.heirsItems.containsKey("الابن")) {
      const text = "تحجب بنت الابن بحضور الابن";
      state!.heirsDetails["بنت الابن"] = text;
      return;
    }

    final grandsonsCount = state!.heirsItems["ابن الابن"]!.count;
    final heirName = isSingle ? "بنت الابن" : "$count من بنات الابن";

    if (grandsonsCount > 0) {
      final share = state!.extra / (grandsonsCount * 2 + count);
      final text = isSingle
          ? "ترث بنت الابن بالتعصيب في وجود معصبها ابن الابن"
          : "ترث بنات الابن بالتعصيب في وجود معصبهم ابن الابن";

      state!.addHeir(heirName, text, share * count, 5);
    }
    else if (state!.heirsItems.containsKey('البنت')) {
      const share = 0.16;
      final text = isSingle
          ? "ترث بنت الابن السدس في وجود البنت"
          : "ترث بنات الابن السدس في وجود البنت";

      state!.addHeir(heirName, text, share, 5);
    }
    else {
      final share = isSingle ? 0.5 : 0.66;
      final text = isSingle
          ? "ترث بنت الابن النصف في غياب البنت و معصبها ابن الابن"
          : "ترث بنات الابن الثلثين في غياب البنت ومعصبهم ابن الابن";

      state!.addHeir(heirName, text, share, 5);

      if (state!.heirsItems.containsKey("الأب")) {
        FatherProcessor()..process();
      } else {
        PaternalGrandfatherProcessor()..process();
      }
    }
  }
}

class SonProcessor extends HeirProcessor{
  SonProcessor({super.state, super.count});

  @override
  void process() {
    final isSingle = count == 1;
    final heirName = isSingle ? "الابن" : "$count من الأبناء";
    const text = "يرث الأبناء بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class SonsSonProcessor extends HeirProcessor{
  SonsSonProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الابن")) {
      const text = "يحجب ابن الابن بحضور الابن";
      state!.heirsDetails["ابن الابن"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "ابن الابن" : "$count من أبناء الابن";
    const text = "يرث أبناء الابن بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class FullSisterProcessor extends HeirProcessor{
  FullSisterProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الابن") ||
        state!.heirsItems.containsKey("ابن الابن") ||
        state!.heirsItems.containsKey("الأب") ||
        state!.heirsItems.containsKey("الجد")) {
      const text = "تحجب الأخت الشقيقة في حضور الابن أو ابن الابن أو الأب أو الجد";
      state!.heirsDetails["الأخت الشقيقة"] = text;
      return;
    }

    final brothersCount = state!.heirsItems["الأخ الشقيق"]!.count;
    final isSingle = count == 1;
    final heirName = isSingle ? "الأخت الشقيقة" : "$count من الأخوات الشقيقات";

    if (brothersCount > 0) {
      print('Hello');
      final share = state!.extra / (brothersCount * 2 + count);
      final text = isSingle
          ? "ترث الأخت الشقيقة بالتعصيب مع أخيها الشقيق"
          : "ترث الأخوات الشقيقات بالتعصيب مع إخوتهم الأشقاء";

      state!.addHeir(heirName, text, share * count, 3);
    }
    else if (state!.heirsItems.containsKey("البنت")) {
      const share = 0.16;
      final text = isSingle
          ? "ترث الأخت الشقيقة السدس في وجود البنت"
          : "ترث الأخوات الشقيقات السدس في وجود البنت";

      state!.addHeir(heirName, text, share, 3);
    }
    else {
      final share = isSingle ? 0.5 : 0.66;
      final text = isSingle
          ? "ترث الأخت الشقيقة النصف في غياب الأخ الشقيق والبنت"
          : "ترث الأخوات الشقيقات الثلثين في غياب الأخ الشقيق والبنت";

      state!.addHeir(heirName, text, share, 3);
    }
  }
}

class PaternalSisterProcessor extends HeirProcessor{
  PaternalSisterProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الابن") ||
        state!.heirsItems.containsKey("ابن الابن") ||
        state!.heirsItems.containsKey("الأب") ||
        state!.heirsItems.containsKey("الجد")) {
      const text = "تحجب الأخت لأب في حضور الابن أو ابن الابن أو الأب أو الجد";
      state!.heirsDetails["الأخت لأب"] = text;
      return;
    }

    final brothersCount = state!.heirsItems["الأخ لأب"]!.count;
    final isSingle = count == 1;
    final heirName = isSingle ? "الأخت لأب" : "$count من الأخوات لأب";

    if (brothersCount > 0) {
      final share = state!.extra / (brothersCount * 2 + count);
      final text = isSingle
          ? "ترث الأخت لأب بالتعصيب مع أخيها لأب"
          : "ترث الأخوات لأب بالتعصيب مع إخوتهم لأب";

      state!.addHeir(heirName, text, share * count, 3);
    }
    else if (state!.heirsItems.containsKey("البنت") && state!.heirsItems.containsKey("الأخت الشقيقة")) {
      const text = "تحجب الأخت لأب في حضور البنت أو الاخت الشقيقة";
      state!.heirsDetails["الأخت لأب"] = text;
    }
    else if (state!.heirsItems.containsKey("البنت")) {
      const share = 0.16;
      final text = isSingle
          ? "ترث الاخت لأب السدس في وجود البنت"
          : "ترث الأخوات لأب السدس في وجود البنت";

      state!.addHeir(heirName, text, share, 3);
    }
    else if (state!.heirsItems.containsKey("الأخت الشقيقة")) {
      const share = 0.16;
      final text = isSingle
          ? "ترث الاخت لأب السدس في وجود الأخت الشقيقة"
          : "ترث الأخوات لأب السدس في وجود الأخت الشقيقة";

      state!.addHeir(heirName, text, share, 3);
    }
    else {
      final share = isSingle ? 0.5 : 0.66;
      final text = isSingle
          ? "ترث الأخت لأب النصف في غياب البنت والأخت الشقيقة"
          : "ترث الأخوات لأب الثلثين في غياب البنت والأخت الشقيقة";

      state!.addHeir(heirName, text, share, 3);
    }
  }
}

class MaternalSiblingsProcessor extends HeirProcessor{
  MaternalSiblingsProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey("الابن") ||
        state!.heirsItems.containsKey("البنت") ||
        state!.heirsItems.containsKey("الأب") ||
        state!.heirsItems.containsKey("الجد") ||
        state!.heirsItems.containsKey("ابن الابن") ||
        state!.heirsItems.containsKey("بنت الابن")) {
      const text = "يحجب الأخوة لأم في حضور الابن أو ابن الابن أو البنت أو بنت الابن أو الأب أو الجد";
      state!.heirsDetails["الأخ لأم"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "الأخ لأم" : "$count من الأخوة لأم";
    final share = isSingle ? 0.16 : 0.33;
    final text = isSingle
        ? "يرث الأخ لأم السدس في حالة عدم أصل أو فرع وارث"
        : "يرث الأخوة لأم الثلث في حالة عدم أصل أو فرع وارث";

    state!.addHeir(heirName, text, share, 0);
  }
}

class  FullBrotherProcessor extends HeirProcessor{
  FullBrotherProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب')) {
      const text = "يحجب الأخ الشقيق بحضور الابن أو ابن الابن أو الأب";
      state!.heirsDetails["الأخ الشقيق"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "الأخ الشقيق" : "$count من الأخوة الأشقاء";
    const text = "يرث الأخوة الأشقاء بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class PaternalBrotherProcessor extends HeirProcessor{
  PaternalBrotherProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق')) {
      const text = "يحجب الأخ لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق";
      state!.heirsDetails["الأخ لأب"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "الأخ لأب" : "$count من الأخوة لأب";
    const text = "يرث الأخوة لأب بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class  FullBrothersSonProcessor extends HeirProcessor{
  FullBrothersSonProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق')) {
      const text = "يحجب الأخ الشقيق بحضور الابن أو ابن الابن أو الأب";
      state!.heirsDetails["ابن الأخ الشقيق"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "ابن الأخ الشقيق" : "$count من ابناء الأخوة الأشقاء";
    const text = "يرث الأخوة الأشقاء بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class PaternalBrothersSonProcessor extends HeirProcessor{
  PaternalBrothersSonProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق') ||
        state!.heirsItems.containsKey('الأخ لأب')) {
      const text = "يحجب الأخ لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق";
      state!.heirsDetails["ابن الأخ لأب"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "ابن الأخ لأب" : "$count من ابناء الأخوة لأب";
    const text = "يرث الأخوة لأب بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class FullUncleProcessor extends HeirProcessor{
  FullUncleProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق') ||
        state!.heirsItems.containsKey('الأخ لأب')) {
      const text = "يحجب العم الشقيق بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب";
      state!.heirsDetails["العم الشقيق"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "العم الشقيق" : "$count من الأعمام الأشقاء";
    const text = "يرث الأعمام الأشقاء بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class PaternalUncleProcessor extends HeirProcessor{
  PaternalUncleProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق') ||
        state!.heirsItems.containsKey('الأخ لأب') ||
        state!.heirsItems.containsKey('العم الشقيق')) {
      const text = "يحجب العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق";
      state!.heirsDetails["العم لأب"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "العم لأب" : "$count من الأعمام لأب";
    const text = "يرث الأعمام لأب بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class FullCousinProcessor extends HeirProcessor{
  FullCousinProcessor({super.state, super.count});

  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق') ||
        state!.heirsItems.containsKey('الأخ لأب') ||
        state!.heirsItems.containsKey('العم الشقيق') ||
        state!.heirsItems.containsKey('العم لأب')) {
      const text = "يحجب ابن العم الشقيق بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق أو العم لأب";
      state!.heirsDetails["ابن العم الشقيق"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "ابن العم الشقيق" : "$count من أبناء العم الشقيق";
    const text = "يرث أبناء العم الشقيق بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

class PaternalCousinProcessor extends HeirProcessor{
  PaternalCousinProcessor({super.state, super.count});
  @override
  void process() {
    if (state!.heirsItems.containsKey('الابن') ||
        state!.heirsItems.containsKey('ابن الابن') ||
        state!.heirsItems.containsKey('الأب') ||
        state!.heirsItems.containsKey('الأخ الشقيق') ||
        state!.heirsItems.containsKey('الأخ لأب') ||
        state!.heirsItems.containsKey('العم الشقيق') ||
        state!.heirsItems.containsKey('العم لأب') ||
        state!.heirsItems.containsKey('ابن العم الشقيق')) {
      const text = "يحجب ابن العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق أو العم لأب أو ابن العم الشقيق";
      state!.heirsDetails["ابن العم لأب"] = text;
      return;
    }

    final isSingle = count == 1;
    final heirName = isSingle ? "ابن العم لأب" : "$count من أبناء العم لأب";
    const text = "يرث أبناء العم لأب بالتعصيب باقي التركة";
    state!.addHeir(heirName, text, state!.extra, 5);
  }
}

bool _checkBranches(InheritanceState state) {
  return state.heirsItems.containsKey("البنت") ||
      state.heirsItems.containsKey("الابن");
}
