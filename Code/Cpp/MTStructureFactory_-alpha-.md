~~~ { .cpp }

#include "MTStructureFactory.hpp"
#include "MTStructure.hpp"
#include "MTPDBParser.hpp"

#include "boost/format.hpp"
#include "boost/filesystem.hpp"
#include "boost/iostreams/filtering_streambuf.hpp"
#include "boost/iostreams/copy.hpp"
#include "boost/iostreams/filter/gzip.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <cmath>

namespace mt {

static int _instance_counter = 0;

int IStructureFactory::instance_count() { return _instance_counter; }

~~~

