~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTResidue.hpp"

~~~

namespace [mt](namespace_mt.list) {

# class MTResidueAA : public [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }
{
public:
~~~

>virtual std::string [oneLetterCode](MTResidueAA_access.cpp.md)() const override;

>// virtual int [sequenceNumber](MTResidueAA_access.cpp.md)() const override;

## /* follow backbone connectivity */

>// virtual [MTResidue](MTResidue.hpp.md)* [nextResidue](MTResidueAA_backbone.cpp.md)() const override; 

>// virtual [MTResidue](MTResidue.hpp.md)* [prevResidue](MTResidueAA_backbone.cpp.md)() const override; 

> virtual double [distanceCATo](MTResidueAA_backbone.cpp.md)(MTResidue const * const) const override;

## /* tests */

> virtual bool [isStandardAminoAcid](MTResidueAA_tests.cpp.md)() const override;

> virtual bool [isNucleicAcid](MTResidueAA_tests.cpp.md)() const override;

> virtual bool [hasAtomsPresent](MTResidueAA_tests.cpp.md)() const override;

> virtual bool [isModified](MTResidueAA_tests.cpp.md)() const override;

## /* atoms */

> virtual void [addAtom](MTResidueAA_atoms.cpp.md)(MTAtom*) override;

> virtual void [removeAtom](MTResidueAA_atoms.cpp.md)(MTAtom*) override;

> virtual MTAtom* [findAtom](MTResidueAA_atoms.cpp.md)(std::function\\<bool(MTAtom*)\\> const &) const;

> virtual MTAtom* [getCA](MTResidueAA_atoms.cpp.md)() const;

> virtual int [allAtoms](MTResidueAA_atoms.cpp.md)(std::function\\<void(MTAtom*)\\> const &);


## /* utility */

>static std::string [translate3to1Code](MTResidueAA_utilities.cpp.md) (std::string const &);

>static std::string [translate1to3Code](MTResidueAA_utilities.cpp.md) (std::string const &);


##  /* creation */

>//[MTResidueAA](MTResidueAA_ctor.cpp.md)(MTResidueAA const &);

>[MTResidueAA](MTResidueAA_ctor.cpp.md)();

>virtual [~MTResidueAA](MTResidueAA_dtor.cpp.md)();

## /* brewery */

>//[code header](MTResidueAA_-alpha-.md)();

>//[code trailer](MTResidueAA_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~
