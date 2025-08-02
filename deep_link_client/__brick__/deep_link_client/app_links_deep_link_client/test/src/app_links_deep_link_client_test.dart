// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:app_links_deep_link_client/app_links_deep_link_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLinks extends Mock implements AppLinks {}

void main() {
  late MockAppLinks appLinks;
  late AppLinksDeepLinkClient appLinksDeepLinkClient;
  late StreamController<Uri> onLinkStreamController;

  setUp(() {
    appLinks = MockAppLinks();
    appLinksDeepLinkClient = AppLinksDeepLinkClient(appLinks: appLinks);
    onLinkStreamController = StreamController<Uri>();
    when(
      () => appLinks.uriLinkStream,
    ).thenAnswer((_) => onLinkStreamController.stream);
  });

  tearDown(() {
    onLinkStreamController.close();
  });

  group('AppLinksDeepLinkClient', () {
    group('getInitialLink', () {
      test('returns the initial link if available', () async {
        final expectedUri = Uri.parse('https://example.com/initial');
        when(
          () => appLinks.getInitialLink(),
        ).thenAnswer((_) async => expectedUri);

        final initialLink = await appLinksDeepLinkClient.getInitialLink();

        expect(initialLink, equals(expectedUri));
      });

      test('returns null if no initial link is available', () async {
        when(() => appLinks.getInitialLink()).thenAnswer((_) async => null);

        final initialLink = await appLinksDeepLinkClient.getInitialLink();

        expect(initialLink, isNull);
      });
    });

    group('deepLinkStream', () {
      test('returns the deep link stream', () {
        expect(appLinksDeepLinkClient.deepLinkStream, isA<Stream<Uri>>());
      });

      test('publishes values received through onLink stream', () {
        final expectedUri1 = Uri.https('news.app.test', '/test/1');
        final expectedUri2 = Uri.https('news.app.test', '/test/2');

        onLinkStreamController
          ..add(expectedUri1)
          ..add(expectedUri1)
          ..add(expectedUri2)
          ..add(expectedUri1);

        expect(
          appLinksDeepLinkClient.deepLinkStream,
          emitsInOrder(
            <Uri>[expectedUri1, expectedUri1, expectedUri2, expectedUri1],
          ),
        );
      });
    });
  });
}
