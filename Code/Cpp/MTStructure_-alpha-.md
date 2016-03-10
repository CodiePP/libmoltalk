~~~ { .cpp }

#include "MTStructure.hpp"
#include "MTChain.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"
#include "MTCoordinates.hpp"

#include <iostream>
#include <list>
#include <vector>
#include <algorithm>

namespace mt {

struct MTStructure::pimpl {
	pimpl();
	virtual ~pimpl();
	unsigned int _nmodels { 1 };
	unsigned int _currmodel { 1 };
        std::vector< std::list<std::shared_ptr<MTChain>> > _models;
	std::list<std::shared_ptr<MTChain>> & _chains() { return _models.at(_currmodel-1); }
};

MTStructure::pimpl::pimpl()
{
	_models.push_back( std::list<std::shared_ptr<MTChain>>() );
}

MTStructure::pimpl::~pimpl()
{
}
~~~

