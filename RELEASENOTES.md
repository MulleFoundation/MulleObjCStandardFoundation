### 0.22.4














* exception and range messages use proper size-format specifiers (e.g. %tu) to avoid incorrect formatting/UB when reporting indexes/ranges
* diagnostic output replaced with `mulle_fprintf` and unused-parameter warnings suppressed across multiple sources to reduce noisy compiler warnings and improve consistency
