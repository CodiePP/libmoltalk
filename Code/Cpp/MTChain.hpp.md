~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTStructure.hpp"
#include "MTResidue.hpp"
#include "MTCoordinates.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"
#include "MTDataKV.hpp"

#include <string>
#include <unordered_map>
~~~

namespace [mt](namespace_mt.list) {

class [MTChainFactory](MTChainFactory.hpp.md);

# class MTChain

~~~ { .cpp }
{
protected:
	friend MTChainFactory;

        char _code;
        MTStructure* _strx;
        MTDataKV _descriptors;

        std::unordered_map<std::string, MTResidue*> _solvent;
        std::unordered_map<std::string, MTResidue*> _heterogens;
        std::unordered_map<std::string, MTResidue*> _residues;

/*        NSMutableDictionary *_residuehash;
        unsigned int _hashingbits;
        double _hash_value_offset; */

public:
~~~

## /* naming */

>virtual char [code](MTChain_naming.cpp.md)() const;

>virtual int [number](MTChain_naming.cpp.md)() const;

>virtual std::string [name](MTChain_naming.cpp.md)() const;

>virtual std::string [description](MTChain_naming.cpp.md)() const;

>virtual std::string [fullPDBCode](MTChain_naming.cpp.md)() const;

## /* readonly access */

>virtual std::string [source](MTChain_access.cpp.md)() const;

>virtual std::string [compound](MTChain_access.cpp.md)() const;

>virtual std::string [eccode](MTChain_access.cpp.md)() const;

## /* reference to parent structure */

>virtual [MTStructure](MTStructure.hpp.md)* [structure](MTChain_access.cpp.md)() const;


## /* utilities */

>virtual void [orderResidues](MTChain_utilities.cpp.md)();

>virtual void [reconnectResidues](MTChain_utilities.cpp.md)();

/* transform all residues/atoms in this chain by the given matrix */

>virtual void [transformBy](MTChain_transformation.cpp.md)(MTMatrix53 const &);

>virtual void [translateBy](MTChain_transformation.cpp.md)(MTCoordinates const &);

>virtual void [rotateBy](MTChain_transformation.cpp.md)(MTMatrix44 const &);


/* enumerator over residues, heterogens, solvent, respectively */

> //(NSEnumerator*)allResidues;

> //(NSEnumerator*)allHeterogens;

> //(NSEnumerator*)allSolvent;

/* count of residues, heterogens, solvent, respectively */

>virtual int [countResidues](MTChain_counts.cpp.md)() const;

>virtual int [countStandardAminoAcids](MTChain_counts.cpp.md)() const;

>virtual int [countHeterogens](MTChain_counts.cpp.md)() const;

>virtual int [countSolvent](MTChain_counts.cpp.md)() const;

## /* access a residue, heterogen, solvent, respectively, for the given identifying number (eventually, plus an insertion code, single character) */

> virtual [MTResidue](MTResidue.hpp.md)* [getResidue](MTChain_get.cpp.md)(unsigned int, char=' ') const;

> virtual MTResidue* [findResidue](MTChain_get.cpp.md)(std::function\\<bool(MTResidue* const &)\\> const &) const;

> virtual std::list\\<MTResidue\\*\\> [filterResidues](MTChain_get.cpp.md)(std::function\\<bool(MTResidue* const)\\> const &) const;

> virtual MTResidue* [getHeterogen](MTChain_get.cpp.md)(unsigned int, char=' ') const;

> virtual MTResidue* [findHeterogen](MTChain_get.cpp.md)(std::function\\<bool(MTResidue* const &)\\> const &) const;

> virtual MTResidue* [getSolvent](MTChain_get.cpp.md)(unsigned int, char=' ') const;

> virtual MTResidue* [findSolvent](MTChain_get.cpp.md)(std::function\\<bool(MTResidue* const &)\\> const &) const;

## /* add a residue, heterogen, solvent, respectively, to this chain */

> virtual void [addResidue](MTChain_add.cpp.md)(MTResidue*);

> virtual void [addHeterogen](MTChain_add.cpp.md)(MTResidue*);

> virtual void [addSolvent](MTChain_add.cpp.md)(MTResidue*);

## /* remove a residue */

> virtual void [removeResidue](MTChain_remove.cpp.md)(unsigned int, char subcode=' ');

> virtual void [removeHeterogen](MTChain_remove.cpp.md)(unsigned int, char subcode=' ');

> virtual void [removeSolvent](MTChain_remove.cpp.md)(unsigned int, char subcode=' ');

## /* derive amino acid sequence */

> virtual std::string [getSEQRES](MTChain_sequence.cpp.md)() const;

> virtual std::string [getSequence](MTChain_sequence.cpp.md)() const;

> virtual std::string [get3DSequence](MTChain_sequence.cpp.md)() const;

## /* geometric hash of all residues in this Chain */

 /* not yet

> -(void)prepareResidueHash:(float)binwidth;

> -(NSArray*)findResiduesCloseTo:(MTCoordinates*)p_coords;

> -(NSNumber*)mkCoordinatesHashX:(double)x Y:(double)y Z:(double)z; // compute hash key value

 */

## /* descriptors */

bool [unsetDescriptor](MTChain_descriptors.cpp.md)(std::string const &);

>template \\<typename T\\>
bool [getDescriptor](MTChain_descriptors.cpp.md)(std::string const &, T &) const;

>template \\<typename T\\>
bool [setDescriptor](MTChain_descriptors.cpp.md)(std::string const &, T const &);

>virtual std::list\\<std::string\\> [allDescriptorKeys](MTChain_descriptors.cpp.md)() const;

## /* complex utilities */

/* not yet

> -(MTChain*)deepCopy;

> -(MTChain*)deepCopyCA;

> -(NSArray*)selectResiduesCloseTo:(MTChain*)other maxDistance:(float)maxdist;

*/

##  /* creation */

>[MTChain](MTChain_ctor.cpp.md)(MTChain const &);

>[MTChain](MTChain_ctor.cpp.md)(char code);

>virtual [~MTChain](MTChain_dtor.cpp.md)();

## /* brewery */

>//[code header](MTChain_-alpha-.md)();

>//[code trailer](MTChain_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~
