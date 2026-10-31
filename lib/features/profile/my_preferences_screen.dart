import 'package:flutter/material.dart';

import '../../core/models/my_profile.dart';
import '../../core/storage/profile_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../l10n/generated/app_localizations.dart';
import 'edit_preferences_screen.dart';
import 'profile_labels.dart';

/// "My Preferences" — read-only, dari `ProfileDatabase` (database lokal,
/// SQLite via drift — BISA DIBUKA OFFLINE, TIDAK network call setiap
/// dibuka). Dulu SELALU fetch `GET /me` tiap dibuka — diubah supaya
/// konsisten `MyProfileScreen` (baca dari database lokal) sejak
/// `ProfileDatabase` dibuat, lihat .ai/rules/architecture.md.
///
/// Tombol Edit (app bar) buka `EditPreferencesScreen` (UI gaya onboarding
/// step 10, lihat dokumentasi class itu) — WAJIB online (submit ke server
/// dulu, baru update database lokal kalau sukses, lihat
/// `ProfileRepository.updatePreferences()`). Begitu kembali dengan hasil
/// sukses, reload dari `ProfileDatabase` (sudah ter-update oleh submit
/// itu) supaya tampilan read-only ini langsung sinkron.
class MyPreferencesScreen extends StatefulWidget {
  const MyPreferencesScreen({super.key});

  @override
  State<MyPreferencesScreen> createState() => _MyPreferencesScreenState();
}

class _MyPreferencesScreenState extends State<MyPreferencesScreen> {
  MyDatingPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await ProfileDatabase.read();
    if (mounted) {
      setState(() {
        _preferences = profile?.preferences;
        _isLoading = false;
      });
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            EditPreferencesScreen(initialPreferences: _preferences),
      ),
    );
    // EditPreferencesScreen sudah panggil ProfileRepository.
    // updatePreferences() (yang sudah update ProfileDatabase lokal)
    // SEBELUM pop — reload di sini cuma baca ulang dari database lokal
    // itu, TIDAK ada network call tambahan.
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preferences = _preferences;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          l10n.myPreferencesTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _openEdit,
            child: Text(l10n.editLabel),
          ),
        ],
      ),
      body: _isLoading
          ? const SizedBox.shrink()
          : preferences == null
          ? Center(
              child: Text(
                l10n.myPreferencesEmptyMessage,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      _row(
                        l10n.myPreferencesAgeRangeLabel,
                        preferences.ageMin != null && preferences.ageMax != null
                            ? l10n.preferencesAgeRangeLabel(
                                preferences.ageMin!,
                                preferences.ageMax!,
                              )
                            : null,
                      ),
                      _row(
                        l10n.preferencesGenderLabel,
                        preferences.genderPreference != null
                            ? ProfileLabels.genderPreference(
                                l10n,
                                preferences.genderPreference!,
                              )
                            : null,
                      ),
                      _row(
                        l10n.preferencesChildrenLabel,
                        ProfileLabels.joinAll(
                          preferences.childrenPreference,
                          (key) => ProfileLabels.childrenPreference(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesMarriageLabel,
                        ProfileLabels.joinAll(
                          preferences.marriagePreference,
                          (key) => ProfileLabels.marriagePreference(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesEthnicityLabel,
                        ProfileLabels.joinAll(
                          preferences.ethnicityPreference,
                          (key) => ProfileLabels.ethnicity(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesReligionLabel,
                        ProfileLabels.joinAll(
                          preferences.religionPreference,
                          (key) => ProfileLabels.religion(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesEducationLabel,
                        ProfileLabels.joinAll(
                          preferences.educationPreference,
                          (key) => ProfileLabels.education(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesDrinkingLabel,
                        ProfileLabels.joinAll(
                          preferences.drinkingPreference,
                          (key) => ProfileLabels.drinking(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesSmokingLabel,
                        ProfileLabels.joinAll(
                          preferences.smokingPreference,
                          (key) => ProfileLabels.smoking(l10n, key),
                        ),
                      ),
                      _row(
                        l10n.preferencesPetsLabel,
                        ProfileLabels.joinAll(
                          preferences.petPreference,
                          (key) => ProfileLabels.petPreference(l10n, key),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _row(String label, String? value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
          Expanded(
            child: Text(
              value == null || value.isEmpty ? '—' : value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
