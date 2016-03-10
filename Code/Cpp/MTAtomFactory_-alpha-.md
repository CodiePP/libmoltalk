
declared in [MTAtomFactory](MTAtomFactory.hpp.md)

~~~ { .cpp }

#include "MTAtomFactory.hpp"
#include "MTAtom.hpp"

#include <iostream>
#include <sstream>
#include <cmath>

namespace mt {

static int _instance_counter = 0;

int IAtomFactory::instance_count() { return _instance_counter; }

~~~

