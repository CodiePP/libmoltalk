~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTAlignmentAlgo.hpp"

#include <memory>
#include <string>
~~~

namespace [mt](namespace_mt.list) {

class [MTChain](MTChain.hpp.md);

# class MTPairwiseSequenceAlignment : public MTAlignmentAlgo

{
public:
    
##  /* creation */

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(MTChain const \\*, MTChain const \\*);

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(MTChain const \\*, std::string const &);

>[MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_ctor.cpp.md)(std::string const &, std::string const &);

>virtual [~MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment_dtor.cpp.md)();

>MTPairwiseSequenceAlignment() = delete;

## /* brewery */

>//[code header](MTPairwiseSequenceAlignment_-alpha-.md)();

>//[code trailer](MTPairwiseSequenceAlignment_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~

