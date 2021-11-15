# MulleObjCStandardFoundation

#### 🚤 Objective-C classes based on the C standard library

This library builds on [MulleObjCValueFoundation](/MulleObjCValueFoundation) 
and [MulleObjCContainerFoundation](/MulleObjCContainerFoundation) and 
introduces a lot of additional classes.

But it does not I/O (not even `stdio`). I/O is provided by 
MulleObjCOSFoundation.


#### Classes

Class                  | Description
-----------------------|-----------------
`NSAssertionHandler`   | Used by `NSAssert()`
`NSCalendarDate`       | A composition of `NSDate` and `NSTimeZone`
`NSCharacterSet`       | Character classification like `<ctype.h>`
`NSDateFormatter`      | `NSDate` to `NSString` representation
`NSError`              | A wrapper for `<errno.h>`
`NSException`          | Exceptions for @throw
`NSFormatter`          | Object to `NSString` representation
`NSLocale`             | Localization support
`NSNotification`       | Message encapsulation for `NSNotificationCenter`
`NSNotificationCenter` | Publish/subscribe message sending
`NSNumberFormatter`    | `NSNumber` to `NSString` representation
`NSScanner`            | Parse from `NSString` into `NSNumber`
`NSSortDescriptor`     |
`NSTimeZone`           |
`NSUndoManager`        |


### You are here

```
   .-------------------------------------------------------------------.
   | MulleFoundation                                                   |
   '-------------------------------------------------------------------'
   .----------------------------.
   | Calendar                   |
   '----------------------------'
   .----------------------------.
   | OS                         |
   '----------------------------'
           .--------------------..----------..-----..---------.
           | Plist              || Archiver || KVC || Unicode |
           '--------------------''----------''-----''---------'
           .==================================================..-------.
           | Standard                                         || Math  |
           '==================================================''-------'
   .------..-----------------------------..----------------------------.
   | Lock || Container                   || Value                      |
   '------''-----------------------------''----------------------------'
   .-------------------------------------------------------------------.
   | MulleObjC                                                         |
   '-------------------------------------------------------------------'
```


## Install

See [foundation-developer](//github.com//foundation-developer) for
installation instructions.

## License

Parts of this library:

```
Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)
[Christoper LLoyd](https://github.com/cjwl)
