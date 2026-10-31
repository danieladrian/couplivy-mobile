import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import 'app_button.dart';

/// Row select — icon + label + value (rata kanan, ellipsis kalau
/// panjang) + chevron, tap untuk buka bottom sheet pilihan. Dipakai di
/// step Preferences (Gender/Family/Religion/Education), Lifestyle
/// (Drinking/Smoking/Pets), dan Future (Children/Marriage) — extracted
/// dari `_PreferenceRow` privat di `preferences_step_screen.dart` supaya
/// tidak diduplikasi di step-step baru.
class PreferenceRow extends StatelessWidget {
  const PreferenceRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final PhosphorIconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.deepViolet),
            const SizedBox(width: 12),
            // Lebar TETAP (bukan cuma Text polos) — supaya kolom value +
            // chevron mulai dari titik X yang SAMA di semua row, terlepas
            // dari panjang label ("Gender" vs "Family Preferences").
            // Spacer saja TIDAK CUKUP: dia cuma dorong sisa konten ke
            // kanan, jadi titik mulainya tetap ikut lebar label.
            SizedBox(
              width: 130,
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            // Flexible + ellipsis — value bisa jadi ringkasan panjang
            // untuk field MULTI-select (mis. "Christian, Muslim,
            // Buddhist"), Text polos tanpa constraint bisa overflow
            // horizontal.
            Expanded(
              child: Text(
                value ?? '—',
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet single-select generik — dipakai `PreferenceRow` (dan
/// pola serupa di Ethnicity/Religion/Education Bio & Work/Education
/// step, yang masing-masing punya salinan sendiri sebelum widget ini
/// ada). Height DIBATASI + `ListView` scrollable (bukan `Column` biasa)
/// karena daftar opsi bisa lebih tinggi dari layar pendek.
Future<String?> showSingleSelectSheet(
  BuildContext context,
  Map<String, String> options,
  String? current,
) {
  return showModalBottomSheet<String>(
    context: context,
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
                      trailing: current == entry.key
                          ? const Icon(Icons.check, color: AppColors.deepViolet)
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
}

/// Key opsi "Open for all" — EXCLUSIVE (lihat [showMultiSelectSheet]).
const openForAllKey = 'open_for_all';

/// Bottom sheet MULTI-select (checkbox) generik — diekstrak dari
/// `PreferencesStepScreen._showMultiSelectSheet` (step 10 onboarding)
/// supaya bisa dipakai ulang di `EditPreferencesScreen` (My Preferences,
/// setelah onboarding) TANPA duplikasi logic "open_for_all" exclusive.
/// "open_for_all" (kalau ADA di [options], SELALU opsi TERAKHIR secara
/// urutan Map) bersifat EXCLUSIVE — pilih itu otomatis uncheck semua
/// opsi lain (karena sudah mencakup semua), dan pilih opsi spesifik lain
/// otomatis uncheck "open_for_all". Mencegah kombinasi rancu seperti
/// "Open for all + Christian".
Future<Set<String>?> showMultiSelectSheet(
  BuildContext context,
  Map<String, String> options,
  Set<String> current,
) {
  var selection = {...current};

  return showModalBottomSheet<Set<String>>(
    context: context,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.7,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          void toggle(String key) {
            setSheetState(() {
              if (key == openForAllKey) {
                selection = selection.contains(openForAllKey)
                    ? {}
                    : {openForAllKey};
              } else if (selection.contains(key)) {
                selection.remove(key);
              } else {
                selection
                  ..remove(openForAllKey)
                  ..add(key);
              }
            });
          }

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
                        CheckboxListTile(
                          title: Text(entry.value),
                          value: selection.contains(entry.key),
                          activeColor: AppColors.deepViolet,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (_) => toggle(entry.key),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: AppButton(
                    label: AppLocalizations.of(context).onboardingContinue,
                    onPressed: () => Navigator.of(context).pop(selection),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
