<!-- Keywords: pitfalls, invariants, restrictions, differences, caveats -->
# Quirks

## Global restrictions (repository-wide)

- No dot-syntax — always use explicit message sends: `[obj method]` not `obj.method`.
- No blocks (`^` syntax) under any circumstance.
- No `-release` except in `-dealloc`.
- No `+alloc`/`-init`/`-autorelease` in application code — use factory methods (`+instance` / `+calendarDate` / etc.).
- No `nullable`, no generics, no class extensions in `@implementation`, no `@synthesize`.
- Instance variables belong in `@interface`, never in `@implementation`.
- `unichar` is UTF-32 (`mulle_utf32_t`), not 16-bit. Use `longCharacterIsMember:` (not `characterIsMember:`) on NSCharacterSet.

## Exception quirks

- `+[NSException raise:format:]` is **not** marked `MULLE_C_NO_RETURN` because when `self` is nil, the message does return (`src/Exception/NSException.h:1`).
- `MulleObjCThrowMallocException` is a standalone C function for allocation failures.
- `NS_VALUERETURN(v,t)` and `NS_VOIDRETURN` macros are provided for use inside `NS_HANDLER` blocks.

## NSError quirks

- Thread-local error model: use `[NSError mulleExtract]` as the preferred consumer entry point (`src/Exception/NSError.h:1`).
- `mulleSetErrorDomain:` stores a constant domain string; the actual `NSError` object is created lazily by `mulleExtract`.
- `recoveryAttempter` can return a thread-unsafe object — `NSError` is therefore **not** a value type.
- Standalone C convenience functions: `MulleObjCSetErrorCode()`, `MulleObjCSetErrorDomain()`, `MulleObjCGetErrorDomain()`, `MulleObjCExtractError()`, `MulleObjCClearError()`.

## NSCharacterSet quirks

- `characterIsMember:` is in the `SubclassesFuture` category (`<MulleObjCFuture>`) and may be incomplete. Prefer `longCharacterIsMember:` which is stable (`src/Value/NSCharacterSet.h:1`).
- Uses class cluster pattern with optimized subclasses: `_MulleObjCCheatingASCIICharacterSet`, `_MulleObjCConcreteBitmapCharacterSet`, `_MulleObjCConcreteRangeCharacterSet`, `_MulleObjCConcreteInvertedCharacterSet`.
- Predefined class methods (e.g. `+alphanumericCharacterSet`) return optimized singletons.
- `mulle_unichar_*` C functions provide inline UTF-32 string operations (strlen, strcmp, strstr, etc.).
- `NSMutableCharacterSet` extends with `addCharactersInString:`, `removeCharactersInString:`, `addCharactersInRange:`, `formUnionWithCharacterSet:`, `formIntersectionWithCharacterSet:`, `invert`.

## NSScanner quirks

- Scan methods return `BOOL` and **silently fail** on mismatch — always check the return value (`src/Value/NSScanner.h:1`).
- `scanLocation` advances only on successful scan; it does not reset on failure.
- `mulleUnscannedString` returns remaining unparsed content.
- `mulleScanUpToAndIncludingString:` is a mulle extension not in Apple Foundation.

## NSCalendarDate quirks

- Always carries a timeZone — never nil (`src/Date/NSCalendarDate.h:1`).
- Integer-based, no subsecond precision. Use `NSDate` when you need `NSTimeInterval`.
- Methods in `NSCalendarDate(Future) <MulleObjCFuture>` (e.g. `dayOfWeek`, `dateByAddingYears:...`) are planned but may be incomplete. Prefer stable main `@interface` methods.
- Component accessors (`secondOfMinute`, `hourOfDay`, `dayOfMonth`, etc.) are in the `Subclasses` category (`<MulleObjCFuture>`) — use `mulleMiniTM` + struct access for reliable calendar component access.
- Equality: `[calendarDateA isEqual:calendarDateB]` compares as `NSDate` (point-in-time). `isEqualToCalendarDate:` compares calendar components including timeZone.

## NSDateFormatter quirks

- Formatters are **not re-entrant** (`src/Date/NSDateFormatter.h:1`).
- `setFormatterBehavior:` changes the internal class of the formatter.
- `stringFromDate:` and `dateFromString:` are in the `Future` category — may be incomplete. The stable path is `initWithDateFormat:allowNaturalLanguage:` plus property access.
- `generatesCalendarDates` (default `YES`) produces `NSCalendarDate`; set to `NO` for plain `NSDate`.

## NSTimeZone quirks

- Not functional on its own — requires a category implementation from platform-specific code (`src/TimeZone/NSTimeZone.h:1`).
- `resetSystemTimeZone` clears the cached system timezone.
- `mulleGMTTimeZone` returns a GMT+0 timezone singleton.

## NSLocale quirks

- `systemLocale` and `currentLocale` are hard-cached on `+initialize` (`src/Locale/NSLocale.h:1`).
- Backed by `_xlocale` and `_iculocale` internally.
- Many locale key globals defined (e.g. `NSLocaleDecimalSeparator`, `NSLocaleCurrencyCode`, `NSLocaleLanguageCode`).

## NSNumberFormatter quirks

- `NSNumberFormatterBehavior10_4` is defined but **not implemented** (`src/Locale/NSNumberFormatter.h:1`).
- `+mulleDefaultFormatter` returns a formatter with no locale set (locale == nil), useful as a base for customization.
- `format` property must be set to a valid format string matching the `numberStyle`.

## NSNotificationCenter quirks

- Implements `MulleObjCSingleton` — `+defaultCenter` is the only valid way to get the instance (returns a singleton via `+sharedInstance`). Calling `+new` or `+alloc`/`-init` directly may produce unexpected results — always use `+defaultCenter`.
- Implements `MulleObjCThreadSafe` — internally locked with `mulle_thread_mutex_t`.
- Currently app-wide (not thread-local), which enables `+load` plugin setup but can cause cross-thread notification delivery (`src/Notification/NSNotificationCenter.h:1`).
- Forgetting `-removeObserver:` in `dealloc` leaks the observer registration.

## NSUndoManager quirks

- Marked `<MulleObjCThreadUnsafe>` — access from one thread only (`src/Undo/NSUndoManager.h:1`).
- `groupsByEvent` is the default grouping mode; set to `NO` for manual grouping.
- `levelsOfUndo` limits stack memory; default is 0 (unlimited).
- Registering undo actions inside undo/redo handlers can cause recursion.
- `prepareWithInvocationTarget:` returns a proxy; message sends to it are recorded as undo actions.

## NSSortDescriptor quirks

- Stable API uses `+sortDescriptorWithKey:ascending:` and `+sortDescriptorWithKey:ascending:selector:`.
- `compareObject:toObject:` is in the `Future` category — use `MulleObjCSortDescriptorArrayCompare` C function instead for array-level sorting (`src/Container/NSSortDescriptor.h:1`).

## NSFormatter quirks

- Abstract base class — do not instantiate directly (`src/Value/NSFormatter.h:1`).
- Marked `<MulleObjCThreadUnsafe>` — not re-entrant. Subclasses (NSDateFormatter, NSNumberFormatter) inherit this restriction.

## MulleObjCFuture protocol

Categories marked `<MulleObjCFuture>` contain APIs that are planned but may be
partially or not implemented (`asset/dox/TOC.md:1`). Prefer stable (non-Future)
API where available. Use Future API only after verifying behavior.
