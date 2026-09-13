import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/shared/widgets/matching_loading_overlay.dart';

void main() {
  testWidgets('show() displays a non-dismissible modal with 2 heart icons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => MatchingLoadingOverlay.show(context),
            child: const Text('Trigger'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Trigger'));
    await tester.pump();

    expect(find.byType(Icon), findsNWidgets(2));

    // Non-dismissible — tap di luar (barrier) TIDAK menutup modal.
    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    expect(find.byType(Icon), findsNWidgets(2));
  });

  testWidgets('hide() closes the modal', (WidgetTester tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return ElevatedButton(
              onPressed: () => MatchingLoadingOverlay.show(context),
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.byType(Icon), findsNWidgets(2));

    // hide() dipanggil langsung dengan context yang ditangkap SEBELUM
    // modal terbuka — bukan lewat tap tombol lain, karena modal
    // full-screen non-dismissible menyerap semua tap di baliknya
    // (termasuk ke tombol lain), jadi trigger via tap tidak
    // merepresentasikan pemanggilan hide() yang sesungguhnya (dipanggil
    // dari kode Dart setelah request selesai, bukan dari tap user).
    //
    // TIDAK pakai pumpAndSettle — animasi heart loop terus (`..repeat()`),
    // jadi tidak akan pernah "settle".
    MatchingLoadingOverlay.hide(capturedContext);
    await tester.pump();
    expect(find.byType(Icon), findsNothing);
  });
}
