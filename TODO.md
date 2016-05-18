# Problems

* aba problem with [NSAutoreleasePool new] when no thread is setup

   * must use NSAutoreleasePush()
   * compiler emits NSAutoreleasePush()  instead of [[NSAutoreleasePool alloc] init]

# Improve

* unify Thread/Pool code with  NSAutoreleasePush
