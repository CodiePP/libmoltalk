~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTVector.hpp"
#include "MTMatrix.hpp"
#include "MTMatrix53.hpp"
#include "MTMatrix44.hpp"
#include "MTCoordinates.hpp"

#include <string>
#include <unordered_map>
#include <typeinfo>

~~~

namespace [mt](namespace_mt.list) {

class MTStructure;
class MTChain;
class MTResidue;
class MTAtom;

# class MTDataKV

~~~ { .cpp }
{
public:

enum class t_kvpair { unknown = 0, MTVector, MTMatrix, MTMatrix44, MTMatrix53, MTCoordinates, MTAtom, MTResidue, MTChain, MTStructure, REAL, INT, STR };
struct _kvpair {
public:
	explicit _kvpair() : _t(t_kvpair::unknown) {}
	_kvpair(MTCoordinates const &);
	_kvpair(MTVector const &);
	_kvpair(MTMatrix44 const &);
	_kvpair(MTMatrix53 const &);
	_kvpair(MTMatrix const &);
	_kvpair(MTAtom *);
	_kvpair(MTResidue *);
	_kvpair(MTChain *);
	_kvpair(MTStructure *);
	_kvpair(int);
	_kvpair(int64_t);
	_kvpair(float);
	_kvpair(double);
	_kvpair(std::string const &);
	_kvpair(char const *);
	virtual ~_kvpair();

	t_kvpair type() const;

	template <typename T>
	bool get(T &) const;
private:
	friend std::ostream & operator<<(std::ostream &, MTDataKV::_kvpair const &); 
	t_kvpair _t { t_kvpair::unknown };
	void * _v { nullptr };
};

~~~

## /* access */

>std::string [toString](MTDataKV_access.cpp.md)() const;

>template \\<typename T\\>
bool [get](MTDataKV_access.cpp.md)(std::string const & k, T &) const;

>template \\<typename T\\>
bool [set](MTDataKV_access.cpp.md)(std::string const & k, T const &);

>bool [set](MTDataKV_access.cpp.md)(std::string const & k, char const * v);

>bool [unset](MTDataKV_access.cpp.md)(std::string const & k);

## /* comparison */

>bool [operator==](MTDataKV_operators.cpp.md)(MTDataKV const &) const;

## /* operation */

>MTDataKV& [operator+=](MTDataKV_operators.cpp.md)(MTDataKV const &);

## /* creation */

>[MTDataKV](MTDataKV_ctor.cpp.md)();

>virtual [~MTDataKV](MTDataKV_dtor.cpp.md)();

## /* brewery */

>//[code header](MTDataKV_-alpha-.md)();

>//[code trailer](MTDataKV_-omega-.md)();

private:

> std::unordered_map\\<std::string, _kvpair \\> _kvmap;

>// MTDataKV(MTDataKV const &) = delete;

~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTDataKV::_kvpair const & p);
std::ostream & operator<<(std::ostream & o, MTDataKV const & d);

} // namespace
~~~
