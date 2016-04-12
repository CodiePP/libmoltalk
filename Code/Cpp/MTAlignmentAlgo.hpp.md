~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTAlPos.hpp"
#include "MTResidue.hpp"

#include <string>
#include <list>
#include <vector>
~~~

namespace [mt](namespace_mt.list) {

class [MTChain](MTChain.hpp.md);

class [MTSubstitutionMatrix](MTSubstitutionMatrix.hpp.md);

# class MTAlignmentAlgo

{
public:
    
##  /* access */

>const MTChain* chain1() const { return _chain1; }

>const MTChain* chain2() const { return _chain2; }

>std::string [toString](MTAlignmentAlgo_access.cpp.md)() const;

>std::string [toFasta](MTAlignmentAlgo_access.cpp.md)() const;

>int [countAligned](MTAlignmentAlgo_access.cpp.md)() const;

>int [countIdentical](MTAlignmentAlgo_access.cpp.md)() const;

>int [countGapped](MTAlignmentAlgo_access.cpp.md)() const;

>std::list\\<MTAlPos\\>::const_iterator [cbegin](MTAlignmentAlgo_access.cpp.md)() const;

>std::list\\<MTAlPos\\>::const_iterator [cend](MTAlignmentAlgo_access.cpp.md)() const;

## /* setters */

>void [setGop](MTAlignmentAlgo_setters.cpp.md)(float);

>void [setGep](MTAlignmentAlgo_setters.cpp.md)(float);

>void [setScoring](MTAlignmentAlgo_setters.cpp.md)(MTSubstitutionMatrix *);

##  /* compute */

>void [computeLocalAlignment](MTAlignmentAlgo_computeLocalAlignment.cpp.md)();

>void [computeGlobalAlignment](MTAlignmentAlgo_computeGlobalAlignment.cpp.md)();


##  /* creation */

>[MTAlignmentAlgo](MTAlignmentAlgo_ctor.cpp.md)(MTChain \\*, MTChain \\*);

>[MTAlignmentAlgo](MTAlignmentAlgo_ctor.cpp.md)(MTChain \\*, std::string const &);

>[MTAlignmentAlgo](MTAlignmentAlgo_ctor.cpp.md)(std::string const &, std::string const &);

>virtual [~MTAlignmentAlgo](MTAlignmentAlgo_dtor.cpp.md)();


protected:

>MTChain * _chain1 { nullptr };

>MTChain * _chain2 { nullptr };

>std::list\\<MTAlPos\\> _positions;

>bool _computed { false };

>float _gop, _gep;

>MTSubstitutionMatrix *_substm { nullptr };

>MTAlignmentAlgo() {};

private:

>void [prepare_alignment](MTAlignmentAlgo_prepare.cpp.md)();

>int _startpos, _endpos;

>std::string _seq1, _seq2;

>std::vector\\<MTResidue*\\> _residues1;

>std::vector\\<MTResidue*\\> _residues2;

## /* brewery */

>//[code header](MTAlignmentAlgo_-alpha-.md)();

>//[code trailer](MTAlignmentAlgo_-omega-.md)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTAlignmentAlgo const & v);

} // namespace
~~~

