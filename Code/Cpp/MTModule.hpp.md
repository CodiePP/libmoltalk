~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTDataKV.hpp"

#include <memory>
#include <string>
#include <functional>


// add this to the module's header
#define DECLARE_MT_MODULE() \\
	extern "C" mt::MTModule* create_module();

// add this to the module's implementation source code
#define DEFINE_MT_MODULE( name ) \\
	static name * _shared_module_instance = new name(); \\
	extern "C" mt::MTModule* create_module() { return _shared_module_instance; }
~~~

namespace [mt](namespace_mt.list) {

# class MTModule

~~~ { .cpp }
{
public:

/* 
 *  every MTModule instance
 *  implementes this callbacks: get_module()
 *
 */
~~~

## /* functors */

// setting up the registered functors.

>virtual int registerFunctors() = 0;

// calling the registered functors.

>virtual void [fun1](MTModule_functors.cpp.md)(std::string const & fun, MTDataKV & p) const ;

protected:

>typedef std::function\\<void(MTDataKV &)\\> t_functor1;

>void register_functor(std::string const &, t_functor1 const &);

## /* creation */

public: 

>[MTModule](MTModule_ctor.cpp.md)();

>virtual [~MTModule](MTModule_dtor.cpp.md)();

>virtual std::string name() const = 0;

>virtual std::string version() const = 0;

## /* brewery */

>//[code header](MTModule_-alpha-.md)

>//[code trailer](MTModule_-omega-.md)

private:

> MTModule(MTModule const &) = delete;

> MTModule & operator=(MTModule const &) = delete;

>struct pimpl;

>std::unique_ptr\\<pimpl\\> _pimpl;

~~~ { .cpp }
};

} // namespace
~~~

