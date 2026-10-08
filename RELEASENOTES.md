## 0.25.0



feature: make NSLocale a self-contained, ICU-free locale implementation

* NSLocale now derives locale keys (languageCode, countryCode, scriptCode,
  variantCode, collatorIdentifier, measurementSystem, usesMetricSystem,
  quotation delimiters, calendarIdentifier) from the identifier itself,
  with no ICU dependency
* add +preferredLanguages, +availableLocaleIdentifiers, +ISOLanguageCodes,
  +ISOCountryCodes, +ISOCurrencyCodes
* add +componentsFromLocaleIdentifier:, +localeIdentifierFromComponents:,
  +canonicalLocaleIdentifierFromString: and +canonicalLanguageIdentifierFromString:
* add +characterDirectionForLanguage: and +lineDirectionForLanguage:
* -objectForKey: is now thread-safe; -isEqualToLocale: compares canonical
  identifiers, so `en_US,` en-US and `en_US.UTF-8` are equal
* NSLocaleCalendar and NSLocaleExemplarCharacterSet deliberately answer nil
* fix NSScanner -scanLocation returning 0 and ignoring the setter; the cursor
  is now the scanLocation ivar, so reading reports the position and setting it
  backtracks as documented
* fix `-[_MulleObjCLocalTimeZone]` to reflect the current default time zone
* export MulleUTF8StringEscape/Unescape and the percent-escape helpers


## 0.24.0


feature: add dateFormatterWithDateFormat factory method

* new `+dateFormatterWithDateFormat:allowNaturalLanguage:` class method on NSDateFormatter, mirroring the existing initializer


## 0.23.0


feature: mark NSLocale Future category as MulleObjCFuture

* NSLocale( Future) category now conforms to MulleObjCFuture protocol
* explicit marker for future API on NSLocale
