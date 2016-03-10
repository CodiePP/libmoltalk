
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }

#include "MTAtom.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"
#include "MTCoordinates.hpp"

#include <iostream>
#include <sstream>
#include <algorithm>

namespace mt {

struct _atm_s {
	double _x,_y,_z;
        MTAtom::element_id _element;
        float _temperature;
        float _charge;
	unsigned int _serial;
};

static const int _max_atm = 99999;
static _atm_s _atm_tbl[_max_atm];

static int _atm_count = 0;

~~~

