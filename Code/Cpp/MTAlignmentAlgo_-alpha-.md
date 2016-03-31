
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }

#include "MTAlignmentAlgo.hpp"
#include "MTSubstitutionMatrix.hpp"
#include "MTResidue.hpp"
#include "MTChain.hpp"
#include "MTChainFactory.hpp"

#include <iostream>
#include <cstring>

#include "boost/format.hpp"

namespace mt {

#define GAPOPENINGPENALTY 10.0f 
#define GAPEXTENDPENALTY 1.0f

~~~
