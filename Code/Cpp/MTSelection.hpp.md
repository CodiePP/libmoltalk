~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <string>
#include <list>
~~~

namespace [mt](namespace_mt.list) {

>class [MTChain](MTChain.hpp.md);

>class [MTResidue](MTResidue.hpp.md);

>class [MTMatrix53](MTMatrix53.hpp.md);

# class MTSelection

~~~ { .cpp }
{
public:
~~~

## /* access */

>int [count](MTSelection_access.cpp.md)() const;

>std::string [toString](MTSelection_access.cpp.md)() const;

>std::list\\<MTResidue\\*\\> [getSelection](MTSelection_access.cpp.md)() const;

## /* operations */

>bool [containsResidue](MTSelection_operations.cpp.md)(MTResidue * const) const;

>void [addResidue](MTSelection_operations.cpp.md)(MTResidue *);

>void [removeResidue](MTSelection_operations.cpp.md)(MTResidue * const);

>void [setDifference](MTSelection_operations.cpp.md)(MTSelection const *);

>void [setUnion](MTSelection_operations.cpp.md)(MTSelection const *);

## /* alignment */

>MTMatrix53 [alignTo](MTSelection_alignTo.cpp.md)(MTSelection const &) const;

## /* creation */

>[MTSelection](MTSelection_ctor.cpp.md)(MTChain *);

>virtual [~MTSelection](MTSelection_dtor.cpp.md)();

private:

> MTChain * _chain {nullptr};

> std::list\\<MTResidue\\*\\> _residues;

> MTSelection() = delete;

## /* brewery */

>//[code header](MTSelection_-alpha-.md)();

>//[code trailer](MTSelection_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~

