<!-- Keywords: exception, error, notification, character-set, scanner, locale, timezone, undo, sort, pattern -->
# Patterns

## Exception & Error handling

### NSException — programming errors

```objc
[NSException raise:NSInvalidArgumentException
            format:@"Value must not be nil, got: %@", name];

@try
{
   // risky code
}
@catch( NSException *localException)
{
   // handle
}
```

Standard exception name globals (`src/Exception/NSException.h`):
`NSInternalInconsistencyException`, `NSGenericException`,
`NSInvalidArgumentException`, `NSMallocException`, `NSRangeException`,
`NSParseErrorException`.

Macros `NS_DURING` / `NS_HANDLER` / `NS_ENDHANDLER` map to `@try`/`@catch`.

### NSError — thread-local recoverable errors

```objc
// Producer
[MulleObjCSetErrorCode(code, domain, userInfo)];

// Consumer
NSError   *error = [NSError mulleExtract];
if( error)
{
   NSString   *desc = [error localizedDescription];
}
```

Error domain registration must happen during `+load` or `+initialize`
(`src/Exception/NSError.h`):

```objc
+ (void) load
{
   [NSError registerErrorDomain:MulleErrnoErrorDomain
            errorStringFunction:someTranslator];
}
```

### NSAssertionHandler — assert macros

```objc
NSAssert( condition, @"description: %@", obj);
NSCAssert( condition, @"C description: %@", obj);
NSParameterAssert( condition);
```

Disabled when `NS_BLOCK_ASSERTIONS` is defined (`src/Exception/NSAssertionHandler.h`).

## Notification Center — publish/subscribe

```objc
// Observer setup/teardown
- (instancetype) init
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onEvent:)
                                               name:@"SomeEvent"
                                             object:nil];
   return( self);
}

- (void) dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [super dealloc];
}

- (void) onEvent:(NSNotification *) notif
{
   id   info = [notif userInfo];  // untyped — may not be a dictionary
}
```

Posting:

```objc
[[NSNotificationCenter defaultCenter] postNotificationName:@"DataChanged"
                                                    object:self
                                                  userInfo:@{ @"key": val }];
```

`NSNotification.userInfo` is typed as `id <NSCopying, MulleObjCRuntimeObject>`,
not necessarily a dictionary (`src/Notification/NSNotification.h:1`).

## Character set & Scanner

### NSCharacterSet — predefined singletons

```objc
NSCharacterSet   *digits = [NSCharacterSet decimalDigitCharacterSet];
NSCharacterSet   *alpha  = [NSCharacterSet alphanumericCharacterSet];
NSCharacterSet   *ws     = [NSCharacterSet whitespaceCharacterSet];

if( [alpha longCharacterIsMember:'A'])
   // ...

// Mutable variant
NSMutableCharacterSet   *set = [NSMutableCharacterSet characterSetWithCharactersInString:@"abc"];
[set addCharactersInRange:NSMakeRange('0', '9')];
```

Predefined methods return optimized singletons (class cluster with bitmap/range
backends per `src/Value/NSCharacterSet.h:1`).

### NSScanner — structured parsing

```objc
NSScanner   *scanner = [NSScanner scannerWithString:@"42, 3.14, hello"];
int         intVal;
double      dblVal;

[scanner setCharactersToBeSkipped:
    [NSCharacterSet characterSetWithCharactersInString:@", "]];

if( [scanner scanInt:&intVal] &&
    [scanner scanDouble:&dblVal] &&
    [scanner isAtEnd])
{
   // successfully parsed
}
```

Always check the return `BOOL` — scan methods silently fail on mismatch
(`src/Value/NSScanner.h:1`).

## Calendar date & Date formatting

### NSCalendarDate — timezone-aware date

```objc
NSTimeZone     *tz  = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
NSCalendarDate *cal = [NSCalendarDate dateWithYear:2025 month:11 day:8
                                              hour:21 minute:18 second:26
                                          timeZone:tz];
```
NSCalendarDate _always_ has a timeZone and is integer-based (no subsecond
precision per `src/Date/NSCalendarDate.h:1`).

### NSDateFormatter — cached formatter

```objc
static NSDateFormatter  *fmt;
if( ! fmt)
{
   fmt = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d"
                                allowNaturalLanguage:NO];
   [fmt autorelease];
}
NSString   *s = [fmt stringFromDate:cal];  // via Future category
```

Global format strings: `MulleDateFormatISO` (`@"%Y-%m-%dT%H:%M:%S:%z"`),
`MulleDateFormatISOWithMilliseconds` (`src/Date/NSDateFormatter.h:1`).

### NSTimeZone

```objc
NSTimeZone   *tz   = [NSTimeZone timeZoneWithName:@"Europe/Berlin"];
NSTimeZone   *utc  = [NSTimeZone mulleGMTTimeZone];
NSTimeZone   *def  = [NSTimeZone defaultTimeZone];
NSInteger    offset = [tz secondsFromGMT];
```

Requires platform-specific category to work (`src/TimeZone/NSTimeZone.h:1`).

## Locale & Number formatting

### NSLocale

```objc
NSLocale   *loc = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
NSString   *name = [loc displayNameForKey:NSLocaleCurrencyCode value:@"EUR"];
NSString   *code = [loc currencyCode];
```

`[NSLocale currentLocale]` is cached on `+initialize`. `[NSLocale autoupdatingCurrentLocale]`
updates when system locale changes (`src/Locale/NSLocale.h:1`).

### NSNumberFormatter

```objc
NSNumberFormatter   *nf = [[NSNumberFormatter new] autorelease];
[nf setNumberStyle:NSNumberFormatterDecimalStyle];
[nf setLocale:[NSLocale currentLocale]];
NSString   *s = [nf stringFromNumber:[NSNumber numberWithDouble:1234.56]];
```

`+[NSNumberFormatter mulleDefaultFormatter]` returns a locale-nil formatter
(`src/Locale/NSNumberFormatter.h:1`).

## Undo Manager

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

NSUndoManager is `<MulleObjCThreadUnsafe>` — access from one thread only
(`src/Undo/NSUndoManager.h:1`).

## Sort Descriptor

```objc
NSSortDescriptor   *desc = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                        ascending:YES
                                                         selector:@selector(caseInsensitiveCompare:)];
NSArray            *sorted = [array sortedArrayUsingDescriptors:@[ desc ]];
```

C helper: `MulleObjCSortDescriptorArrayCompare(a, b, descriptors)`  
(`src/Container/NSSortDescriptor.h:1`).
