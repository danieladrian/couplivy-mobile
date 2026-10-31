import 'package:flutter/material.dart';

import '../../core/api/api_exception.dart';
import '../../core/models/privacy_settings.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import 'privacy_setting_repository.dart';

/// "Privacy & Visibility" — 7 toggle, `GET`/`PATCH /privacy-settings`.
/// TIDAK di-cache lokal (lihat dokumentasi `PrivacySettings`) — network
/// call tiap halaman ini dibuka, wajar karena datanya kecil dan jarang
/// dibuka.
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  PrivacySettings? _settings;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final settings = await privacySettingRepository.fetch();
      if (mounted) {
        setState(() {
          _settings = settings;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    }
  }

  /// Optimistic update — toggle langsung berubah di UI, di-PATCH ke
  /// server di background. Gagal? Rollback ke nilai sebelumnya + tampilkan
  /// error, supaya UI tidak pernah "berbohong" soal state tersimpan.
  Future<void> _toggle(PrivacySettings Function(PrivacySettings) apply) async {
    final previous = _settings;
    if (previous == null) return;

    final updated = apply(previous);
    setState(() {
      _settings = updated;
      _errorMessage = null;
    });

    try {
      await privacySettingRepository.update(updated);
    } on ApiException catch (_) {
      if (mounted) {
        setState(() {
          _settings = previous;
          _errorMessage = AppLocalizations.of(context).privacySaveError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = _settings;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        title: Text(
          l10n.privacyTitle,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: _isLoading
          ? const SizedBox.shrink()
          : settings == null
          ? Center(
              child: Text(
                _errorMessage ?? l10n.privacySaveError,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                _switchTile(
                  title: l10n.privacyHideProfileLabel,
                  description: l10n.privacyHideProfileDescription,
                  value: settings.hideProfile,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(hideProfile: value)),
                ),
                _switchTile(
                  title: l10n.privacyShowReligionLabel,
                  description: l10n.privacyShowReligionDescription,
                  value: settings.showReligion,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(showReligion: value)),
                ),
                _switchTile(
                  title: l10n.privacyShowEthnicityLabel,
                  description: l10n.privacyShowEthnicityDescription,
                  value: settings.showEthnicity,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(showEthnicity: value)),
                ),
                _switchTile(
                  title: l10n.privacyShowHeightWeightLabel,
                  description: l10n.privacyShowHeightWeightDescription,
                  value: settings.showHeightWeight,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(showHeightWeight: value)),
                ),
                _switchTile(
                  title: l10n.privacyAllowDirectAddLabel,
                  description: l10n.privacyAllowDirectAddDescription,
                  value: settings.allowDirectAdd,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(allowDirectAdd: value)),
                ),
                _switchTile(
                  title: l10n.privacyShowOnlineStatusLabel,
                  description: l10n.privacyShowOnlineStatusDescription,
                  value: settings.showOnlineStatus,
                  onChanged: (value) =>
                      _toggle((s) => s.copyWith(showOnlineStatus: value)),
                ),
                _switchTile(
                  title: l10n.privacyAiConversationAssistantLabel,
                  description: l10n.privacyAiConversationAssistantDescription,
                  value: settings.aiConversationAssistant,
                  onChanged: (value) => _toggle(
                    (s) => s.copyWith(aiConversationAssistant: value),
                  ),
                  isLast: true,
                ),
              ],
            ),
    );
  }

  Widget _switchTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.deepViolet,
          ),
        ],
      ),
    );
  }
}
