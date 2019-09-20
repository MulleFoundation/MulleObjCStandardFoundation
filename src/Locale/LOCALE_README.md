# Locale

Much of the locale handling is OS specific and will be augmented by
the POSIX foundation, which queries the C locale info.

Additionally libicu will provide most if not all of the missing functionality
later in a separate library.

This part of the Foundation is very incomplete still, especially with
regard to "localizedDescription" implementations.

For a minimal Foundation, this could be left out, but not having the formatters
might hurt more than it helps.

## Categories

Categories contains categories on classes, that are defined not in Locale.
