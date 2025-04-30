# MulleObjCStandardFoundation

#### 🚤 Objective-C classes based on the C standard library

This library builds on [MulleObjCValueFoundation](//github.com/MulleFoundation/MulleObjCValueFoundation)
and [MulleObjCContainerFoundation](//github.com/MulleFoundation/MulleObjCContainerFoundation) and
introduces a lot of additional classes.

But it does not I/O (not even `stdio`). I/O is provided by 
MulleObjCOSFoundation.


| Release Version                                       | Release Notes  | AI Documentation
|-------------------------------------------------------|----------------|---------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCStandardFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCStandardFoundation/workflows/CI/badge.svg)](//github.com/MulleFoundation/MulleObjCStandardFoundation/actions) | [RELEASENOTES](RELEASENOTES.md) | [DeepWiki for MulleObjCStandardFoundation](https://deepwiki.com/MulleFoundation/MulleObjCStandardFoundation)


## API

### Classes

| Class                  | Description
|------------------------|-----------------
| `NSAssertionHandler`   | Used by `NSAssert()`
| `NSCalendarDate`       | A composition of `NSDate` and `NSTimeZone`
| `NSCharacterSet`       | Character classification like `<ctype.h>`
| `NSDateFormatter`      | `NSDate` to `NSString` representation
| `NSError`              | A wrapper for `<errno.h>`
| `NSException`          | Exceptions for @throw
| `NSFormatter`          | Object to `NSString` representation
| `NSLocale`             | Localization support
| `NSNotification`       | Message encapsulation for `NSNotificationCenter`
| `NSNotificationCenter` | Publish/subscribe message sending
| `NSNumberFormatter`    | `NSNumber` to `NSString` representation
| `NSScanner`            | Parse from `NSString` into `NSNumber`
| `NSSortDescriptor`     |
| `NSTimeZone`           |
| `NSUndoManager`        |





## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [MulleObjCTimeFoundation](https://github.com/MulleFoundation/MulleObjCTimeFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCTimeFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCTimeFoundation/workflows/CI/badge.svg?branch=release)](https://github.com/MulleFoundation/MulleObjCTimeFoundation/actions/workflows/mulle-sde-ci.yml) | 💰 MulleObjCTimeFoundation provides time classes
| [MulleObjCValueFoundation](https://github.com/MulleFoundation/MulleObjCValueFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCValueFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCValueFoundation/workflows/CI/badge.svg?branch=release)](https://github.com/MulleFoundation/MulleObjCValueFoundation/actions/workflows/mulle-sde-ci.yml) | 💶 Value classes NSNumber, NSString, NSDate, NSData
| [MulleObjCContainerFoundation](https://github.com/MulleFoundation/MulleObjCContainerFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleFoundation/MulleObjCContainerFoundation.svg) [![Build Status](https://github.com/MulleFoundation/MulleObjCContainerFoundation/workflows/CI/badge.svg?branch=release)](https://github.com/MulleFoundation/MulleObjCContainerFoundation/actions/workflows/mulle-sde-ci.yml) | 🛍 Container classes like NSArray, NSSet, NSDictionary
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-list.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-list/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-list/actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.

### You are here

![Overview](overview.dot.svg)

## Add

**This project is a component of the [MulleFoundation](//github.com/MulleFoundation/MulleFoundation) library.
As such you usually will *not* add or install it individually, unless you
specifically do not want to link against `MulleFoundation`.**


### Add as an individual component

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjCStandardFoundation to your project:

``` sh
mulle-sde add github:MulleFoundation/MulleObjCStandardFoundation
```

To only add the sources of MulleObjCStandardFoundation with dependency
sources use [clib](https://github.com/clibs/clib):


``` sh
clib install --out src/MulleFoundation MulleFoundation/MulleObjCStandardFoundation
```

Add `-isystem src/MulleFoundation` to your `CFLAGS` and compile all the sources that were downloaded with your project.


## Install

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjCStandardFoundation and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/MulleFoundation/MulleObjCStandardFoundation/archive/latest.tar.gz
```

### Legacy Installation

Install the requirements:

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [MulleObjCTimeFoundation](https://github.com/MulleFoundation/MulleObjCTimeFoundation)             | 💰 MulleObjCTimeFoundation provides time classes
| [MulleObjCValueFoundation](https://github.com/MulleFoundation/MulleObjCValueFoundation)             | 💶 Value classes NSNumber, NSString, NSDate, NSData
| [MulleObjCContainerFoundation](https://github.com/MulleFoundation/MulleObjCContainerFoundation)             | 🛍 Container classes like NSArray, NSSet, NSDictionary
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

Download the latest [tar](https://github.com/MulleFoundation/MulleObjCStandardFoundation/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/MulleFoundation/MulleObjCStandardFoundation/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleObjCStandardFoundation** into `/usr/local` with [cmake](https://cmake.org):

``` sh
PREFIX_DIR="/usr/local"
cmake -B build                               \
      -DMULLE_SDK_PATH="${PREFIX_DIR}"       \
      -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
      -DCMAKE_PREFIX_PATH="${PREFIX_DIR}"    \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```

## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  


