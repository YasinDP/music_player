import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/music/widgets/skip_button.dart';
import 'package:music_player/music/widgets/thumbnail_view.dart';

void main() {
  group('AnimatedFavoriteIcon Test', () {
    testWidgets('Renders skip button and check the padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkipButton(
              onTap: () {},
              isForward: true,
            ),
          ),
        ),
      );

      // Find the Container widget with Icon
      final iconFinder =
          find.widgetWithIcon(Container, Icons.forward_10_rounded);

      // Expect the container's total horizontal padding
      final container = tester.firstWidget<Container>(iconFinder);
      expect(container.padding?.horizontal, equals(16));
    });

    testWidgets('Thumbnail view by asset path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              radius: 32,
              child: ThumbnailView(
                  imageUrl: "assets/images/thumbnails/bb-love-me.jfif",
                  imageBytes: null,
                  isAsset: true),
            ),
          ),
        ),
      );

      // Find the Image widget
      final imageFinder = find.byType(Image);
      final image = tester.firstWidget<Image>(imageFinder);

      // Expect the correct image fit
      expect(image.fit, BoxFit.cover);
    });
  });
}
