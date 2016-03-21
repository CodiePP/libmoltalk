~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <memory>
#include <string>
~~~

namespace [mt](namespace_mt.list) {

class [MTChain](MTChain.hpp.md);

# class MTPairwiseSequenceAlignment

{
public:
    
##  /* access */

>const MTChain* [chain1](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>const MTChain* [chain2](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>std::string [toString](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>std::string [toFasta](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>int [countAligned](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>int [countIdentical](MTPairwiseSequenceAlignment_access.cpp.md)() const;

>int [countGapped](MTPairwiseSequenceAlignment_access.cpp.md)() const;

## /* setters */

>void [setGop](MTPairwiseSequenceAlignment_setters.cpp.md)(float);

>void [setGep](MTPairwiseSequenceAlignment_setters.cpp.md)(float);

##  /* compute */

>void [computeLocalAlignment](MTPairwiseSequenceAlignment_computeLocalAlignment.cpp.md)();

>void [computeGlobalAlignment](MTPairwiseSequenceAlignment_computeGlobalAlignment.cpp.md)();


##  /* creation */

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(const MTChain \\*, const MTChain \\*);

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(const MTChain \\*, std::string const &);

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(std::string const &, std::string const &);

>virtual [~MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_dtor.cpp.md)();


private:

>struct pimpl;

>std::unique_ptr\\<pimpl\\> _pimpl;

>MTPairwiseSequenceAlignment() = delete;

## /* brewery */

>//[code header](MTPairwiseSequenceAlignment_-alpha-.md)();

>//[code trailer](MTPairwiseSequenceAlignment_-omega-.md)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTPairwiseSequenceAlignment const & v);

} // namespace
~~~

