import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Field nomor HP dengan country code picker — TIDAK hardcode +62, app
/// multi-negara (rencana ekspansi Malaysia/Filipina/Vietnam, dst). Nilai
/// dial code dilaporkan lewat [onCountryChanged], gabungkan dengan isi
/// [controller] jadi format E.164 sebelum dikirim ke backend.
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.label,
    required this.controller,
    required this.onCountryChanged,
    this.errorText,
    String? initialCountryCode,
  }) : _initialCountryCodeOverride = initialCountryCode;

  final String label;
  final TextEditingController controller;

  /// Dipanggil setiap user MEMILIH negara baru dari dropdown, DAN sekali
  /// di awal saat picker pertama kali render dengan pilihan default-nya
  /// (lewat `onInit` bawaan CountryCodePicker) — supaya dial code yang
  /// disimpan parent (mis. _dialCode di SignUpScreen) selalu sinkron
  /// dengan yang ditampilkan, walau user tidak pernah sentuh dropdown.
  final ValueChanged<CountryCode> onCountryChanged;
  final String? errorText;
  final String? _initialCountryCodeOverride;

  /// Default country code: ikut BAHASA device (bukan region/GPS/IP) —
  /// kalau bahasa device Indonesia ("id"), default +62; selain itu
  /// fallback ke US (+1). Sama sumbernya dengan locale yang dikirim ke
  /// backend saat Sign Up (lihat Localizations.localeOf di
  /// sign_up_screen.dart) — konsisten 1 sumber kebenaran. User tetap bisa
  /// ganti manual lewat dropdown.
  static String _resolveDefaultCountryCode(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'id' ? 'ID' : 'US';
  }

  @override
  Widget build(BuildContext context) {
    final initialCountryCode =
        _initialCountryCodeOverride ?? _resolveDefaultCountryCode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              CountryCodePicker(
                onChanged: onCountryChanged,
                // Sinkronkan state parent dengan pilihan default begitu
                // picker pertama render — tanpa ini, dial code yang
                // dikirim ke backend bisa beda dari yang ditampilkan
                // kalau user tidak pernah sentuh dropdown.
                onInit: (code) {
                  // onInit dipanggil dari didChangeDependencies SAAT
                  // widget ini pertama kali di-build — memanggil
                  // onCountryChanged (yang biasanya setState() di parent)
                  // di titik itu akan error "setState() called during
                  // build". Tunda ke frame berikutnya lewat
                  // addPostFrameCallback supaya aman.
                  if (code == null) return;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onCountryChanged(code);
                  });
                },
                initialSelection: initialCountryCode,
                favorite: const ['+62', 'ID', '+1', 'US'],
                showFlag: true,
                showDropDownButton: true,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(
                height: 24,
                child: VerticalDivider(color: AppColors.border, width: 1),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '812 xxxx xxxx',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
