~~~ { .cpp }

#include "MTChainFactory.hpp"
#include "MTChain.hpp"

#include <iostream>
#include <sstream>
#include <cmath>

namespace mt {

static int _instance_counter = 0;

int IChainFactory::instance_count() { return _instance_counter; }

~~~

