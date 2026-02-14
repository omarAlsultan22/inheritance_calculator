import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../models/inheritance_update.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../core/constants/inheritance/inheritance_shares.dart';


class FatherOrGrandfatherInheritanceCalculator {
  final InheritanceState _context;

  FatherOrGrandfatherInheritanceCalculator(this._context);

  final update = InheritanceUpdate();

  InheritanceResult calculate() {
    if (_hasMaleDescendant()) {
      return _calculateOneSixthShare();
    }
    return _calculateResidualShare();
  }

  bool _hasMaleDescendant() {
    return _context.heirsItems!.containsKey(HeirType.son.heirName) ||
        _context.heirsItems!.containsKey(HeirType.sonsSon.heirName);
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
      share: Shares.sixth,
      description: "يرث الأب السدس في وجود فرع وارث ذكر",
    );
  }

  InheritanceResult _calculateResidualShare() {
    update.extraAdjustment = 1.0;
    _getDaughtersShare();
    _getSonsDaughtersShare();
    _handleMotherPresence();

    return InheritanceResult(
      share: Shares.sixth + _context.extra!,
      description: _getResidualDescription(),
    );
  }

  String _getResidualDescription() {
    return _context.baseValue! > 1
        ? "يرث الأب السدس وتعصيب مع وجود فرع وارث أنثى"
        : "يرث الأب بالتعصيب في غياب الفرع الوارث";
  }

  bool _hasDaughter() {
    return _context.heirsItems!.containsKey(HeirType.daughter.heirName);
  }

  bool _hasSonsDaughter() {
    return _context.heirsItems!.containsKey(HeirType.sonsDaughter.heirName);
  }

  void _getDaughtersShare() {
    if (_hasDaughter()) {
      double totalShare = _context.extra!;
      final daughterCount = _context.heirsItems![HeirType.daughter.heirName]!
          .count;

      final isSingle = daughterCount < 2;

      final share = isSingle ? Shares.hafe : Shares.twoThirds;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _getSonsDaughtersShare() {
    if (_hasDaughter()) {
      double totalShare = _context.extra!;
      final finalShare = totalShare - Shares.sixth;
      _context.extra = finalShare;
      return;
    }

    if (_hasSonsDaughter()) {
      double totalShare = _context.extra!;
      final sonsDaughterCount = _context.heirsItems![HeirType.daughter
          .heirName]!.count;

      final isSingle = sonsDaughterCount < 2;

      final share = isSingle ? Shares.hafe : Shares.twoThirds;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _handleMotherPresence() {
    if (_context.heirsItems!.containsKey(HeirType.mother) &&
        !_context.isMotherPresent!) {
      update.markMotherPresent = true;
    }
  }
}




















