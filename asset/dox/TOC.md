# MulleObjCStandardFoundation Library Documentation for AI
<!-- Keywords: foundation, standard-library -->

## 1. Introduction & Purpose

**MulleObjCStandardFoundation** provides the core collection of Objective-C Foundation classes that implement C standard library abstractions in an object-oriented manner. It aggregates functionality from lower-level Foundation components (Time, Value, Container, Calendar, etc.) and adds several critical local classes:

- **NSCharacterSet**: Character classification and set operations (similar to `<ctype.h>`)
- **NSCalendarDate**: Combined date and timezone handling with formatting
- **NSDateFormatter**: Converts NSDate objects to/from NSString representations
- **NSException & NSError**: Exception and error handling mechanisms
- **NSLocale**: Localization and region-specific data
- **NSNotification & NSNotificationCenter**: Publish-subscribe messaging system
- **NSAssertionHandler**: Handles assertion failures
- **NSScanner**: Parses structured text into typed values
- **NSUndoManager**: Manages undo/redo operation sequences
- **NSNumberFormatter**: Converts between NSNumber and NSString with formatting

This library is the central hub of the MulleFoundation ecosystem, combining value types, containers, time operations, and utility classes into a complete Foundation framework.

## 2. Key Concepts & Design Philosophy

### Foundation as Standard Library Abstraction
MulleObjCStandardFoundation translates C standard library concepts into an object-oriented Objective-C interface. Each class provides type-safe wrappers around lower-level functionality.

### Class Cluster Pattern
Many classes (NSCharacterSet, NSCalendarDate) use the class cluster pattern internally, providing multiple concrete subclasses optimized for different use cases while maintaining a unified public interface.

### Immutability by Default
Classes follow the mulle-objc convention where immutable variants are the primary public interface, with mutable variants available when modifications are necessary.

### Layered Aggregation Model
This library does not implement everything from scratch. Instead it composes:
- **Foundational types** from MulleObjCValueFoundation (NSNumber, NSString, NSData)
- **Containers** from MulleObjCContainerFoundation (NSArray, NSDictionary, NSSet)
- **Time types** from MulleObjCTimeFoundation (NSDate, NSTimer)
- **This project adds**: NSCalendarDate, NSCharacterSet, NSDateFormatter, NSLocale, NSNotificationCenter, NSUndoManager, NSError, NSException

## 3. Core API & Data Structures

### 3.1 NSCharacterSet - Character Membership & Classification

#### Purpose
Represents an immutable set of Unicode characters for membership testing and operations. Provides class cluster with optimized internal implementations.

#### Key Creation Methods
- `+ alphanumericCharacterSet` - Characters a-z, A-Z, 0-9
- `+ decimalDigitCharacterSet` - Digits 0-9 only
- `+ whitespaceCharacterSet` - Space, tab, newline, carriage return, vertical tab, form feed
- `+ whitespaceAndNewlineCharacterSet` - Whitespace plus all newline Unicode characters
- `+ uppercaseLetterCharacterSet`, `+ lowercaseLetterCharacterSet`, `+ letterCharacterSet`
- `+ controlCharacterSet` - Control characters (C0 and C1 ranges)
- `+ punctuationCharacterSet` - Common punctuation characters
- `+ illegalCharacterSet` - Illegal Unicode values
- `+ characterSetWithCharactersInString:(NSString *)str` - Custom set from string characters
- `+ characterSetWithRange:(NSRange)range` - Custom set from Unicode range
- `+ characterSetWithBitmapRepresentation:(NSData *)data` - Reconstruct from serialized bitmap

#### Key Operations
- `- characterIsMember:(unichar)aCharacter` - Test membership (O(1) for bitmap, O(log n) for ranges)
- `- bitmapRepresentation` - Export as bitmap NSData for serialization/storage
- `- invert` - Create logically inverted set

#### Mutable Variant: NSMutableCharacterSet
- `- addCharactersInString:(NSString *)str` - Add characters
- `- removeCharactersInString:(NSString *)str` - Remove characters
- `- addCharactersInRange:(NSRange)range` - Add range
- `- removeCharactersInRange:(NSRange)range` - Remove range

#### Internal Optimization
Automatically uses optimized subclasses:
- `_MulleObjCCheatingASCIICharacterSet` - Fast ASCII-only optimization
- `_MulleObjCConcreteBitmapCharacterSet` - For large sets
- `_MulleObjCConcreteRangeCharacterSet` - For sparse Unicode ranges
- `_MulleObjCConcreteInvertedCharacterSet` - For inverted sets

#### Performance
- `characterIsMember:` is O(1) for bitmap, O(log n) for range sets
- Creation is O(n) where n = number of characters specified
- Bitmap size ~8KB (for full Unicode range); range sets scale with number of ranges

---

### 3.2 NSCalendarDate - Date with Calendar & Timezone

#### Purpose
Represents a specific date and time within a given timezone and calendar system. Extends NSDate with calendar-aware operations (component access, arithmetic by calendar units).

#### Creation Methods
- `+ dateWithYear:(int)year month:(unsigned)month day:(unsigned)day hour:(unsigned)hour minute:(unsigned)minute second:(unsigned)second timeZone:(NSTimeZone *)tz` - Create from components
- `+ dateWithString:(NSString *)description calendarFormat:(NSString *)format` - Parse formatted string
- Inherits NSDate factory methods

#### Component Access (all return int/unsigned values)
- `- year`, `- month`, `- day`, `- hour`, `- minute`, `- second`
- `- dayOfWeek` - 0=Sunday through 6=Saturday
- `- dayOfYear` - 1-366
- `- weekOfYear` - ISO week number

#### Calendar-Aware Date Arithmetic
- `- addYears:(int)years months:(int)months days:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds` - Compound date calculation respecting calendar rules (e.g., February wraps correctly)

#### Formatting & Display
- `- descriptionWithCalendarFormat:(NSString *)format timeZone:(NSTimeZone *)tz locale:(NSLocale *)locale` - Custom format output
- Format codes: `%Y` (4-digit year), `%m` (month), `%d` (day), `%H` (24-hour), `%M` (minute), `%S` (second), `%A` (weekday name), `%Z` (timezone name)

#### Timezone-Aware Comparisons
- `- compare:(NSDate *)date` - Standard date comparison (accounts for timezone)
- `- isToday`, `- isTomorrow`, `- isYesterday` - Convenience comparisons in local timezone

#### Key Property
- Timezone-aware: All component access and arithmetic respect the NSTimeZone associated with the instance

---

### 3.3 NSDateFormatter - Date ↔ String Conversion

#### Purpose
Converts bidirectionally between NSDate and NSString with configurable format strings, timezone, and locale support.

#### Core Methods
- `- initWithDateFormat:(NSString *)format allowNaturalLanguage:(BOOL)flag` - Create with format
- `- stringFromDate:(NSDate *)date` - Format date to string
- `- dateFromString:(NSString *)string` - Parse string to date (returns nil on parse failure)

#### Format Code Reference
- `%Y` = 4-digit year, `%y` = 2-digit year
- `%m` = month (01-12), `%B` = full month name, `%b` = abbreviated month name
- `%d` = day of month (01-31), `%e` = day (space-padded)
- `%H` = 24-hour (00-23), `%h` = 12-hour (1-12), `%p` = AM/PM
- `%M` = minute (00-59), `%S` = second (00-59)
- `%A` = full weekday name, `%a` = abbreviated weekday
- `%Z` = timezone name, `%z` = UTC offset (+HHMM)

#### Example Formats
- `"%Y-%m-%d %H:%M:%S"` → "2025-11-08 21:18:26"
- `"%B %d, %Y"` → "November 08, 2025"
- `"%I:%M %p"` → "09:18 PM"
- `"%a, %b %d"` → "Sat, Nov 08"

#### Performance Notes
- Format parsing cached internally on first use
- Reuse formatter instances; creating new ones in loops is expensive
- naturalLanguage parsing (`YES`) is slower and platform-dependent

---

### 3.4 NSException - Throwable Exception Objects

#### Purpose
Represents an exception that can be thrown via `@throw` directive for non-local error handling and control flow.

#### Creation & Throwing
- `+ exceptionWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)dict` - Create exception
- `+ raise:(NSString *)name format:(NSString *)format, ...` - Create and throw immediately

#### Properties
- `- name` - Exception identifier (NSString): NSInvalidArgumentException, NSRangeException, etc.
- `- reason` - Human-readable error description
- `- userInfo` - NSDictionary with application-specific additional data

#### Standard Exception Names
- `NSInvalidArgumentException` - Invalid parameter value passed
- `NSRangeException` - Index/range out of bounds
- `NSInternalInconsistencyException` - Invariant violated
- `NSGenericException` - Catch-all for custom exceptions

#### Usage Pattern
```objc
@try {
    if (index >= count) {
        [NSException raise:NSRangeException
                   format:@"Index %d out of bounds (count: %d)", index, count];
    }
}
@catch (NSException *e) {
    NSLog(@"Caught: %@ - %@", [e name], [e reason]);
}
```

#### Thread Characteristics
- Each thread can catch locally without affecting other threads
- Do not share exception instances between threads

---

### 3.5 NSError - Recoverable Error Information

#### Purpose
Wraps error information in an object suitable for returning as out-parameter or storing. Maps to C `errno` concept with added domain/code specificity.

#### Creation
- `+ errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict` - Create error object
- `+ systemErrorWithErrno:(int)errno_value` - Create from C errno value

#### Properties & Methods
- `- domain` - Error domain string (NSPOSIXErrorDomain, NSCocoaErrorDomain, or custom)
- `- code` - Numeric error code (int)
- `- userInfo` - NSDictionary with details (keys: NSLocalizedDescriptionKey, NSUnderlyingErrorKey, etc.)
- `- localizedDescription` - Human-readable error message from userInfo

#### Common Error Domains
- `NSPOSIXErrorDomain` - POSIX/C library errors (maps errno values)
- `NSCocoaErrorDomain` - mulle-objc/Foundation errors
- Custom application domains (arbitrary strings)

#### Typical Out-Parameter Usage
```objc
NSError *error = nil;
BOOL success = [someObject doSomethingWithError:&error];
if (!success && error) {
    NSLog(@"Error [%@:%d]: %@", [error domain], [error code], [error localizedDescription]);
}
```

#### Distinction from NSException
- **NSException**: For exceptional, unrecoverable conditions; thrown via @throw
- **NSError**: For recoverable, application-level errors; returned or passed as out-parameter

---

### 3.6 NSLocale - Localization & Region Settings

#### Purpose
Represents locale information (language, region, calendar, number/currency formatting) for internationalized applications.

#### Predefined Instances
- `+ defaultLocale` - User's preferred locale
- `+ systemLocale` - System/platform default
- Custom locales via `[[NSLocale alloc] init...]`

#### Key Methods
- `- displayNameForKey:(NSString *)key value:(NSString *)value` - Localized display name
- `- objectForKey:(NSString *)key` - Retrieve locale-specific value

#### Common Locale Keys (NSLocale* constants)
- `NSLocaleLanguageCode` - e.g., "en", "de", "fr"
- `NSLocaleCountryCode` - e.g., "US", "DE", "FR"
- `NSLocaleDecimalSeparator` - "." or "," for decimal point
- `NSLocaleThousandsSeparator` - "," or "." for grouping
- `NSLocaleGroupingSeparator` - Character for digit grouping
- `NSLocaleCurrencyCode` - "USD", "EUR", etc.
- `NSLocaleCalendar` - Calendar system (Gregorian, Islamic, etc.)

#### Use Cases
- NSDateFormatter locale-aware formatting
- NSNumberFormatter locale-aware number/currency formatting
- Dynamic UI element localization

#### Performance
- Locale instances are typically singletons or cached
- Accessing locale properties is O(1)

---

### 3.7 NSNumberFormatter - Number ↔ String Conversion

#### Purpose
Converts bidirectionally between NSNumber and NSString with locale-aware formatting, currency symbols, percentage support.

#### Initialization
- `- init` - Create with default decimal formatting
- `- numberFromString:(NSString *)string` - Parse formatted string to NSNumber
- `- stringFromNumber:(NSNumber *)number` - Format NSNumber to string

#### Format Configuration Methods
- `- setPositiveFormat:(NSString *)format` - Format for positive numbers
- `- setNegativeFormat:(NSString *)format` - Format for negative numbers
- `- setDecimalSeparator:(NSString *)sep` - Override decimal separator
- `- setThousandsSeparator:(NSString *)sep` - Override grouping separator
- `- setNumberStyle:(NSNumberFormatterStyle)style` - Use predefined style

#### Format String Symbols
- `#` - Optional digit placeholder
- `0` - Required digit placeholder (pads with zero)
- `.` - Decimal separator
- `,` - Grouping/thousands separator
- `%` - Multiply by 100 and append % symbol
- `¤` - Currency symbol (replaced with locale symbol)

#### Example Formats
- `"#,##0.00"` → 1234.567 formats as "1,234.57"
- `"0%"` → 0.125 formats as "13%"
- `"¤ #,##0.00"` → 100.00 formats as "$ 100.00" (US locale)

#### Predefined Styles
- Decimal, Percent, Currency, Scientific, etc.

#### Performance
- Format parsing cached after first use
- Reuse formatter instances rather than creating new ones repeatedly

---

### 3.8 NSScanner - Structured Text Parsing

#### Purpose
Parses structured text from an NSString, advancing through the input and extracting typed values (int, float, quoted strings, up to delimiters).

#### Initialization
- `- initWithString:(NSString *)string` - Create scanner for input

#### Query & Position Methods
- `- string` - Access original input string
- `- scanLocation` - Current position (readable/writable); can reset/seek
- `- isAtEnd` - Check if at end of input

#### Scanning Operations (all return BOOL, modify scanLocation on success)
- `- scanInt:(int *)value` - Extract int, advance scanner
- `- scanLongLong:(long long *)value` - Extract long long
- `- scanFloat:(float *)value` / `- scanDouble:(double *)value` - Extract floating-point
- `- scanString:(NSString *)string intoString:(NSString **)result` - Match literal string, capture result
- `- scanUpToString:(NSString *)delimiter intoString:(NSString **)result` - Capture up to delimiter
- `- scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)result` - Capture character set

#### Whitespace Handling
- `- setCharactersToBeSkipped:(NSCharacterSet *)chars` - Skip these characters before each scan operation
- Default skips whitespace

#### Usage Example
```objc
NSScanner *s = [[NSScanner alloc] initWithString:@"name: John, age: 30"];
NSString *name;
int age;
[s scanUpToString:@":" intoString:NULL];  // Skip "name"
[s scanString:@":" intoString:NULL];      // Skip ":"
[s scanString:@" " intoString:NULL];      // Skip space
[s scanUpToString:@"," intoString:&name]; // Get "John"
[s scanString:@"," intoString:NULL];      // Skip ","
[s scanUpToString:@":" intoString:NULL];  // Skip "age"
[s scanString:@":" intoString:NULL];      // Skip ":"
[s scanInt:&age];                          // Get 30
```

#### Performance
- Linear in characters consumed, O(n) per operation
- Caching of delimiter searches happens internally

---

### 3.9 NSNotification & NSNotificationCenter - Publish-Subscribe Messaging

#### NSNotification Structure

##### Creation & Properties
- `+ notificationWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)dict` - Create notification
- `- name` - Notification identifier string
- `- object` - Source object (often nil for broadcasts)
- `- userInfo` - Dictionary of arbitrary data

#### NSNotificationCenter (Singleton Observer Registry)

##### Core Operations

**Observing:**
- `+ defaultCenter` - Retrieve global notification center
- `- addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object` - Register observer
  - If `name` is nil: observer receives all notifications
  - If `object` is nil: observer receives from all objects
  - Otherwise: receive only from specific object posting specific notification

**Posting:**
- `- postNotification:(NSNotification *)notification` - Post notification to all matching observers
- `- postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)dict` - Convenience method

**Cleanup:**
- `- removeObserver:(id)observer name:(NSString *)name object:(id)object` - Unregister observer
- `- removeObserver:(id)observer` - Remove from all notifications

#### Usage Pattern
```objc
// Observer setup (typically in init or viewDidLoad)
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(onDataChanged:)
                                             name:@"DataChangedNotification"
                                           object:nil];

// Publisher posts
[[NSNotificationCenter defaultCenter] postNotificationName:@"DataChangedNotification"
                                                    object:self
                                                  userInfo:@{@"key": @"value"}];

// Receiver method
- (void)onDataChanged:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSLog(@"Received: %@", [info objectForKey:@"key"]);
}

// Cleanup (in dealloc)
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
```

#### Thread Safety Characteristics
- Notifications are posted on the posting thread
- Observers are called synchronously from the posting thread
- Observer must handle any thread-safety needed in receiver code
- Safe to register/unregister from any thread

#### Performance Characteristics
- `addObserver`: O(k) where k = observers for that name (usually small)
- `postNotification`: O(k) - calls all k matching observers synchronously
- `removeObserver`: O(k) - search and remove
- Memory: O(total observers × notification names)

---

### 3.10 NSUndoManager - Undo/Redo Operations

#### Purpose
Records sequences of operations and provides undo/redo functionality for user-interactive applications, maintaining undo/redo stacks.

#### Core Methods

**Recording Operations:**
- `- beginUndoGrouping` - Start recording a group of operations
- `- endUndoGrouping` - End group and register as single undo operation (can be undone atomically)
- `- registerUndoWithTarget:(id)target selector:(SEL)selector object:(id)arg` - Record undo action

**Undo/Redo:**
- `- undo` - Undo last operation group; becomes available for redo
- `- redo` - Redo after undo; becomes available for undo again

**State Queries:**
- `- canUndo` / `- canRedo` - Check if undo/redo available
- `- undoActionName` / `- redoActionName` - Get name/description of next action for UI display
- `- groupingLevel` - Current nesting depth of beginUndoGrouping

**Configuration:**
- `- setLevelsOfUndo:(NSUInteger)levels` - Maximum number of undo operations to retain

#### Undo Model
Maintains two stacks:
- Undo stack: Previous operations that can be undone
- Redo stack: Operations that were undone and can be redone

Each call to `endUndoGrouping` creates one entry on the undo stack. All `registerUndo...` calls between `beginUndoGrouping` and `endUndoGrouping` are grouped as a single atomic operation.

#### Usage Pattern
```objc
NSUndoManager *um = [[NSUndoManager alloc] init];
[um setLevelsOfUndo:20];

// Record operations in a group
[um beginUndoGrouping];
@try {
    NSString *oldValue = [self value];
    [self setValue:newValue];
    [[um prepareWithInvocationTarget:self] setValue:oldValue];
}
@finally {
    [um endUndoGrouping];
}

// User presses undo button
if ([um canUndo]) {
    [um undo];
}
```

#### Important Design Pattern
Each `registerUndoWithTarget:selector:object:` call serves double duty:
1. Records the undo action to restore from current state
2. During undo, the same selector call becomes a redo action

This symmetry allows undo/redo to work without explicitly recording redo separately.

#### Performance
- `registerUndo`: O(1) append to undo stack
- `undo`/`redo`: O(1) stack pop
- Memory: O(levels × average operations per group)

---

### 3.11 NSAssertionHandler - Assertion Failure Handling

#### Purpose
Handles assertion failures (from NSAssert/NSCAssert macros). Allows customization of assertion behavior (default logs to stderr; can be subclassed to throw exceptions).

#### NSAssert Macros
- `NSAssert(condition, format, ...)` - Assert in Objective-C methods
- `NSAssert1(condition, format, arg)` through `NSAssert5(...)` - Variants with 1-5 format arguments
- `NSCAssert(...)` - Variants for C functions

#### Default Handler Behavior
- Logs assertion failure to stderr including file, line, and description
- Does not throw exception (application continues)
- Can be customized by setting a custom assertion handler

#### Customization
Subclass NSAssertionHandler and override:
- `- handleFailureInFunction:file:lineNumber:description:` (for C functions)
- `- handleFailureInMethod:object:file:lineNumber:description:` (for Objective-C methods)

#### Example Usage
```objc
NSUInteger index = 5;
NSAssert(index < count, @"Index %lu out of bounds (count: %lu)", index, count);

// If condition false, logs: "Assertion failure in function X, file Y.m, line N, reason: 'Index 5 out of bounds...'"
```

#### Difference from NSException
- **NSAssert**: For program logic verification; fires at assertion points
- **NSException**: For runtime exceptional conditions; thrown explicitly

---

## 4. Performance Characteristics

### NSCharacterSet
- **Creation**: O(n) where n = number of characters in range or string
- **Membership test**: O(1) for bitmap sets, O(log n) for range-based sets
- **Memory**: Bitmap ~8KB (for full range). Range sets O(m) where m = number of ranges
- **Inversion**: O(n) - creates new set with inverted membership

### NSCalendarDate
- **Component access** (year, month, etc.): O(1) - components cached
- **Date arithmetic**: O(1) - simple arithmetic; calendar lookups are O(1)
- **Timezone conversions**: O(1)
- **Comparisons**: O(1)

### NSDateFormatter
- **Format compilation**: O(1) cached after first use
- **stringFromDate**: O(n) where n = format string length (typically 10-50 chars)
- **dateFromString**: O(n) where n = input string length

### NSScanner
- **scanInt, scanDouble**: O(n) where n = characters to parse (typically 1-20)
- **scanUpToString**: O(n × m) worst case, where n = characters examined, m = delimiter length
- **Position management**: O(1)

### NSNotificationCenter
- **addObserver**: O(k) where k = total observers for that notification name
- **postNotification**: O(k) - calls all k observers synchronously
- **removeObserver**: O(k) - linear search and removal
- **Memory**: O(total observers across all notifications)

### NSUndoManager
- **registerUndo**: O(1) append to undo stack
- **undo/redo**: O(1) stack pop
- **beginGrouping/endGrouping**: O(1)
- **Memory**: O(levels × average operations per group) - can grow large if many operations recorded

### NSNumberFormatter
- **Format compilation**: O(1) cached after first use
- **stringFromNumber**: O(n) where n = number of digits (typically 1-15)
- **numberFromString**: O(n) where n = input string length

### NSLocale
- **objectForKey**: O(1) - hash table lookup
- **displayNameForKey**: O(1) to O(n) depending on implementation

---

## 5. AI Usage Recommendations & Patterns

### Best Practices

**NSCharacterSet:**
- Use predefined class methods (alphanumericCharacterSet, etc.) when possible - they return optimized singletons
- Create custom sets once and reuse rather than recreating on each use
- Cache character sets in static variables if used repeatedly
- Use `characterIsMember:` for simple membership tests

**NSCalendarDate & NSDateFormatter:**
- Always store dates internally as NSDate (timezone-independent seconds since epoch)
- Convert to NSCalendarDate only for display/formatting in user locale
- **CRITICAL**: Cache NSDateFormatter instances; creating new ones in loops is expensive
- Be aware that date arithmetic respects calendar rules (February wraps correctly)
- Validate dates that may come from user input

**NSException vs NSError:**
- **Use NSException for**: Programming errors, invariant violations (array bounds, nil dereferencing expectations)
- **Use NSError for**: User input errors, I/O failures, recoverable conditions
- Never use @try/@catch for normal application control flow
- Always include sufficient information in exception reason for debugging

**NSNotificationCenter:**
- **CRITICAL**: Always unregister observers in dealloc or before object destruction (major memory leak source)
- Post on specific objects (not nil) when possible to reduce broadcast overhead
- Don't pass large objects in userInfo; pass only required data or weak references
- For high-frequency events, consider alternative patterns (delegates, KVO) if performance matters
- Document what notifications your class posts/observes in header comments

**NSLocale:**
- Use `[NSLocale defaultLocale]` for user-facing formatting
- Test locale-dependent code with multiple locales (US, German, Arabic, etc.) to catch i18n bugs
- NSDateFormatter and NSNumberFormatter automatically use current locale when appropriate
- Don't hard-code locale-specific characters (comma vs period for decimals)

**NSScanner:**
- Set `charactersToBeSkipped` appropriately for your input format (usually whitespace)
- Always check return values from scan methods; they silently fail without advancing
- For complex parsing, consider a real parser library or regex if performance allows
- Remember that `scanLocation` can be set to restart/rewind parsing

**NSUndoManager:**
- Group related operations with beginUndoGrouping/endUndoGrouping so they undo as one atomic unit
- Maintain consistency: every undoable operation must have a corresponding redo action
- Don't register undo actions inside undo/redo handlers (infinite recursion)
- Set `levelsOfUndo` appropriately; unlimited undo can consume significant memory

### Common Pitfalls

**NSCharacterSet:**
- Assuming single Unicode scalars (emoji, combining diacriticals consume multiple scalars)
- Creating bitmap for full Unicode range (~130K characters) is memory-inefficient; use range sets
- Not testing with non-ASCII/non-Latin characters

**NSCalendarDate:**
- Forgetting timezone conversions in international applications
- Assuming February always has 28 days (leap years have 29)
- Not validating component values (month=13 is invalid)
- Date arithmetic with timezones requires careful handling

**NSDateFormatter:**
- Creating new formatter in tight loops (major performance anti-pattern)
- Format strings platform/locale-dependent; must test with multiple locales
- Natural language parsing (`allowNaturalLanguage:YES`) is slow and platform-dependent
- Not checking for nil return from `dateFromString:` on parse failure

**NSException:**
- Using @catch for normal flow control instead of error handling
- Catching NSException at top-level without understanding exception names
- Not including enough context in reason string for debugging
- Throwing exceptions too liberally (should indicate truly exceptional conditions)

**NSError:**
- Not checking for nil before dereferencing error out-parameter
- Assuming error is non-nil when method returns NO (check documentation)
- Not preserving underlying errors with NSUnderlyingErrorKey
- Not localizing error descriptions for user-facing display

**NSNotificationCenter:**
- Registering observer but never unregistering (memory leak when observer deallocated)
- Assuming notifications are thread-safe (they're not; handle threading in observer code)
- Posting with nil object when filtering by object (observer never receives)
- Race conditions when registering/unregistering from different threads

**NSLocale:**
- Hard-coding locale-specific formatting (uses locale default instead)
- Ignoring that some calendars are non-Gregorian
- Not testing with right-to-left languages (Arabic, Hebrew)

**NSScanner:**
- Not checking `isAtEnd` before calling scan methods
- Assuming scan methods return success/failure (they return BOOL but silently fail)
- Forgetting that `scanLocation` can be set to restart parsing
- Complex parsing attempts with NSScanner when regex would be clearer

**NSUndoManager:**
- Not calling `removeObserver:` before deallocating undo manager
- Recording undo actions that modify application state inconsistently
- Registering undo inside undo handlers (recursion)
- Not testing undo/redo flows with edge cases

### Idiomatic Usage Patterns

**Pattern 1: Safe Formatter Reuse (Static Cache)**
```objc
static NSDateFormatter *formatter = nil;
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] 
                 initWithDateFormat:@"%Y-%m-%d %H:%M:%S"
                    allowNaturalLanguage:NO];
});
NSString *formatted = [formatter stringFromDate:[NSDate date]];
```

**Pattern 2: Safe Parsing with NSScanner**
```objc
NSScanner *scanner = [[NSScanner alloc] initWithString:input];
[scanner setCharactersToBeSkipped:
    [NSCharacterSet characterSetWithCharactersInString:@" \""]];
int intVal;
double doubleVal;
BOOL success = [scanner scanInt:&intVal] && [scanner scanDouble:&doubleVal];
if (success && [scanner isAtEnd]) {
    // Successfully parsed entire input
} else {
    NSLog(@"Parse failed at position %lu", [scanner scanLocation]);
}
[scanner release];
```

**Pattern 3: Exception Handling with Context**
```objc
@try {
    [self validateAndProcess:data];
} @catch (NSException *e) {
    if ([[e name] isEqualToString:NSRangeException]) {
        NSLog(@"Index error: %@", [e reason]);
    } else if ([[e name] isEqualToString:NSInvalidArgumentException]) {
        NSLog(@"Invalid argument: %@", [e reason]);
    } else {
        @throw;  // Re-throw unexpected exceptions
    }
}
```

**Pattern 4: Notification with Type-Safe UserInfo**
```objc
// Post with typed userInfo keys
#define kMyNotificationDataKey @"data"
#define kMyNotificationErrorKey @"error"

[[NSNotificationCenter defaultCenter] 
    postNotificationName:@"OperationCompleted"
                  object:self
                userInfo:@{kMyNotificationDataKey: result ?: [NSNull null],
                           kMyNotificationErrorKey: error ?: [NSNull null]}];

// Receive with safe unwrapping
- (void)onOperationCompleted:(NSNotification *)notif {
    NSDictionary *info = [notif userInfo];
    id data = [info objectForKey:kMyNotificationDataKey];
    NSError *error = [info objectForKey:kMyNotificationErrorKey];
    if (error != (id)[NSNull null]) {
        [self handleError:error];
    } else {
        [self processData:data];
    }
}
```

**Pattern 5: Grouped Undo Operations**
```objc
[undoManager beginUndoGrouping];
@try {
    [self setProperty1:value1];
    [self setProperty2:value2];
    [self setProperty3:value3];
    // Register corresponding undo actions
} @finally {
    [undoManager endUndoGrouping];
}
```

---

## 6. Integration Examples

### Example 1: Date Parsing and Formatting with Timezone

```objc
#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

int main(void) {
    // Create a calendar date from components
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSCalendarDate *date = [NSCalendarDate dateWithYear:2025 month:11 day:8
                                                   hour:21 minute:18 second:26
                                               timeZone:tz];
    
    NSLog(@"Date: %@", date);
    NSLog(@"Day of week: %d", [date dayOfWeek]);
    NSLog(@"Day of year: %d", [date dayOfYear]);
    
    // Format the date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] 
                                 initWithDateFormat:@"%A, %B %d, %Y at %I:%M %p"
                                allowNaturalLanguage:NO];
    NSString *formatted = [formatter stringFromDate:date];
    NSLog(@"Formatted: %@", formatted);
    
    [formatter release];
    return 0;
}
```

### Example 2: Character Set Validation

```objc
// Validate username contains only safe characters
NSString *username = @"user_name-123";
NSCharacterSet *safeChars = [NSCharacterSet alphanumericCharacterSet];
NSCharacterSet *allowedSpecial = [NSCharacterSet characterSetWithCharactersInString:@"_-"];

BOOL isValid = YES;
for (NSUInteger i = 0; i < [username length]; i++) {
    unichar c = [username characterAtIndex:i];
    if (![safeChars characterIsMember:c] && ![allowedSpecial characterIsMember:c]) {
        isValid = NO;
        break;
    }
}

if (!isValid) {
    [NSException raise:NSInvalidArgumentException
               format:@"Username contains invalid characters"];
}
```

### Example 3: Number Formatting with Locale

```objc
NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
[formatter setLocale:[NSLocale defaultLocale]];
[formatter setPositiveFormat:@"#,##0.00"];

NSNumber *num = [NSNumber numberWithDouble:1234.567];
NSString *formatted = [formatter stringFromNumber:num];
// US locale: "1,234.57"
// German locale: "1.234,57"

[formatter release];
```

### Example 4: Exception Handling with Bounds Checking

```objc
@interface MyArray : NSObject {
    NSMutableArray *array;
}
- (id)objectAtIndex:(NSUInteger)index;
@end

@implementation MyArray
- (id)objectAtIndex:(NSUInteger)index {
    if (index >= [array count]) {
        [NSException raise:NSRangeException
                   format:@"Index %lu out of bounds (count: %lu)",
                           index, [array count]];
    }
    return [array objectAtIndex:index];
}
@end

// Usage
@try {
    id obj = [container objectAtIndex:100];
} @catch (NSException *e) {
    if ([[e name] isEqualToString:NSRangeException]) {
        NSLog(@"Caught range error: %@", [e reason]);
    }
}
```

### Example 5: Notification-Based Event System

```objc
// Observer setup
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(onDataUpdated:)
                                             name:@"DataModelDidUpdate"
                                           object:nil];

// Publisher posts
NSError *error = nil;
id result = [model performOperation:&error];
NSDictionary *userInfo = @{
    @"result": result ?: [NSNull null],
    @"error": error ?: [NSNull null],
    @"timestamp": [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
};
[[NSNotificationCenter defaultCenter] 
    postNotificationName:@"DataModelDidUpdate"
                  object:self
                userInfo:userInfo];

// Receiver handles notification
- (void)onDataUpdated:(NSNotification *)notif {
    NSDictionary *info = [notif userInfo];
    id result = [info objectForKey:@"result"];
    NSError *error = [info objectForKey:@"error"];
    
    if (error != (id)[NSNull null]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else if (result != (id)[NSNull null]) {
        NSLog(@"Result: %@", result);
    }
}

// Cleanup in dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
```

### Example 6: Simple Text Parsing with NSScanner

```objc
// Parse CSV-like line: 42, 3.14, "text value"
NSString *csvLine = @"42, 3.14, \"text value\"";
NSScanner *scanner = [[NSScanner alloc] initWithString:csvLine];
[scanner setCharactersToBeSkipped:
    [NSCharacterSet characterSetWithCharactersInString:@" \""]];

int intVal;
double doubleVal;
NSString *stringVal;

if ([scanner scanInt:&intVal] &&
    [scanner scanDouble:&doubleVal] &&
    [scanner scanString:@"," intoString:NULL] &&
    [scanner scanUpToString:@"\"" intoString:&stringVal]) {
    NSLog(@"Parsed: int=%d, double=%f, string='%@'", intVal, doubleVal, stringVal);
} else {
    NSLog(@"Parse error at position %lu", [scanner scanLocation]);
}

[scanner release];
```

---

## 7. Dependencies

Direct dependencies from `.mulle/etc/sourcetree/config`:

- **MulleObjC** - Objective-C runtime foundation
- **MulleObjCValueFoundation** - NSNumber, NSString, NSData, NSValue
- **MulleObjCContainerFoundation** - NSArray, NSSet, NSDictionary, mutable variants
- **MulleObjCTimeFoundation** - NSDate, NSTimer, time utilities
- **MulleObjCCalendarFoundation** - NSCalendar, NSDateComponents
- **MulleObjCMathFoundation** - NSDecimalNumber, math functions
- **MulleObjCUnicodeFoundation** - Unicode operations, properties
- **MulleObjCUUIDFoundation** - NSUUID generation and validation
- **MulleObjCArchiverFoundation** - NSCoder, NSKeyedArchiver serialization
- **MulleObjCPlistFoundation** - Property list encoding/decoding
- **MulleObjCRegexFoundation** - Regular expression support
- **MulleObjCExpatFoundation** - XML parsing via libexpat
- **MulleObjCKVCFoundation** - Key-value coding support
- **MulleObjCOSFoundation** - File I/O, environment variables, OS interfaces

This library aggregates all these components and provides the key classes documented above, forming the primary Foundation import for most MulleObjC applications.
