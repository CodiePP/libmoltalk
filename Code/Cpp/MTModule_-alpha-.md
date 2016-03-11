~~~ { .cpp }

#include "MTModule.hpp"
#include "MTStructure.hpp"
#include "MTChain.hpp"
#include "MTResidue.hpp"
#include "MTAtom.hpp"

#include <iostream>
#include <sstream>
#include <dlfcn.h>

namespace mt {

struct MTModule::pimpl {

	virtual ~pimpl();

	std::string _name;

	typedef struct {
		std::string _name;
		MTModule::t_functor1 _functor;
	} t_fun1;

	std::list<t_fun1> _functors1;

	MTModule::t_functor1 find_functor1(std::string const &) const;

	void register_functor(std::string const, MTModule::t_functor1);
};

~~~

