import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/onboarding_step_header.dart';
import 'discover_onboarding_draft_storage.dart';

const _maxPhotoSlots = 6;

/// Step 3/9 onboarding Discover — sumber:
/// couplivy-docs/flow/01-discover/onboarding/04-photos.html. Required,
/// minimal 1 foto utama.
///
/// Tap slot kosong buka bottom sheet pilihan sumber — Kamera atau Galeri.
/// Foto DI-COPY ke temp dir aplikasi (path lokal disimpan di draft) —
/// TIDAK di-upload sekarang. Upload sungguhan (multipart) baru terjadi di
/// step Preview (terakhir), bersamaan dengan submit field profil lain.
/// Lihat .ai/rules/architecture.md.
class PhotosStepScreen extends StatefulWidget {
  const PhotosStepScreen({super.key});

  @override
  State<PhotosStepScreen> createState() => _PhotosStepScreenState();
}

class _PhotosStepScreenState extends State<PhotosStepScreen> {
  final _picker = ImagePicker();
  List<String> _photoPaths = [];
  bool _isLoadingDraft = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final saved = await DiscoverOnboardingDraftStorage.readPhotoPaths();
    if (mounted) setState(() => _photoPaths = saved);
    if (mounted) setState(() => _isLoadingDraft = false);
  }

  Future<void> _addPhoto() async {
    final source = await _pickSource();
    if (source == null) return;

    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    // Copy ke temp dir aplikasi — file asli di galeri device bisa
    // dihapus/dipindah user kapan saja, jadi kita butuh salinan stabil
    // yang cuma aplikasi ini yang pegang, sampai di-upload nanti di step
    // Preview.
    final tempDir = await getTemporaryDirectory();
    final extension = p.extension(picked.path);
    final destination = p.join(
      tempDir.path,
      'onboarding_photo_${DateTime.now().microsecondsSinceEpoch}$extension',
    );
    await File(picked.path).copy(destination);

    final updated = [..._photoPaths, destination];
    setState(() {
      _photoPaths = updated;
      _errorText = null;
    });
    await DiscoverOnboardingDraftStorage.savePhotoPaths(updated);
  }

  /// Bottom sheet pilihan sumber foto — Kamera atau Galeri. Sesuai brand-
  /// guideline §9.2c (select dibuka sebagai bottom sheet, bukan native
  /// dropdown/dialog).
  Future<ImageSource?> _pickSource() {
    final l10n = AppLocalizations.of(context);

    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(
                  PhosphorIcons.camera(),
                  color: AppColors.deepViolet,
                ),
                title: Text(l10n.photosSourceCamera),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  PhosphorIcons.image(),
                  color: AppColors.deepViolet,
                ),
                title: Text(l10n.photosSourceGallery),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removePhoto(int index) async {
    final updated = [..._photoPaths]..removeAt(index);
    setState(() => _photoPaths = updated);
    await DiscoverOnboardingDraftStorage.savePhotoPaths(updated);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (_photoPaths.isEmpty) {
      setState(() => _errorText = l10n.photosMinimumError);
      return;
    }
    if (mounted) context.go('/onboarding/discover/bio');
  }

  void _backToGender() => context.go('/onboarding/discover/gender');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToGender();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingStepHeader(
                step: 3,
                totalSteps: 9,
                onBack: _backToGender,
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
                              l10n.photosTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.photosSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _maxPhotoSlots,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 3 / 4,
                                  ),
                              itemBuilder: (context, index) {
                                final hasPhoto = index < _photoPaths.length;
                                // Slot terisi harus berurutan dari kiri-atas
                                // (index 0) — hanya slot kosong PERTAMA yang
                                // bisa di-tap. Tanpa ini, tap di slot mana
                                // pun (misal slot ke-4) tetap menambah foto
                                // ke akhir _photoPaths, tapi tampil nempel
                                // di slot kosong paling awal — user jadi
                                // bingung foto yang dia pilih "pindah" ke
                                // slot lain.
                                final isNextEmptySlot =
                                    index == _photoPaths.length;
                                return _PhotoSlot(
                                  path: hasPhoto ? _photoPaths[index] : null,
                                  isMain: index == 0,
                                  isEnabled: hasPhoto || isNextEmptySlot,
                                  mainLabel: l10n.photosMainPhotoLabel,
                                  onTap: hasPhoto
                                      ? null
                                      : (isNextEmptySlot ? _addPhoto : null),
                                  onRemove: hasPhoto
                                      ? () => _removePhoto(index)
                                      : null,
                                );
                              },
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
                              onPressed: _submit,
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

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.path,
    required this.isMain,
    required this.isEnabled,
    required this.mainLabel,
    required this.onTap,
    required this.onRemove,
  });

  final String? path;
  final bool isMain;
  // false untuk slot kosong yang belum gilirannya diisi (mis. slot 4
  // selagi slot 2-3 masih kosong) — dibuat redup + tidak bisa di-tap,
  // supaya urutan pengisian slot terlihat jelas.
  final bool isEnabled;
  final String mainLabel;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return Opacity(
        opacity: isEnabled ? 1 : 0.4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: DottedBorderBox(
            child: Icon(
              PhosphorIcons.plus(),
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Image.file(File(path!), fit: BoxFit.cover),
        ),
        if (isMain)
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                mainLabel,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        Positioned(
          right: 4,
          top: 4,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// Border putus-putus sederhana untuk slot foto kosong — dibuat inline
/// (bukan pakai package tambahan) supaya tidak nambah dependency baru
/// cuma untuk 1 visual kecil.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border, width: 1.5),
        color: Colors.white,
      ),
      child: Center(child: child),
    );
  }
}
