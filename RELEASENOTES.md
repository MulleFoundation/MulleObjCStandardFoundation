### 0.20.1

* change GLOBAL for Windows

## 0.20.0

* **breaking** the container callbacks for -describe now return a UTF8 string not a NSString. This is incompatible with legacy Foundation!
* improvements in NSNumberFormatter
* improvements in escaping and unescaping strings

## 0.19.0

* split off MulleObjCArchiverFoundation and MulleObjCPlistFoundation
* changed propertylist formatting a bit for compatibility and ease of reuse
* changed property list output to match newer Apple output
* added `-[NSString mulleStringByAppendingComponent:separatedByString:]`
* renamed "MulleData" methods and functions to "CData"


## 0.18.0

* +`[NSError mulleSetGenericErrorWithDomain:localizedDescription]` and `+mulleGenericErrorWithDomain:localizedDescription:` added
* fix bugs in backward characterSet search
* fix ``_mulleDataSeparateComponentsByString:``
* improve property list serialization
* NSPropertyListSerialization gains a mullePropertyListFromData:mutabilityOption:format:formatOption: method
* greatly improved property list printing (serialization)
* moved some internal string creation code to MulleObjCValueFoundation
* moved NSData+Unicode to MulleObjCValueFoundation
* much improved NSScanner code (but not complete yet)
* much improved `lowercaseString` and `uppercaseString`
* much improved component separation code
* use ``mulleFastGetUTF8Data_:`` and family instead of `mulleFastUTF8Characters` and family
* fix non-unicode characterset routines to only return true BOOL values


### 0.17.2

* remove duplicate objc-loader.inc

### 0.17.1

* * moved unicode functionality to MulleObjCUnicodeFoundation, basic ctype functionality remains

## 0.17.0

* expose MulleObjCStream and family
* added `mullePropertyListDescription` and `mulleJSONDescription` to property list classes
* added `mulleURLAllowedCharacterSet` to NSCharacterSet
* there exist now functions and methods to create mutable arrays from string components such as `mulleMutableComponentsSeparatedByString:`
* declare some NSCharacterSet methods as returning `instancetype` now
* adapt to changes in MulleObjC
* renamed `_GMTTimeZone` to `mulleGMTTimeZone`
* exception functions like MulleObjCThrowErrnoException are now vectored via MulleObjC
* NSPropertyListOpenStepFormat is now MullePropertyListLooseOpenStepFormat and MullePropertyListStrictOpenStepFormat is NSPropertyListOpenStepFormat, which should make the behaviour somewhat less surprising
* split off parts to MulleObjCStandardFoundation
* split off parts to MulleObjCValueFoundation
* rewrote and fixes the mulle-specific parts of `NSError` and the lazy generation of errors

## 0.16.0

* extracted startup code into seperate project
* deprecated mutableCopy experimentally (would like to move towards nil == empty array)
* added -mulleFirstObject to NSArray
* added -mulleArrayByRemovingObject: to NSArray
* added -mulleReverseObjects to NSMutableArray
* adapted to changes in the container callback mechanism with respect to „describe“
* added mulleDictionaryByRemovingObjectForKey: to NSDictionary
* added mulleSetRetainedObject:forKey: to NSMutableDictionary
* added mulleGenericErrorWithDomain:localizedDescription: to NSError
* redid NSDateFormatter, NSNumberFormatter, NSTimeZone class variable handling
* improved NSLocale a bit (for the benefit of NSBundle)
* bugfixed NSNotificationCenter and reversed the call order
* improved propertyList parsing with `/* */` comments
* added `mulle_unichar_strlen` and family
* added mulleAppendCharacters:length: to NSMutableString
* added mulleStringByReplacingCharactersInSet:withCharacter: to NSString
* renamed `_rangeOfCharactersFromSet:options:range:` to mulleRangeOfCharactersFromSet:options:range: in NSString
* added MulleStringEncodingCStringDescription function to convert the enum to string
* implemented the initWithFormat: method on NSString, which was strangely missing (?)
* added mulleStringByRemovingPrefix: and mulleStringByRemovingSuffix: to NSString
* NSDate supports NSCopying now
* fixed hashing of NSValue and NSNumber to be compatible with each other
* added NSMutableCharacterSet and greatly debugged/improved NSCharacterSet


### 0.15.2

* adapt to readonly properties not being cleared anymore

### 0.15.1

* fix leaks in `mulleGMTTimeZone` and cheatingASCIIstring UTF8String

## 0.15.0

* use fast enumeration throughout now
* improved class cluster behavior, especially when subclassing
* renamed many but not all `_methods` to mulleMethods to distinguish between private and incompatible
* improved NSError, NSPropertyListSerialization, NSValue, NSNull, NSString
* big changes to plug leaks and fix initializers
* improved propertylist parsing and printing
* improved -description for containers
* adapted to changes in MulleObjC especially in regard to placeholders, singletons and deinitialization
* bug and leak fixed NSNotificationCenter now uses new `_mulle_pointerqueue` now


### 0.14.1

* modernized mulle-sde with .mulle folder

## 0.14.0

* modernized project structure


### 0.13.3

* modernize mulle-sde, remove obsolete file

### 0.13.2

* fix for mingw

### 0.13.1

* fix tests

## 0.13.0

* migrated to mulle-sde


### 0.12.1

* migrated from mulle-homebrew to mulle-project
* adapt to MulleObjC 0.12.2

# 0.9.1

* keep version in step with MulleObjC for now (will diverge later)
* make it a cmake "C" project

# 0.2.0

* Start of versioning. Keep this version number in sync with MulleObjC!
