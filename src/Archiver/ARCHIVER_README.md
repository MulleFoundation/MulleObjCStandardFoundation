# Archiver

NSCoder and friends. Could be left out, if you want to create a slimmer
Foundation. Archiving is not that essential usually.

## Classcluster support

If `-initWithCoder:` returns a different object than self, you must:

* write your decoding routine in `decodeWithCoder:`
* return the instance of the proper class with `-initWithCoder:`
* you may decode in `-initWithCoder:` if you are not referencing other objects in the archive (e.g. NSData: YES, NSArray: NO). You still need a `decodeWithCoder:` though, that does nothing.

TODO: MOVE IT OUTSIDE ?