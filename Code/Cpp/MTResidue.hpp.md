~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTCoordinates.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"

#include <string>
#include <list>
#include <functional>

~~~

namespace [mt](namespace_mt.list) {

class MTAtom;
class MTChain;

# class MTResidue

~~~ { .cpp }
{
friend class MTPDBParser;

protected:

        std::string _name;
        int _number { 0 };
        char _subcode { ' ' };
	std::string _description;
        std::list<MTAtom*> _atoms;
        //MTAtom *t_ca;
        MTChain* _chain;
        bool _verified;
        bool _atomsComplete;
        std::string _modname; // our name as a modified residue
        std::string _moddesc; // description of modification
        std::string _segid;   // segment identifier
        int _seqnum;

public:
~~~

## /* setters/getters */

> virtual int [number](MTResidue_access.cpp.md)() const;
> virtual void [number](MTResidue_access.cpp.md)(int);

> virtual char [subcode](MTResidue_access.cpp.md)() const;
> virtual void [subcode](MTResidue_access.cpp.md)(char);

> virtual std::string [name](MTResidue_access.cpp.md)() const;
> virtual void [name](MTResidue_access.cpp.md)(std::string const &);

> virtual std::string [key](MTResidue_access.cpp.md)() const;

> virtual std::string [description](MTResidue_access.cpp.md)() const;

> virtual std::string [oneLetterCode](MTResidue_access.cpp.md)() const;

> virtual std::string [modname](MTResidue_access.cpp.md)() const;

> virtual std::string [moddescription](MTResidue_access.cpp.md)() const;

> virtual int [sequenceNumber](MTResidue_access.cpp.md)() const;

> virtual std::string [segid](MTResidue_access.cpp.md)() const;

> virtual MTChain* [getChain](MTResidue_access.cpp.md)() const;

> //-(NSComparisonResult)compare: (id)other;

## /* follow backbone connectivity */

> virtual MTResidue* nextResidue() const { return nullptr; }

> virtual MTResidue* prevResidue() const { return nullptr; }

> virtual double distanceCATo(MTResidue const * const) const { return 0.0; }

## /* tests */

> virtual bool [isStandardAminoAcid](MTResidue_tests.cpp.md)() const;

> virtual bool [isNucleicAcid](MTResidue_tests.cpp.md)() const;

> virtual bool [haveAtomsPresent](MTResidue_tests.cpp.md)() const;

> virtual bool [isModified](MTResidue_tests.cpp.md)() const;

## /* atoms */

> virtual void [addAtom](MTResidue_atoms.cpp.md)(MTAtom*);

> virtual void [removeAtom](MTResidue_atoms.cpp.md)(MTAtom*);

> virtual void [removeAtom](MTResidue_atoms.cpp.md)(std::string const &);

> virtual MTAtom* [findAtom](MTResidue_atoms.cpp.md)(std::function\\<bool(MTAtom*)\\> const &) const;

> virtual MTAtom* [getCA](MTResidue_atoms.cpp.md)() const;

> virtual MTAtom* [getAtom](MTResidue_atoms.cpp.md)(std::string) const;

> virtual MTAtom* [getAtom](MTResidue_atoms.cpp.md)(unsigned int) const;

> virtual int [allAtoms](MTResidue_atoms.cpp.md)(std::function\\<void(MTAtom*)\\> const &);


## /* manipulation */

> virtual void [transformBy](MTResidue_transformation.cpp.md)(MTMatrix53 const &);

> virtual void [rotateBy](MTResidue_transformation.cpp.md)(MTMatrix44 const &);

> virtual void [translateBy](MTResidue_transformation.cpp.md)(MTCoordinates const &);

> virtual void [mutateTo](MTResidue_transformation.cpp.md)(MTResidue const &);


## /* utility */

>static std::string [computeKey](MTResidue_utility.cpp.md)(int num, char subcode);

> //+(std::string)translate3LetterTo1LetterCode: (NSString*)c3letter;

> //+(std::string)translate1LetterTo3LetterCode: (NSString*)c1letter;


##  /* creation */

>[MTResidue](MTResidue_ctor.cpp.md)(MTResidue const &);

>[MTResidue](MTResidue_ctor.cpp.md)();

>virtual [~MTResidue](MTResidue_dtor.cpp.md)();

## /* brewery */

>//[code header](MTResidue_-alpha-.md)();

>//[code trailer](MTResidue_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~
