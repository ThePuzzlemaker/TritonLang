# Triton Preprocessor Operations, Macros, and Directives

```cpp

/*
Triton Preprocessor Operations, Macros, and Directives
======================================================
*/

/*
========
Includes
========
*/


// Includes the core library header "io"
#include <io>
// Includes the non-core library header "eeklib"
#include <eeklib.h>
// Includes the local library header "eekifier"
#include "eekifier.h"

// Defines the identifier EEK
#define EEK
// Defines the macro EEK to add "EEK " to the end of string str
#define EEKIFIER(str) str+"EEK"
// Undefines EEK
#undef EEK
// Redefines EEK to equal 1
#define EEK 1

/*
=============
If Statements
=============
*/

// Checks if EEK == 1
#if EEK==1
// Logs "Heyo!"
io::info("Heyo!");
// Checks if EEK == 2 (which it doesn't)
#elif EEK==2
// Logs "Impossible!"
io::info("Impossible!");
// Else case
#else
// Logs "Also impossible!"
io::info("Also impossible!");
// Ends if statement
#endif

// Check if EEK is defined
#ifdef EEK
// Log "EEK exists!"
io::info("EEK exists!");
// Check if EEK2 is defined
#elifdef EEK2
// Log "EEK2 exists!"
io::info("EEK2 exists!");
// Else case (neither exists)
#else
// Logs "NEITHER exists!"
io::info("NEITHER exists!");
// Ends if statement
#endif

// Check if EEK is NOT defined
#ifndef EEK
// Logs "EEK doesn't exist!"
io::info("EEK doesn't exist!");
// Checks if EEK2 is NOT defined
#elifndef EEK2
// Logs "EEK2 doesn't exist!"
io::info("EEK2 doesn't exist!");
// Else case (both exist)
#else
// Logs "BOTH exist!"
io::info("BOTH exist!");
// Ends if statement
#endif

// Checks if EEK2 is defined
#ifdef EEK2
// Throws error (preprocessor fails)
#error Oh no, EEK2 exists!
// Ends if statement
#endif

// No-op (does nothing, just wastes your space)
# 

/*
==================
Pre-defined Macros
==================
*/

// Logs the version of the Triton Preprocessor
io::info(__TTNPRE_VERSION__);
// Logs the version of the Triton Compiler
io::info(__TTNCMP_VERSION__);
// Logs the version of the Triton Linker
io::info(__TTNLNK_VERSION__);
// Logs the current filename (in this example, "Preprocessor.pscttn")
io::info(__FILE__);
// Logs the current line in the file (in this example, 105)
io::info(__LINE__);

// Function main(), return value int
int main() {
// Logs the current function name as a string (in this example, "main")
  io::info(__FUNC__);
}

```