~~~ { .cpp }

#include "MTResidueFactory.hpp"
#include "MTResidue.hpp"

#include <iostream>
#include <sstream>
#include <cmath>

namespace mt {

static int _instance_counter = 0;

int IResidueFactory::instance_count() { return _instance_counter; }

~~~

