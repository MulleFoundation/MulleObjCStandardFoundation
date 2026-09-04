# MulleObjCStandardFoundation Library Documentation for AI
<!-- Keywords: foundation, objc, exception, notification, locale, formatter, undo -->

## 1. Introduction & Purpose

**MulleObjCStandardFoundation** provides the core collection of Objective-C Foundation classes implementing C standard library abstractions in an object-oriented manner. It aggregates functionality from lower-level Foundation components and adds these local classes:

- **NSCharacterSet**: Unicode character classification and set operations (`<ctype.h>` abstraction)
- **NSCalendarDate**: Date with calendar/timezone context and component access
- **NSDateFormatter**: NSDate ↔ NSString conversion with format strings
- **NSException & NSError**: Exception throwing and error representation
- **NSLocale**: Localization and region-specific data
- **NSNotification & NSNotificationCenter**: Publish-subscribe messaging
- **NSAssertionHandler**: Assertion failure handling
- **NSScanner**: Structured text parsing into typed values
- **NSUndoManager**: Undo/redo operation sequences
- **NSSortDescriptor**: Key-based sort ordering for arrays
- **NSNumberFormatter**: NSNumber ↔ NSString conversion with formatting
- **NSTimeZone**: Timezone representation with DST and abbreviation support
- **NSFormatter**: Abstract base class for all formatters

## 2. Key Concepts & Design Philosophy

### Foundation as Standard Library Abstraction
Translates C standard library concepts into an object-oriented Objective-C interface, providing type-safe wrappers around lower-level C functionality.

### MulleObjCFuture Protocol
Interfaces and methods marked with `<MulleObjCFuture>` protocol on a category (e.g., `NSCalendarDate(Future) <MulleObjCFuture>`) indicate APIs that are planned but may not be fully implemented yet. They should be used with caution and may have incomplete behavior. The stable API is the main `@interface` without the `Future` category.

### Class Cluster Pattern
NSCharacterSet uses the class cluster pattern with optimized internal subclasses:
- `_MulleObjCCheatingASCIICharacterSet` — fast ASCII-only optimization
- `_MulleObjCConcreteBitmapCharacterSet` — for large/dense sets
- `_MulleObjCConcreteRangeCharacterSet` — for sparse Unicode ranges
- `_MulleObjCConcreteInvertedCharacterSet` — for inverted sets

### Immutability by Default
Classes follow the mulle-objc convention: immutable variants are the primary public interface (e.g., `MulleObjCImmutableProtocols`). Mutable variants available when needed.

### Thread Safety Annotations
Classes are explicitly annotated with thread-safety protocols:
- `<MulleObjCThreadSafe>` — NSNotificationCenter (internally locked)
- `<MulleObjCThreadUnsafe>` — NSUndoManager, NSFormatter
- Unannotated — NSException, NSError, NSLocale (not thread-safe by default)

### Layered Aggregation
Composes foundational types from dependency libraries:
- Value types (NSNumber, NSString, NSData) from **MulleObjCValueFoundation**
- Containers (NSArray, NSDictionary, NSSet) from **MulleObjCContainerFoundation**
- Time types (NSDate) from **MulleObjCTimeFoundation**

## 3. Core API & Data Structures

### 3.1. NSCharacterSet (`src/Value/NSCharacterSet.h`)

Represents an immutable set of Unicode characters for membership testing.

```objc
@interface NSCharacterSet : NSObject < NSCopying, MulleObjCClassCluster>

- (instancetype) initWithBitmapRepresentation:(NSData *) data;

- (NSData *) bitmapRepresentation;
- (BOOL) isSupersetOfSet:(NSCharacterSet *) set;
- (BOOL) longCharacterIsMember:(long) c;

+ (instancetype) characterSetWithCharactersInString:(NSString *) s;

+ (instancetype) alphanumericCharacterSet;
+ (instancetype) controlCharacterSet;
+ (instancetype) capitalizedLetterCharacterSet;
+ (instancetype) decimalDigitCharacterSet;
+ (instancetype) letterCharacterSet;
+ (instancetype) lowercaseLetterCharacterSet;
+ (instancetype) punctuationCharacterSet;
+ (instancetype) symbolCharacterSet;
+ (instancetype) uppercaseLetterCharacterSet;
+ (instancetype) whitespaceAndNewlineCharacterSet;
+ (instancetype) whitespaceCharacterSet;

- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                        plane:(NSUInteger) plane;
@end
```

**Future/Subclass API** (marked `<MulleObjCFuture>`, may be incomplete):
```objc
@interface NSCharacterSet( SubclassesFuture) < MulleObjCFuture>
- (BOOL) characterIsMember:(unichar) c;
- (BOOL) hasMemberInPlane:(NSUInteger) plane;
- (NSCharacterSet *) invertedSet;
@end
```

Also `NSMutableCharacterSet` in `src/Value/NSMutableCharacterSet.h` with:
- `- addCharactersInString:(NSString *) str`
- `- removeCharactersInString:(NSString *) str`
- `- addCharactersInRange:(NSRange) range`
- `- removeCharactersInRange:(NSRange) range`
- `- formUnionWithCharacterSet:(NSCharacterSet *) set`
- `- formIntersectionWithCharacterSet:(NSCharacterSet *) set`
- `- invert`

Performance: `characterIsMember:` is O(1) for bitmap sets, O(log n) for range sets. Bitmap is ~8KB for full Unicode.

### 3.2. NSScanner (`src/Value/NSScanner.h`)

Parses structured text from an NSString, advancing through input and extracting typed values.

```objc
@interface NSScanner : NSObject <NSObject, NSCopying>

@property( retain) NSCharacterSet                                *charactersToBeSkipped;
@property( retain) NSLocale                                      *locale;
@property( getter=caseSensitive,setter=setCaseSensitive:) BOOL   isCaseSensitive;
@property( assign) NSUInteger                                    scanLocation;

+ (instancetype) scannerWithString:(NSString *)string;
- (instancetype) initWithString:(NSString *)string;

- (NSString *) string;
- (NSString *) mulleUnscannedString;
- (BOOL) isAtEnd;

- (BOOL) scanCharactersFromSet:(NSCharacterSet *) charset
                     intoString:(NSString **) stringp;
- (BOOL) scanUpToCharactersFromSet:(NSCharacterSet *)charset
                        intoString:(NSString **)stringp;
- (BOOL) mulleScanUpToAndIncludingString:(NSString *) string
                              intoString:(NSString **) stringp;
- (BOOL) scanUpToString:(NSString *) string
             intoString:(NSString **) stringp;
- (BOOL) scanString:(NSString *) string
         intoString:(NSString **) stringp;

- (BOOL) scanInt:(int *)valuep;
- (BOOL) scanInteger:(NSInteger *)valuep;
- (BOOL) scanLongLong:(long long *)valuep;
- (BOOL) scanFloat:(float *)valuep;
- (BOOL) scanDouble:(double *)valuep;
- (BOOL) scanHexInt:(unsigned *)valuep;
@end
```

Linear O(n) per operation in characters consumed. Returns BOOL; modifies `scanLocation` on success, silently fails otherwise. `mulleScanUpToAndIncludingString:` is a mulle extension not in Apple Foundation.

#### NSScanner+NSLocale (`src/Locale/NSScanner+NSLocale.h`)

```objc
@interface NSScanner( NSLocale)
+ (instancetype) localizedScannerWithString:(NSString *) string;
@end
```

### 3.3. NSFormatter (`src/Value/NSFormatter.h`)

Abstract base class for all formatters (NSDateFormatter, NSNumberFormatter).

```objc
@interface NSFormatter : NSObject < MulleObjCThreadUnsafe>

- (NSString *) editingStringForObjectValue:(id) obj;
- (BOOL) getObjectValue:(id *) obj
              forString:(NSString *) s
       errorDescription:(NSString **) error;
- (BOOL) isPartialStringValid:(NSString *) s
             newEditingString:(NSString **) newString
             errorDescription:(NSString **) error;
- (BOOL) isPartialStringValid:(NSString **) s_p
        proposedSelectedRange:(NSRange *) range_p
               originalString:(NSString *) origString
        originalSelectedRange:(NSRange) origSelRange
             errorDescription:(NSString **) error;
- (NSString *) stringForObjectValue:(id) obj;
@end
```

### 3.4. NSCalendarDate (`src/Date/NSCalendarDate.h`)

A timezone-aware date representation with calendar component access. Always carries a timezone.

```objc
@interface NSCalendarDate : NSDate < NSDateFactory, MulleObjCClassCluster, MulleObjCValueProtocols>

+ (instancetype) calendarDate;
+ (instancetype) dateWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour
                       minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) aTimeZone;
- (instancetype) initWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) aTimeZone;
- (NSString *) calendarFormat;
- (instancetype) mulleInitWithMiniTM:(struct mulle_mini_tm) tm
                            timeZone:(NSTimeZone *) tz;
@end
```

**Subclass access** (`<MulleObjCFuture>`, for subclass use only):
```objc
@interface NSCalendarDate( Subclasses) < MulleObjCFuture>
- (struct mulle_mini_tm) mulleMiniTM;
- (NSInteger) secondOfMinute;
- (NSInteger) minuteOfHour;
- (NSInteger) hourOfDay;
- (NSInteger) dayOfMonth;
- (NSInteger) monthOfYear;
- (NSInteger) yearOfCommonEra;
- (NSTimeZone *) timeZone;
- (BOOL) isEqualToCalendarDate:(NSCalendarDate *) date;
@end
```

**Future API** (`<MulleObjCFuture>`, may be incomplete):
```objc
@interface NSCalendarDate( Future) < MulleObjCFuture>
- (instancetype) initWithDate:(NSDate *) date;
- (instancetype) mulleInitWithDate:(NSDate *) date timeZone:(NSTimeZone *) tz;
- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) timeInterval;
- (instancetype) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval) timeInterval;
- (NSInteger) dayOfWeek;
- (NSInteger) dayOfYear;
- (instancetype) dateByAddingYears:(NSInteger) year months:(NSInteger) month
                              days:(NSInteger) day hours:(NSInteger) hour
                           minutes:(NSInteger) minute seconds:(NSInteger) second;
- (NSDate *) date;
@end
```

The `mulle_mini_tm` struct (from `mulle-mini-tm.h`) is a calendar-oriented time representation.

### 3.5. NSDateFormatter (`src/Date/NSDateFormatter.h`)

Converts bidirectionally between NSDate and NSString. Not re-entrant.

```objc
@interface NSDateFormatter : NSFormatter

@property( retain) NSTimeZone   *timeZone;
@property( retain) NSLocale     *locale;
@property( copy)   NSString     *dateFormat;
@property( readonly) BOOL       allowsNaturalLanguage;
@property( assign, getter=isLenient) BOOL  lenient;

- (instancetype) initWithDateFormat:(NSString *) format
               allowNaturalLanguage:(BOOL) flag;

+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior;
+ (NSDateFormatterBehavior) defaultFormatterBehavior;
- (void) setFormatterBehavior:(NSDateFormatterBehavior) behavior;
- (NSDateFormatterBehavior) formatterBehavior;
- (BOOL) generatesCalendarDates;
- (void) setGeneratesCalendarDates:(BOOL) flag;

+ (void) mulleSetClass:(Class) cls
  forFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior;
@end
```

**Future API** (`<MulleObjCFuture>`, conversion methods):
```objc
@interface NSDateFormatter( Future) < MulleObjCFuture>
- (instancetype) _initWithDateFormat:(NSString *) format
                allowNaturalLanguage:(BOOL) flag;
- (NSDate *) dateFromString:(NSString *) s;
- (NSString *) stringFromDate:(NSDate *) date;
- (BOOL) getObjectValue:(id *) obj
              forString:(NSString *) string
                  range:(NSRange *) rangep
                  error:(NSError **) error;
@end
```

Global format strings: `MulleDateFormatISO` (`@"%Y-%m-%dT%H:%M:%S:%z"`), `MulleDateFormatISOWithMilliseconds`.

#### NSDate+NSDateFormatter (`src/Date/NSDate+NSDateFormatter.h`)

```objc
@interface NSDate( NSDateFormatter)
+ (instancetype) dateWithString:(NSString *) aString;
- (instancetype) initWithString:(NSString *) description;
- (NSString *) descriptionWithLocale:(NSLocale *) locale;
- (NSString *) descriptionWithCalendarFormat:(NSString *) format
                                    timeZone:(NSTimeZone *) aTimeZone
                                      locale:(id) locale;
@end
```

#### NSCalendarDate+NSDateFormatter (`src/Date/NSCalendarDate+NSDateFormatter.h`)

```objc
@interface NSCalendarDate( NSDateFormatter)
+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(NSLocale *) locale;
+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format;
- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(id) locale;
- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format;
- (instancetype) initWithString:(NSString *) s;
- (NSString *) descriptionWithCalendarFormat:(NSString *) format;
- (NSString *) descriptionWithCalendarFormat:(NSString *) format
                                      locale:(id) locale;
@end
```

#### NSDate+NSCalendarDate (`src/Date/NSDate+NSCalendarDate.h`)

```objc
@interface NSDate( NSCalendarDate)
- (NSCalendarDate *) calendarDateWithTimeZone:(NSTimeZone *) tz;
- (NSCalendarDate *) dateWithCalendarFormat:(NSString *) format
                                   timeZone:(NSTimeZone *) aTimeZone;
@end
```

### 3.6. NSTimeZone (`src/TimeZone/NSTimeZone.h`)

Timezone representation with DST support. Not functional on its own; requires category implementations from platform-specific code.

```objc
@interface NSTimeZone : NSObject < MulleObjCInvariant, MulleObjCImmutableProtocols>

+ (instancetype) timeZoneWithName:(NSString *) name;
+ (instancetype) timeZoneWithName:(NSString *) name data:(NSData *) data;
- (instancetype) initWithName:(NSString *) name data:(NSData *) data;

+ (instancetype) timeZoneWithAbbreviation:(NSString *) abbreviation;
+ (NSTimeZone *) timeZoneForSecondsFromGMT:(NSInteger) seconds;

- (NSString *) name;
- (NSData *) data;

+ (NSTimeZone *) systemTimeZone;
+ (void) resetSystemTimeZone;
+ (NSTimeZone *) defaultTimeZone;
+ (void) setDefaultTimeZone:(NSTimeZone *) tz;
+ (NSTimeZone *) localTimeZone;

- (BOOL) isEqualToTimeZone:(NSTimeZone *) tz;
- (NSInteger) secondsFromGMT;
- (NSString *) abbreviation;
- (BOOL) isDaylightSavingTime;

+ (NSTimeZone *) mulleGMTTimeZone;
@end
```

**Future API** (`<MulleObjCFuture>`):
```objc
@interface NSTimeZone( Future) < MulleObjCFuture>
- (instancetype) initWithName:(NSString *) name;
- (instancetype) timeZoneForSecondsFromGMT:(NSInteger) seconds;

+ (NSTimeZone *) _uncachedSystemTimeZone;
+ (NSArray *) knownTimeZoneNames;
+ (NSDictionary *) abbreviationDictionary;

- (NSInteger) mulleSecondsFromGMTForTimeIntervalSince1970:(NSTimeInterval) interval;
- (NSInteger) secondsFromGMTForDate:(NSDate *) date;
- (NSString *) abbreviationForDate:(NSDate *) aDate;
- (BOOL) isDaylightSavingTimeForDate:(NSDate *) aDate;
@end
```

### 3.7. NSException (`src/Exception/NSException.h`)

Throwable exception object with name/reason/userInfo. Supports `+ raise:format:...` for immediate throw.

```objc
@interface NSException : NSObject < MulleObjCException, MulleObjCImmutableProtocols>

+ (NSException *) exceptionWithName:(NSString *) name
                             reason:(NSString *) reason
                           userInfo:(id) userInfo;

+ (void) raise:(NSString *) name
        format:(NSString *) format
mulleVarargList:(mulle_vararg_list) args;
+ (void) raise:(NSString *) name
        format:(NSString *) format
     arguments:(va_list) va;
+ (void) raise:(NSString *) name
        format:(NSString *) format, ...;

- (instancetype) initWithName:(NSString *) name
                       reason:(NSString *) reason
                     userInfo:(NSDictionary *) userInfo;
- (NSString *) name;
- (NSString *) reason;
- (id) userInfo;
@end
```

Standard exception name globals: `NSInternalInconsistencyException`, `NSGenericException`, `NSInvalidArgumentException`, `NSMallocException`, `NSRangeException`, `NSParseErrorException`.

Macros: `NS_DURING` / `NS_HANDLER` / `NS_ENDHANDLER` / `NS_VALUERETURN(v,t)` / `NS_VOIDRETURN`.

### 3.8. NSError (`src/Exception/NSError.h`)

Recoverable error object with domain/code/userInfo. Supports thread-local error storage pattern via `mulleExtract`.

```objc
@interface NSError : NSObject < MulleObjCImmutableProtocols>

@property( readonly, copy)   NSString       *domain;
@property( readonly)         NSInteger      code;
@property( readonly, retain) id             userInfo;

+ (void) registerErrorDomain:(NSString *) domain
         errorStringFunction:(NSString *(*)( NSInteger)) translator;
+ (void) removeErrorDomain:(NSString *) domain;

- (instancetype) initWithDomain:(NSString *) domain
                           code:(NSInteger) code
                       userInfo:(NSDictionary *) userInfo;
+ (instancetype) errorWithDomain:(NSString *) domain
                            code:(NSInteger) code
                        userInfo:(NSDictionary *) userInfo;

- (NSString *) localizedDescription;
- (NSString *) localizedFailureReason;
- (NSString *) localizedRecoverySuggestion;
- (NSString *) localizedRecoveryOptions;
- (id) recoveryAttempter;
- (NSString *) helpAnchor;

// Thread-local error pattern (mulle extension)
+ (void) mulleSetErrorDomain:(NSString *) domain;
+ (NSString *) mulleErrorDomain;
+ (void) mulleSetError:(NSError *) error;
+ (void) mulleSetErrorCode:(NSInteger) code
                    domain:(NSString *) domain
                  userInfo:(NSDictionary *) userInfo;
+ (instancetype) mulleExtract;
+ (void) mulleClear;
+ (void) mulleSetGenericErrorWithDomain:(NSString *) domain
                   localizedDescription:(NSString *) s;
+ (instancetype) mulleGenericErrorWithDomain:(NSString *) domain
                        localizedDescription:(NSString *) s;
@end
```

Convenience C functions: `MulleObjCSetErrorCode()`, `MulleObjCSetErrorDomain()`, `MulleObjCGetErrorDomain()`, `MulleObjCExtractError()`, `MulleObjCClearError()`.

### 3.9. NSAssertionHandler (`src/Exception/NSAssertionHandler.h`)

Handles assertion failures from `NSAssert`/`NSCAssert` macros.

```objc
@interface NSAssertionHandler : NSObject < MulleObjCImmutableProtocols>

+ (NSAssertionHandler *) currentHandler;

- (void) handleFailureInMethod:(SEL) selector
                        object:(id) object
                          file:(NSString *) fileName
                    lineNumber:(NSInteger) line
                   description:(NSString *) format, ...;

- (void) handleFailureInFunction:(NSString *) functionname
                           file:(NSString *) filename
                     lineNumber:(NSInteger) line
                    description:(NSString *) format, ...;
@end
```

Macros: `NSAssert(condition, format, ...)`, `NSCAssert(condition, format, ...)` with NSAssert1–NSAssert5 and NSCAssert1–NSCAssert5 variants. `NSParameterAssert(a)`, `NSCParameterAssert(a)`. Disabled when `NS_BLOCK_ASSERTIONS` is defined.

### 3.10. NSLocale (`src/Locale/NSLocale.h`)

Locale information for internationalized formatting. Backed by `_xlocale` and `_iculocale`.

```objc
@interface NSLocale : NSObject < MulleObjCImmutableProtocols >

+ (instancetype) localeWithLocaleIdentifier:(NSString *) s;
+ (instancetype) autoupdatingCurrentLocale;
- (NSString *) displayNameForKey:(id) key value:(id) value;

+ (instancetype) systemLocale;
+ (instancetype) currentLocale;

- (NSString *) localeIdentifier;
- (NSString *) languageCode;
- (NSString *) scriptCode;
- (NSString *) variantCode;
- (NSString *) collationIdentifier;
- (NSString *) currencyCode;
- (NSString *) calendarIdentifier;

- (NSString *) localizedStringForLocaleIdentifier:(NSString *)localeIdentifier;
- (NSString *) localizedStringForCountryCode:(NSString *) countryCode;
- (NSString *) localizedStringForLanguageCode:(NSString *) languageCode;
- (NSString *) localizedStringForScriptCode:(NSString *) scriptCode;
- (NSString *) localizedStringForVariantCode:(NSString *) variantCode;
- (NSString *) localizedStringForCollationIdentifier:(NSString *) collationIdentifier;
- (NSString *) localizedStringForCollatorIdentifier:(NSString *) collatorIdentifier;
- (NSString *) localizedStringForCurrencyCode:(NSString *) currencyCode;
- (NSString *) localizedStringForCalendarIdentifier:(NSString *) calendarIdentifier;
@end
```

**Future API** (`<MulleObjCFuture>`):
```objc
@interface NSLocale( Future) < MulleObjCFuture>
+ (instancetype) _systemLocale;
+ (instancetype) _currentLocale;
+ (NSArray *) availableLocaleIdentifiers;
+ (NSArray *) ISOLanguageCodes;
+ (NSArray *) ISOCountryCodes;
+ (NSArray *) ISOCurrencyCodes;
+ (NSDictionary *) componentsFromLocaleIdentifier:(NSString *) string;
+ (NSString *) localeIdentifierFromComponents:(NSDictionary *) dict;
+ (NSString *) canonicalLocaleIdentifierFromString:(NSString *) string;
+ (NSString *) canonicalLanguageIdentifierFromString:(NSString *) string;
- (id) :(id) key;
- (id) objectForKey:(id) key;
- (BOOL) isEqualToLocale:(NSLocale *) other;
- (instancetype) initWithLocaleIdentifier:(NSString *) s;
@end
```

Numerous locale key globals: `NSLocaleLanguageCode`, `NSLocaleCountryCode`, `NSLocaleDecimalSeparator`, `NSLocaleCurrencyCode`, `NSLocaleCalendar`, etc.

### 3.11. NSString+NSLocale (`src/Locale/NSString+NSLocale.h`)

Locale-aware string comparison and formatting.

```objc
@interface NSString( NSLocale)
- (instancetype) initWithFormat:(NSString *) format
                         locale:(NSLocale *) locale, ...;
@end

@interface NSString( NSLocaleFuture) < MulleObjCFuture>
+ (instancetype) stringWithFormat:(NSString *) format
                           locale:(NSLocale *) locale;
+ (instancetype) localizedStringWithFormat:(NSString *) format;

- (NSComparisonResult) localizedCompare:(NSString *) other;
- (NSComparisonResult) localizedCaseInsensitiveCompare:(NSString *) other;
- (NSComparisonResult) localizedStandardCompare:(NSString *) other;
- (NSComparisonResult) compare:(NSString *) other
                       options:(NSUInteger) locale
                         range:(NSRange) range
                        locale:(NSLocale *) locale;

- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) options
                    range:(NSRange) range
                   locale:(NSLocale *) locale;

- (instancetype) initWithFormat:(NSString *) format
                         locale:(NSLocale *) locale
                      arguments:(va_list) argList;

- (instancetype) stringByFoldingWithOptions:(NSUInteger) options
                                     locale:(id) locale;
@end
```

### 3.12. NSNumberFormatter (`src/Locale/NSNumberFormatter.h`)

Converts NSNumber to/from NSString with locale-aware formatting.

```objc
@interface NSNumberFormatter : NSFormatter

@property( dynamic, assign) NSNumberFormatterBehavior  formatterBehavior;
@property( retain) NSLocale                 *locale;
@property( copy, nonnull) NSString          *format;
@property( copy) NSString                   *negativeFormat;
@property( copy) NSString                   *positiveFormat;
@property( copy) NSString                   *decimalSeparator;
@property( copy) NSString                   *thousandSeparator;
@property( retain) NSNumber                 *minimum;
@property( retain) NSNumber                 *maximum;
@property( assign) NSNumberFormatterStyle   numberStyle;

+ (NSNumberFormatterBehavior) defaultFormatterBehavior;
+ (void) setDefaultFormatterBehavior:(NSNumberFormatterBehavior) behavior;

- (BOOL) allowsFloats;
- (BOOL) generatesDecimalNumbers;
- (BOOL) hasThousandSeparators;
- (BOOL) isLenient;
- (void) setAllowsFloats:(BOOL) flag;
- (void) setGeneratesDecimalNumbers:(BOOL) flag;
- (void) setHasThousandSeparators:(BOOL) flag;
- (void) setLenient:(BOOL) flag;

- (NSNumber *) numberFromString:(NSString *) string;
- (NSString *) stringFromNumber:(NSNumber *) number;

+ (instancetype) mulleDefaultFormatter;
@end
```

Styles: `NSNumberFormatterNoStyle`, `NSNumberFormatterDecimalStyle`, `NSNumberFormatterPercentStyle`, `NSNumberFormatterScientificStyle`, `NSNumberFormatterSpellOutStyle`, `NSNumberFormatterOrdinalStyle`, `NSNumberFormatterCurrencyStyle`, etc.

### 3.13. NSNotification & NSNotificationCenter (`src/Notification/`)

Publish-subscribe messaging system.

```objc
@interface NSNotification : NSObject < MulleObjCImmutableProtocols>
@property( readonly, copy)   NSString        *name;
@property( readonly, retain) id              object;
@property( readonly, copy)   id <NSCopying, MulleObjCRuntimeObject>  userInfo;

+ (instancetype) notificationWithName:(NSString *) aName
                               object:(id) anObject;
+ (instancetype) notificationWithName:(NSString *) aName
                               object:(id) anObject
                             userInfo:(id <NSCopying, MulleObjCRuntimeObject>) userInfo;
@end
```

`NSNotification.userInfo` is untyped — not necessarily a dictionary (mulle extension).

```objc
@interface NSNotificationCenter : NSObject < MulleObjCSingleton, MulleObjCThreadSafe>
+ (instancetype) defaultCenter;

- (void) addObserver:(id) observer
            selector:(SEL) sel
                name:(NSString *) name
              object:(id) sender;

- (void) postNotification:(NSNotification *) notification;
- (void) postNotificationName:(NSString *) name
                       object:(id) sender;
- (void) postNotificationName:(NSString *) name
                       object:(id) sender
                     userInfo:(NSDictionary *) userInfo;

- (void) removeObserver:(id) observer;
- (void) removeObserver:(id) observer
                   name:(NSString *) name
                 object:(id) sender;
@end
```

Thread safety: internally locked via `mulle_thread_mutex_t`. Notifications posted on the posting thread; observers called synchronously. The NSNotificationCenter is app-wide (not thread-local), enabling `+load` plugin setup but risking cross-thread notification delivery. `MulleObjCUniverseWillFinalizeNotification` global available. `NSNotification.userInfo` is typed as `id <NSCopying, MulleObjCRuntimeObject>` — not necessarily a dictionary (mulle extension).

#### NSThread+NSNotification (`src/Notification/NSThread+NSNotification.h`)

Notification name globals for threading:
```objc
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString  *NSWillBecomeMultiThreadedNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString  *NSDidBecomeSingleThreadedNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString  *NSThreadWillExitNotification;
```

### 3.14. NSUndoManager (`src/Undo/NSUndoManager.h`)

Per-thread undo/redo stack management.

```objc
@interface NSUndoManager : NSObject <MulleObjCThreadUnsafe>

@property( assign) BOOL         groupsByEvent;
@property( assign) NSUInteger   levelsOfUndo;
@property( copy)   NSArray      *runLoopModes;

- (NSInteger) groupingLevel;

- (void) beginUndoGrouping;
- (void) endUndoGrouping;

- (void) disableUndoRegistration;
- (void) enableUndoRegistration;
- (BOOL) isUndoRegistrationEnabled;

- (void) undo;
- (void) redo;
- (void) undoNestedGroup;

- (BOOL) canUndo;
- (BOOL) canRedo;
- (BOOL) isUndoing;
- (BOOL) isRedoing;

- (void) removeAllActions;
- (void) removeAllActionsWithTarget:(id) target;
- (void) registerUndoWithTarget:(id) target
                       selector:(SEL) selector
                         object:(id) anObject;
- (id) prepareWithInvocationTarget:(id) target;
@end
```

Notification globals: `NSUndoManagerCheckpointNotification`, `NSUndoManagerDidOpenUndoGroupNotification`, `NSUndoManagerWillCloseUndoGroupNotification`, `NSUndoManagerDidUndoChangeNotification`, etc.

`prepareWithInvocationTarget:` returns a proxy; message sends to it are recorded as undo actions. Do not register undo actions inside undo/redo handlers (recursion risk).

### 3.15. NSSortDescriptor (`src/Container/NSSortDescriptor.h`)

Key-based sort ordering for arrays.

```objc
@interface NSSortDescriptor : NSObject <MulleObjCImmutableProtocols>

+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) flag;
+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) flag
                                    selector:(SEL) selector;
- initWithKey:(NSString *) key ascending:(BOOL) flag;
- initWithKey:(NSString *) key ascending:(BOOL) flag selector:(SEL) selector;

- (NSString *) key;
- (SEL) selector;
- (BOOL) ascending;
- (NSSortDescriptor *) reversedSortDescriptor;
@end
```

**Future API** (`<MulleObjCFuture>`):
```objc
@interface NSSortDescriptor( Future) < MulleObjCFuture>
- (NSComparisonResult) compareObject:(id) a toObject:(id) b;
@end
```

C function: `MulleObjCSortDescriptorArrayCompare(id a, id b, NSArray *descriptors)`.

### 3.16. NSString+Search (`src/Value/NSString+Search.h`)

String comparison and search operations. Also defines `struct MulleStringCharacterFunctions` for character-level operations.

```objc
struct MulleStringCharacterFunctions
{
   int       (*isdigit)( unichar);
   int       (*iszero)( unichar);
   int       (*isspace)( unichar);
   unichar   (*tolower)( unichar);
   unichar   (*toupper)( unichar);
};

@interface NSString( Search)
+ (void) setStringCharacterFunctions:(struct MulleStringCharacterFunctions *) converters;
+ (struct MulleStringCharacterFunctions *) stringCharacterFunctions;

- (NSComparisonResult) compare:(id) other;
- (NSComparisonResult) compare:(id) other
                       options:(NSStringCompareOptions) mask;
- (NSComparisonResult) caseInsensitiveCompare:(NSString *) other;
- (NSComparisonResult) compare:(NSString *) other
                       options:(NSStringCompareOptions) options
                         range:(NSRange) range;

- (NSRange) rangeOfString:(NSString *) other;
- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) options;
- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) options
                    range:(NSRange) range;
- (BOOL) containsString:(NSString *) s;

- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set;
- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options;
- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range;

- (NSString *) uppercaseString;
- (NSString *) lowercaseString;
- (NSString *) capitalizedString;

// mulle additions
- (NSString *) mulleDecapitalizedString;
- (NSRange) mulleRangeOfCharactersFromSet:(NSCharacterSet *) set
                                  options:(NSStringCompareOptions) options
                                    range:(NSRange) range;
- (NSUInteger) mulleCountOccurrencesOfCharactersFromSet:(NSCharacterSet *) set
                                                  range:(NSRange) range;

- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) s
                                         withString:(NSString *) replacement;
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) s
                                         withString:(NSString *) replacement
                                            options:(NSUInteger) options
                                              range:(NSRange) range;
- (NSString *) stringByReplacingCharactersInRange:(NSRange) range
                                       withString:(NSString *) replacement;
@end

@interface NSObject( MulleCompareDescription)
- (NSComparisonResult) mulleCompareDescription:(id) other;
@end
```

### 3.17. NSString+Components, NSString+Escaping, NSString+DoubleQuotes

#### NSString+Components (`src/Value/NSString+Components.h`)

Splitting and reassembling by separator string or character set.

```objc
@interface NSString ( Components)
- (NSArray *) componentsSeparatedByString:(NSString *) s;
- (NSArray *) componentsSeparatedByCharactersInSet:(NSCharacterSet *) separators;

// mulle additions
- (NSMutableArray *) mulleMutableComponentsSeparatedByString:(NSString *) s;
- (NSMutableArray *) mulleMutableComponentsSeparatedByCharactersInSet:(NSCharacterSet *) separators;
- (NSArray *) _componentsSeparatedByString:(NSString *) separator;  // nil if no separator
- (NSArray *) _componentsSeparatedByCharacterSet:(NSCharacterSet *) separators;
- (NSString *) mulleStringBySimplifyingComponentsSeparatedByString:(NSString *) separator
                                                      simplifyDots:(BOOL) simplifyDots;
- (NSString *) mulleStringByAppendingComponent:(NSString *) other
                              separatedByString:(NSString *) separator;
@end

// C convenience functions (return nil if no separator)
NSArray  *MulleObjCComponentsSeparatedByString( NSString *self, NSString *separator);
NSArray  *MulleObjCComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators);
NSMutableArray  *MulleObjCMutableComponentsSeparatedByString( NSString *self, NSString *separator);
NSMutableArray  *MulleObjCMutableComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators);
```

#### NSString+Escaping (`src/Value/NSString+Escaping.h`)

Percent-encoding, C-string escaping, and character replacement.

```objc
@interface NSString (Escaping)
- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters;
- (NSString *) stringByRemovingPercentEncoding;
- (NSString *) mulleQuotedString;
- (NSString *) mulleUnquotedString;
- (NSString *) mulleEscapedString;
- (NSString *) mulleUnescapedString;
- (NSString *) mulleQuotedDescriptionIfNeeded;
- (NSString *) mulleStringByReplacingCharactersInSet:(NSCharacterSet *) s
                                       withCharacter:(unichar) c;
- (NSString *) mulleStringByReplacingPercentEscapesWithDisallowedCharacters:(NSCharacterSet *) disallowedCharacters;
@end

char   *MulleUTF8StringEscape( char *src, NSUInteger length, char *dst);
char   *MulleUTF8StringUnescape( char *src, NSUInteger length, char *dst);
struct mulle_utf8data  *_MulleReplacePercentEscape( struct mulle_utf8data *src,
                                                     NSCharacterSet *disallowedCharacters);
NSString  *MulleObjCStringByReplacingPercentEscapes( NSString *self,
                                                      NSCharacterSet *disallowedCharacters);
```

#### NSString+DoubleQuotes (`src/Value/NSString+DoubleQuotes.h`)

Shell-style double/single-quoted tokenization.

```objc
@interface NSString( DoubleQuotes)
+ (NSString *) mulleStringWithUTF8Characters:(char *) bytes
                                   cRangeSet:(struct mulle__rangeset *) ranges;
- (NSString *) mulleDoubleQuoteEscapedString;
- (NSArray *) mulleComponentsSeparatedByWhitespaceWithDoubleQuoting;
- (NSArray *) mulleComponentsSeparatedByWhitespaceWithSingleQuoting;
- (NSArray *) mulleComponentsSeparatedByWhitespaceWithSingleAndDoubleQuoting;
@end
```

#### NSString+NSCharacterSet (`src/Value/NSString+NSCharacterSet.h`)

```objc
@interface NSString( NSCharacterSet)
- (NSString *) stringByTrimmingCharactersInSet:(NSCharacterSet *) set;
@end
```

#### NSMutableString+Search (`src/Value/NSMutableString+Search.h`)

```objc
@interface NSMutableString( Search)
- (void) replaceOccurrencesOfString:(NSString *) s
                         withString:(NSString *) replacement
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range;
@end
```

## 4. Performance Characteristics

| Class | Operation | Complexity |
|-------|-----------|------------|
| NSCharacterSet | `characterIsMember:` (bitmap) | O(1) |
| NSCharacterSet | `characterIsMember:` (range-based) | O(log n) |
| NSCharacterSet | Creation from string/range | O(n) |
| NSCalendarDate | Component access (year, month, dayOfWeek...) | O(1) |
| NSCalendarDate | `dateByAddingYears:...` | O(1) |
| NSDateFormatter | `stringFromDate:` | O(n) format length |
| NSDateFormatter | `dateFromString:` | O(n) input length |
| NSScanner | Scan operations | O(n) chars consumed |
| NSNotificationCenter | `addObserver:` | O(k) for given name |
| NSNotificationCenter | `postNotification:` | O(k) — synchronous broadcast |
| NSNotificationCenter | `removeObserver:` | O(k) |
| NSUndoManager | `registerUndo:` | O(1) stack push |
| NSUndoManager | `undo` / `redo` | O(1) stack pop |
| NSUndoManager | Memory | O(levels × ops/group) |
| NSNumberFormatter | `stringFromNumber:` | O(n) digits |
| NSLocale | `objectForKey:` | O(1) hash lookup |

Thread-safety: NSNotificationCenter is internally thread-safe (`MulleObjCThreadSafe`). NSUndoManager and NSFormatter are explicitly thread-unsafe (`MulleObjCThreadUnsafe`). NSException, NSError, NSLocale, NSScanner have no thread-safety protocol — assume not thread-safe.

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **MulleObjCFuture**: Methods in categories marked `<MulleObjCFuture>` are planned but may be partially or not implemented. Prefer the stable (non-Future) API where available.
- **NSCharacterSet**: Use predefined class methods (e.g., `+ alphanumericCharacterSet`) — they return optimized singletons.
- **NSDateFormatter/NSNumberFormatter**: Cache formatter instances; creating new ones in loops is expensive. Set `dateFormat`/`format` property rather than calling `- initWithDateFormat:` repeatedly.
- **NSException vs NSError**: Use NSException for programming errors (invariant violations), NSError for recoverable conditions.
- **NSNotificationCenter**: Always `- removeObserver:` in dealloc. Don't pass large objects in userInfo.
- **NSUndoManager**: Group related operations with `beginUndoGrouping`/`endUndoGrouping`. Set `levelsOfUndo` to limit memory.
- **NSScanner**: Check return BOOL from scan methods; they silently fail. Set `charactersToBeSkipped` appropriately.
- **NSLocale**: Use `[NSLocale currentLocale]` for user-facing formatting. Test with multiple locales.

### Common Pitfalls

- **NSCharacterSet**: `unichar` is UTF-32 (`mulle_utf32_t`, 32-bit), not 16-bit. Use `longCharacterIsMember:` (stable), not `characterIsMember:` (in Future category, may be incomplete).
- **NSCalendarDate**: `isEqual:` compares as `NSDate` (point-in-time), but `isEqualToCalendarDate:` compares calendar components including timeZone — know which you need. `isEqualToCalendarDate:` is in the Subclasses category (`<MulleObjCFuture>`).
- **NSDateFormatter**: Formatters are not re-entrant. `setFormatterBehavior:` changes the internal class of the formatter.
- **NSNotificationCenter**: Forgetting to unregister observers (memory leak). NotificationCenter is app-wide, not thread-local — cross-thread notification delivery is possible.
- **NSScanner**: Not checking `isAtEnd` before scanning. Scan methods return BOOL but silently fail.
- **NSException**: Using `@try`/`@catch` for normal control flow. Not including enough context in reason string. `-raise:format:` is not `MULLE_C_NO_RETURN` — when `self` is nil, the message returns.
- **NSError**: Not checking for nil before dereferencing error out-parameter.
- **NSLocale**: Hard-coding locale-specific formatting characters. `systemLocale`/`currentLocale` are hard-cached on `+initialize`.
- **NSUndoManager**: Registering undo actions inside undo/redo handlers (recursion). `prepareWithInvocationTarget:` returns a proxy whose message sends are recorded as undo actions.
- **NSNumberFormatter**: `NSNumberFormatterBehavior10_4` is defined but not implemented. Format string must match the `numberStyle`.

### Idiomatic Patterns

**Formatter reuse (static cache):**
```objc
static NSDateFormatter  *formatter;
if( ! formatter)
{
   formatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d"
                                       allowNaturalLanguage:NO] autorelease];
}
NSString   *formatted = [formatter stringFromDate:[NSDate date]];
```

**Safe scanning:**
```objc
NSScanner   *scanner = [[[NSScanner alloc] initWithString:input] autorelease];
int         intVal;
if( [scanner scanInt:&intVal] && [scanner isAtEnd])
{
   // successfully parsed entire input
}
```

**Notification observer setup/teardown:**
```objc
- (instancetype) init
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(onNotification:)
                                                name:@"SomeNotification"
                                              object:nil];
   return( self);
}

- (void) dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [super dealloc];
}
```

**Grouped undo operations:**
```objc
[undoManager beginUndoGrouping];
@try
{
   [self setValue:newValue];
   [undoManager registerUndoWithTarget:self
                              selector:@selector(setValue:)
                                object:oldValue];
}
@finally
{
   [undoManager endUndoGrouping];
}
```

## 6. Integration Examples

### Example 1: Date Parsing and Formatting

```objc
#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

int   main( void)
{
   NSTimeZone        *tz   = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
   NSCalendarDate    *date = [NSCalendarDate dateWithYear:2025 month:11 day:8
                                                     hour:21 minute:18 second:26
                                                 timeZone:tz];
   NSDateFormatter   *fmtr = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M:%S"
                                                     allowNaturalLanguage:NO] autorelease];
   mulle_printf( "%s\n", [[fmtr stringFromDate:date] UTF8String]);
   return( 0);
}
```

### Example 2: Character Set Validation

```objc
NSString        *username = @"user_name-123";
NSCharacterSet  *safeChars;
BOOL            isValid;

safeChars = [NSCharacterSet alphanumericCharacterSet];
isValid   = [username rangeOfCharacterFromSet:safeChars].location != NSNotFound;
if( ! isValid)
   [NSException raise:NSInvalidArgumentException
              format:@"Username contains invalid characters"];
```

### Example 3: Number Formatting with Locale

```objc
NSNumberFormatter   *formatter = [[[NSNumberFormatter alloc] init] autorelease];
[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
[formatter setLocale:[NSLocale currentLocale]];
[formatter setFormat:@"#,##0.00"];

NSNumber  *num       = [NSNumber numberWithDouble:1234.567];
NSString  *formatted = [formatter stringFromNumber:num];
```

### Example 4: Text Parsing with NSScanner

```objc
NSString     *csvLine = @"42, 3.14, \"text value\"";
NSScanner    *scanner = [[[NSScanner alloc] initWithString:csvLine] autorelease];
int          intVal;
double       doubleVal;
NSString     *stringVal;

[scanner setCharactersToBeSkipped:
    [NSCharacterSet characterSetWithCharactersInString:@" \""]];

if( [scanner scanInt:&intVal] &&
    [scanner scanDouble:&doubleVal] &&
    [scanner scanString:@"," intoString:NULL] &&
    [scanner scanUpToString:@"\"" intoString:&stringVal])
   mulle_printf( "Parsed: int=%d, double=%f, string=%s\n",
      intVal, doubleVal, [stringVal UTF8String]);
```

### Example 5: Notification-Based Event System

```objc
// Post
[[NSNotificationCenter defaultCenter] postNotificationName:@"DataChanged"
                                                    object:self
                                                  userInfo:someDictionary];

// Receive
- (instancetype) init
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(onDataChanged:)
                                                name:@"DataChanged"
                                              object:nil];
   return( self);
}

- (void) dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [super dealloc];
}

- (void) onDataChanged:(NSNotification *) notif
{
   id   info = [notif userInfo];
   mulle_printf( "Received: %s\n", [[[info description] UTF8String]]);
}
```

## 7. Dependencies

Direct dependencies from `.mulle/etc/sourcetree/config`:

- **MulleObjCTimeFoundation** — NSDate, NSTimer, time utilities (`no-singlephase`)
- **MulleObjCValueFoundation** — NSNumber, NSString, NSData, NSValue (`no-singlephase`)
- **MulleObjCContainerFoundation** — NSArray, NSSet, NSDictionary, mutable variants (`no-singlephase`)
- **mulle-objc-list** — Runtime class list registration (`no-all-load`, `no-bequeath`, `no-cmake-inherit`, `no-header`, `no-import`, `no-link`)
