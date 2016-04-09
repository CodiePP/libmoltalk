~~~ { .cpp }

#include "MTModuleLoader.hpp"

#include <iostream>
#include <dlfcn.h>

#include "boost/filesystem.hpp"

namespace mt {

#ifdef Linux
        extern MTModule* load_linux(const char *);
#endif
#ifdef Windows
        extern MTModule* load_win(const char *);
#endif

~~~

