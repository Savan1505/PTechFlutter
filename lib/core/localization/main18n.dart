import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/io/import.dart';

class AppI18n {
  static TranslationsByLocale translations = Translations.byLocale('en_us');

  static Future<void> loadTranslations() async {
    translations += await JSONImporter().fromAssetDirectory('assets/translations');
  }
}

extension Localization on String {
  String get i18n => localize(this, AppI18n.translations);

  String plural(value) => localizePlural(value, this, AppI18n.translations);

  String fill(List<Object> params) => localizeFill(this, params);
}
