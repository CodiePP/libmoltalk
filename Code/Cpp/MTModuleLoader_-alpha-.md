~~~ { .cpp }

#include "MTModuleLoader.hpp"

#include <iostream>
#include <sstream>
#include <dlfcn.h>

#include "boost/filesystem.hpp"

namespace mt {

struct MTModuleLoader::pimpl {

	std::string _name;

};

~~~

