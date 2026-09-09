import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

const _maxBioLength = 300;

/// 1 ft = 12 in — dipakai konversi ft+in <-> cm. Simpanan ke draft/backend
/// SELALU cm (backend cuma terima height_cm); unit cm/ft di sini murni
/// preferensi TAMPILAN input, disimpan lokal (lihat
/// [DiscoverOnboardingDraftStorage.saveHeightUnitPreference]) supaya
/// konsisten dipakai lagi di step ini/Preview/Edit Profile nanti.
const _cmPerInch = 2.54;
const _inchesPerFoot = 12;

/// Step 4/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/05-bio.html, diperluas jadi
/// "Detail Diri" dengan height/ethnicity/wants_children (field yang ADA
/// di skema `profiles` tapi tidak ada di desain HTML asli — keputusan
/// produk, lihat .ai/rules/architecture.md backend). SEMUA field di sini
/// WAJIB diisi (tombol Skip dihapus) — keputusan produk, lihat catatan di
/// .ai/rules/architecture.md.
///
/// Height bisa diinput dalam cm ATAU feet+inches (toggle) — feet+inches
/// dipakai TERPISAH (bukan feet desimal, mis. "5.7 ft") karena notasi
/// desimal feet TIDAK SAMA dengan notasi umum 5'7" (5 ft 7 in): 5.7 ft
/// sebenarnya ekuivalen 5'8.4", bukan 5'7" — ambigu dan gampang salah
/// input kalau dipaksa jadi 1 field desimal.
///
/// Ethnicity dari bottom sheet select (kategori luas ala
/// Tinder/Bumble/Hinge — bukan per-suku/per-negara), BUKAN teks bebas
/// lagi — data lebih konsisten untuk filtering/matching nanti, "Other"
/// jadi jaring pengaman untuk yang tidak tercakup kategori lain.
class BioStepScreen extends StatefulWidget {
  const BioStepScreen({super.key});

  @override
  State<BioStepScreen> createState() => _BioStepScreenState();
}

enum _HeightUnit { cm, footInch }

class _BioStepScreenState extends State<BioStepScreen> {
  final _bioController = TextEditingController();
  final _heightCmController = TextEditingController();
  final _heightFeetController = TextEditingController();
  final _heightInchController = TextEditingController();
  String? _ethnicity;
  bool? _wantsChildren;
  bool _wantsChildrenTouched = false;
  _HeightUnit _heightUnit = _HeightUnit.cm;
  bool _isLoadingDraft = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _bioController.addListener(() => setState(() {}));
  }

  Future<void> _loadDraft() async {
    final bio = await DiscoverOnboardingDraftStorage.readBio();
    final heightCm = await DiscoverOnboardingDraftStorage.readHeightCm();
    final ethnicity = await DiscoverOnboardingDraftStorage.readEthnicity();
    final wantsChildren =
        await DiscoverOnboardingDraftStorage.readWantsChildren();
    // "Not sure yet" DISIMPAN sebagai null (sama seperti "belum pernah
    // disentuh") — draft key wants_children ada/tidaknya dipakai untuk
    // bedakan keduanya, supaya validasi wajib tidak salah anggap user
    // yang sudah pilih "Not sure yet" sebagai belum mengisi.
    final wantsChildrenKeyExists =
        await DiscoverOnboardingDraftStorage.hasWantsChildrenKey();
    final heightUnitPreference =
        await DiscoverOnboardingDraftStorage.readHeightUnitPreference();

    if (mounted) {
      if (bio != null) _bioController.text = bio;
      final unit = heightUnitPreference == 'ft'
          ? _HeightUnit.footInch
          : _HeightUnit.cm;
      if (heightCm != null) _applyHeightCm(heightCm, unit);
      setState(() {
        _ethnicity = ethnicity;
        _wantsChildren = wantsChildren;
        _wantsChildrenTouched = wantsChildrenKeyExists;
        _heightUnit = unit;
        _isLoadingDraft = false;
      });
    }
  }

  void _applyHeightCm(int heightCm, _HeightUnit unit) {
    if (unit == _HeightUnit.cm) {
      _heightCmController.text = heightCm.toString();
      return;
    }
    final totalInches = heightCm / _cmPerInch;
    final feet = totalInches ~/ _inchesPerFoot;
    final inches = (totalInches - feet * _inchesPerFoot).round();
    _heightFeetController.text = feet.toString();
    _heightInchController.text = inches.toString();
  }

  /// Height SELALU disimpan/dikirim sebagai cm (satu-satunya bentuk yang
  /// backend terima) — null kalau input belum lengkap/tidak valid.
  int? get _heightCm {
    if (_heightUnit == _HeightUnit.cm) {
      return int.tryParse(_heightCmController.text.trim());
    }
    final feet = int.tryParse(_heightFeetController.text.trim());
    final inches = int.tryParse(_heightInchController.text.trim());
    if (feet == null || inches == null) return null;
    return ((feet * _inchesPerFoot + inches) * _cmPerInch).round();
  }

  void _switchHeightUnit(_HeightUnit unit) {
    if (unit == _heightUnit) return;
    final currentCm = _heightCm;
    setState(() {
      _heightUnit = unit;
      _heightCmController.clear();
      _heightFeetController.clear();
      _heightInchController.clear();
      if (currentCm != null) _applyHeightCm(currentCm, unit);
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _heightCmController.dispose();
    _heightFeetController.dispose();
    _heightInchController.dispose();
    super.dispose();
  }

  Map<String, String> _ethnicityOptions(AppLocalizations l10n) => {
    'asian': l10n.ethnicityAsian,
    'black_african_descent': l10n.ethnicityBlackAfricanDescent,
    'hispanic_latino': l10n.ethnicityHispanicLatino,
    'middle_eastern': l10n.ethnicityMiddleEastern,
    'native_american': l10n.ethnicityNativeAmerican,
    'pacific_islander': l10n.ethnicityPacificIslander,
    'south_asian': l10n.ethnicitySouthAsian,
    'white_caucasian': l10n.ethnicityWhiteCaucasian,
    'mixed_multiracial': l10n.ethnicityMixedMultiracial,
    'chinese': l10n.ethnicityChinese,
    'other': l10n.ethnicityOther,
  };

  Future<void> _pickEthnicity() async {
    final l10n = AppLocalizations.of(context);
    final options = _ethnicityOptions(l10n);

    final selected = await showModalBottomSheet<String>(
      context: context,
      // 11 opsi (10 kategori + Chinese) bisa lebih tinggi dari layar
      // pendek — tanpa batas tinggi + scroll, Column overflow (RenderFlex
      // "A RenderFlex overflowed" — user melihat baris terakhir terpotong).
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final entry in options.entries)
                      ListTile(
                        title: Text(entry.value),
                        trailing: _ethnicity == entry.key
                            ? const Icon(
                                Icons.check,
                                color: AppColors.deepViolet,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(entry.key),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _ethnicity = selected;
        _errorText = null;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    final l10n = AppLocalizations.of(context);
    final bio = _bioController.text.trim();
    final heightCm = _heightCm;

    if (bio.isEmpty ||
        heightCm == null ||
        _ethnicity == null ||
        !_wantsChildrenTouched) {
      setState(() => _errorText = l10n.bioAllFieldsRequiredError);
      return;
    }

    await DiscoverOnboardingDraftStorage.saveBio(bio);
    await DiscoverOnboardingDraftStorage.saveHeightCm(heightCm);
    await DiscoverOnboardingDraftStorage.saveEthnicity(_ethnicity);
    await DiscoverOnboardingDraftStorage.saveWantsChildren(_wantsChildren);
    await DiscoverOnboardingDraftStorage.saveHeightUnitPreference(
      _heightUnit == _HeightUnit.footInch ? 'ft' : 'cm',
    );
    if (mounted) context.go('/onboarding/discover/work-education');
  }

  void _backToPhotos() => context.go('/onboarding/discover/photos');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bioLength = _bioController.text.length;
    final ethnicityLabel = _ethnicity != null
        ? _ethnicityOptions(l10n)[_ethnicity]
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToPhotos();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 4,
                totalSteps: 9,
                onBack: _backToPhotos,
              ),
              Expanded(
                child: _isLoadingDraft
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.bioTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.bioSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Stack(
                              children: [
                                TextField(
                                  controller: _bioController,
                                  maxLength: _maxBioLength,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: l10n.bioFieldHint,
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: '',
                                    contentPadding: const EdgeInsets.all(16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.md,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  bottom: 8,
                                  child: Text(
                                    l10n.bioCharCount(bioLength, _maxBioLength),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: bioLength > _maxBioLength * 0.9
                                          ? AppColors.warning
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.bioHeightLabel,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                _HeightUnitToggle(
                                  unit: _heightUnit,
                                  onChanged: _switchHeightUnit,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (_heightUnit == _HeightUnit.cm)
                              _PlainNumberField(
                                hintText: l10n.bioHeightHintCm,
                                controller: _heightCmController,
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: _PlainNumberField(
                                      hintText: l10n.bioHeightHintFeet,
                                      controller: _heightFeetController,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _PlainNumberField(
                                      hintText: l10n.bioHeightHintInch,
                                      controller: _heightInchController,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 14),
                            Text(
                              l10n.bioEthnicityLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickEthnicity,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ethnicityLabel ?? l10n.bioEthnicityHint,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: ethnicityLabel != null
                                              ? AppColors.textDark
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      PhosphorIcons.caretDown(),
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.bioWantsChildrenLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenYes,
                                  selected:
                                      _wantsChildrenTouched &&
                                      _wantsChildren == true,
                                  onSelected: () => setState(() {
                                    _wantsChildren = true;
                                    _wantsChildrenTouched = true;
                                    _errorText = null;
                                  }),
                                ),
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenNo,
                                  selected:
                                      _wantsChildrenTouched &&
                                      _wantsChildren == false,
                                  onSelected: () => setState(() {
                                    _wantsChildren = false;
                                    _wantsChildrenTouched = true;
                                    _errorText = null;
                                  }),
                                ),
                                _ChoiceChipOption(
                                  label: l10n.bioWantsChildrenNotSure,
                                  selected:
                                      _wantsChildrenTouched &&
                                      _wantsChildren == null,
                                  onSelected: () => setState(() {
                                    _wantsChildren = null;
                                    _wantsChildrenTouched = true;
                                    _errorText = null;
                                  }),
                                ),
                              ],
                            ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorText!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.onboardingContinue,
                              onPressed: _saveAndContinue,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Segmented toggle kecil (cm | ft) — cuma ganti UNIT TAMPILAN input,
/// nilai final selalu dikonversi ke cm sebelum disimpan (lihat
/// [_BioStepScreenState._heightCm]).
class _HeightUnitToggle extends StatelessWidget {
  const _HeightUnitToggle({required this.unit, required this.onChanged});

  final _HeightUnit unit;
  final ValueChanged<_HeightUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitOption(
            label: 'cm',
            selected: unit == _HeightUnit.cm,
            onTap: () => onChanged(_HeightUnit.cm),
          ),
          _UnitOption(
            label: 'ft',
            selected: unit == _HeightUnit.footInch,
            onTap: () => onChanged(_HeightUnit.footInch),
          ),
        ],
      ),
    );
  }
}

class _UnitOption extends StatelessWidget {
  const _UnitOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.lilac.withValues(alpha: 0.2) : null,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.deepViolet : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Field angka polos TANPA label sendiri (label sudah dirender terpisah
/// di atas, bareng toggle unit cm/ft) — beda dari `AppTextField` yang
/// selalu render label internal.
class _PlainNumberField extends StatelessWidget {
  const _PlainNumberField({required this.hintText, required this.controller});

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.deepViolet),
        ),
      ),
    );
  }
}

class _ChoiceChipOption extends StatelessWidget {
  const _ChoiceChipOption({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.lilac.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: selected ? AppColors.deepViolet : AppColors.textDark,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        fontSize: 13,
      ),
      side: BorderSide(color: selected ? AppColors.lilac : AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      backgroundColor: Colors.white,
    );
  }
}
