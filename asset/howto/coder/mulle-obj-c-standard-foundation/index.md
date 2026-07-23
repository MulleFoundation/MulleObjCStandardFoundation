<!-- Keywords: exception, error, notification, character-set, scanner, locale, timezone, calendar-date, undo, sort -->
# mulle-obj-c-standard-foundation

Use this topic when coding against classes in the `MulleObjCStandardFoundation`
library — NSException, NSError, NSNotificationCenter, NSCharacterSet,
NSScanner, NSCalendarDate, NSDateFormatter, NSTimeZone, NSLocale,
NSNumberFormatter, NSUndoManager, NSSortDescriptor, and NSFormatter.

## Understand first

```bash
mulle-sde api apropos exception
mulle-sde api apropos notification
mulle-sde api apropos locale
mulle-sde howto cat styleguide
```

Read `quirks.md` and `patterns.md` next.

## Local references

| Reference | Path |
|-----------|------|
| Umbrella header | `src/MulleObjCStandardFoundation.h` |
| Detailed API doc | `asset/dox/TOC.md` |
| Exception headers | `src/Exception/NSException.h`, `NSError.h`, `NSAssertionHandler.h` |
| Notification headers | `src/Notification/NSNotification.h`, `NSNotificationCenter.h` |
| Character set / Scanner | `src/Value/NSCharacterSet.h`, `src/Value/NSScanner.h` |
| Formatter base | `src/Value/NSFormatter.h` |
| Calendar date / Date formatter | `src/Date/NSCalendarDate.h`, `src/Date/NSDateFormatter.h` |
| Time zone | `src/TimeZone/NSTimeZone.h` |
| Locale / Number formatter | `src/Locale/NSLocale.h`, `src/Locale/NSNumberFormatter.h` |
| Undo manager | `src/Undo/NSUndoManager.h` |
| Sort descriptor | `src/Container/NSSortDescriptor.h` |
| Tests | `test/00_noleak/test-*.m` |

## Dominant API families

| Family | Key classes | Primary source dir |
|--------|-------------|-------------------|
| **Exception & Error** | NSException, NSError, NSAssertionHandler | `src/Exception/` |
| **Notification** | NSNotification, NSNotificationCenter | `src/Notification/` |
| **Character set & Scanner** | NSCharacterSet, NSMutableCharacterSet, NSScanner | `src/Value/` |
| **Calendar date & Time zone** | NSCalendarDate, NSDateFormatter, NSTimeZone | `src/Date/`, `src/TimeZone/` |
| **Locale & Number formatting** | NSLocale, NSNumberFormatter, NSString(NSLocale) | `src/Locale/` |
| **Undo** | NSUndoManager | `src/Undo/` |
| **Sort** | NSSortDescriptor | `src/Container/` |

## Import

```objc
#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
```

Individual header imports also work (e.g. `#import "NSException.h"`).

## Workflow

1. Use `+[NSException raise:format:]` for programming errors, `NSError` + `mulleExtract` for recoverable errors.
2. Use `NSCharacterSet` predefined singletons (e.g. `+alphanumericCharacterSet`) for character classification.
3. Use `NSScanner` for structured text parsing; always check the return `BOOL`.
4. Use `NSCalendarDate` for calendar-component-aware date work; prefer `NSDate` for time intervals.
5. Cache `NSDateFormatter` / `NSNumberFormatter` instances — creation is expensive.
6. Use `[NSLocale currentLocale]` for user-facing formatting; register error domains in `+load`.
