~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"
#include "boost/assign/list_of.hpp"
#include "boost/tuple/tuple.hpp"

#include "MTModule.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTModule
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTModule )

class MyModule : public mt::MTModule
{
public:
	MyModule() : mt::MTModule() { registerFunctors(); }
	virtual ~MyModule() {}

	virtual int registerFunctors();
	virtual std::string name() const override { return "MyModule"; }
	virtual std::string version() const override { return "1.0.0"; }
private:
	void doing_something(mt::MTDataKV & p);
	void doing_something_else(mt::MTDataKV & p);
};

int MyModule::registerFunctors()
{
	// a function can be entered using *std::bind*
	mt::MTModule::t_functor1 f1 = std::bind(&MyModule::doing_something,this,std::placeholders::_1);
	register_functor("doing_something" , f1);

	// or via a *lambda*
	register_functor("doing_something_else" , [this](mt::MTDataKV & o){ this->doing_something_else(o); });

	return 2;
}

void MyModule::doing_something(mt::MTDataKV & o)
{
	std::clog << "doing_something" << std::endl;
	o.set("result", 42L);
}
void MyModule::doing_something_else(mt::MTDataKV & o)
{
	std::clog << "doing_something_else" << std::endl;
	o.set("result2", 42.0);
}
~~~

# Test case: call_fun1
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( call_fun1 )
{
	MyModule m;
	mt::MTDataKV _m;
	_m.set("t1", 42.0); _m.set("t2", "42.0");
	m.fun1("doing_something", _m);
	long l;
	BOOST_CHECK(_m.get("result", l));
	BOOST_CHECK_EQUAL(l, 42L);
	m.fun1("doing_something_else", _m);
	double d;
	BOOST_CHECK(_m.get("result2", d));
	BOOST_CHECK_EQUAL(d, 42.0);
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

