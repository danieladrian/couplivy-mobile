/// Toggle Privacy & Visibility — sumber: `GET`/`PATCH /privacy-settings`.
/// TIDAK di-cache lokal (beda dari [MyProfile]) — halaman ini jarang
/// dibuka dan datanya kecil, network round-trip cukup murah untuk selalu
/// tampilkan state TERBARU (mis. kalau user ubah dari device lain).
class PrivacySettings {
  const PrivacySettings({
    required this.hideProfile,
    required this.showReligion,
    required this.showEthnicity,
    required this.showHeightWeight,
    required this.allowDirectAdd,
    required this.showOnlineStatus,
    required this.aiConversationAssistant,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      hideProfile: json['hide_profile'] as bool,
      showReligion: json['show_religion'] as bool,
      showEthnicity: json['show_ethnicity'] as bool,
      showHeightWeight: json['show_height_weight'] as bool,
      allowDirectAdd: json['allow_direct_add'] as bool,
      showOnlineStatus: json['show_online_status'] as bool,
      aiConversationAssistant: json['ai_conversation_assistant'] as bool,
    );
  }

  final bool hideProfile;
  final bool showReligion;
  final bool showEthnicity;
  final bool showHeightWeight;
  final bool allowDirectAdd;
  final bool showOnlineStatus;
  final bool aiConversationAssistant;

  Map<String, dynamic> toJson() => {
    'hide_profile': hideProfile,
    'show_religion': showReligion,
    'show_ethnicity': showEthnicity,
    'show_height_weight': showHeightWeight,
    'allow_direct_add': allowDirectAdd,
    'show_online_status': showOnlineStatus,
    'ai_conversation_assistant': aiConversationAssistant,
  };

  PrivacySettings copyWith({
    bool? hideProfile,
    bool? showReligion,
    bool? showEthnicity,
    bool? showHeightWeight,
    bool? allowDirectAdd,
    bool? showOnlineStatus,
    bool? aiConversationAssistant,
  }) {
    return PrivacySettings(
      hideProfile: hideProfile ?? this.hideProfile,
      showReligion: showReligion ?? this.showReligion,
      showEthnicity: showEthnicity ?? this.showEthnicity,
      showHeightWeight: showHeightWeight ?? this.showHeightWeight,
      allowDirectAdd: allowDirectAdd ?? this.allowDirectAdd,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      aiConversationAssistant:
          aiConversationAssistant ?? this.aiConversationAssistant,
    );
  }
}
