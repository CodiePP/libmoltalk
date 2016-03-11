
declared in [MTModule](MTModule.hpp.md)

~~~ { .cpp }

void MTModule::register_functor(std::string const & fn, t_functor1 const & f)
{
	_pimpl->register_functor(fn, f);
}

void MTModule::pimpl::register_functor(std::string const fn, MTModule::t_functor1 f)
{
	std::clog << " register_functor " << fn << std::endl;
	_functors1.push_back({ fn, f });
}

MTModule::t_functor1 MTModule::pimpl::find_functor1(std::string const & fun) const
{
	for (auto f : _functors1) {
		std::clog << " find_functor1  '" << fun << "' == " << f._name << std::endl;
		if (fun == f._name) { return f._functor; }
	}
	return nullptr;
}

void MTModule::fun1(std::string const & fun, MTDataKV & p) const
{
	auto _f = _pimpl->find_functor1(fun);
	if (_f) {
		std::clog << "FOUND functor " << fun << std::endl;
		_f(p);
	}
}

~~~
