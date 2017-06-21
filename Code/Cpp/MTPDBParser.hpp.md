~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <memory>

~~~

namespace [mt](namespace_mt.list) {

class [MTStructure](MTStructure.hpp.md);
class [MTChain](MTChain.hpp.md);
class [MTAtom](MTAtom.hpp.md);

# class MTPDBParser final
~~~ { .cpp }
{
private:
	struct pimpl;
	std::unique_ptr<pimpl> _pimpl;

public:
	enum parse_options {
		  ALL_NMRMODELS = 1L
		, IGNORE_SIDECHAINS = 2L
		, IGNORE_HETEROATOMS = 4L
		, IGNORE_SOLVENT = 8L
		, IGNORE_COMPOUND = 16L
		, IGNORE_SOURCE = 32L
		, IGNORE_KEYWORDS = 64L
		, IGNORE_EXPDTA = 128L
		, IGNORE_REMARK = 256L
		, IGNORE_REVDAT = 512L
		, DONT_VERIFYCONNECTIVITY = 1024L
		, IGNORE_SEQRES = 2048L 
		, ALL_ALTERNATE_ATOMS = 4096L
		, IGNORE_HYDROGENS = 8192L
		, ALL_REMARKS = 16384L
	};
~~~

## /* access */

>virtual long [getOptions](MTPDBParser_ctor.cpp.md)() const;

## /* creation */

>[MTPDBParser](MTPDBParser_ctor.cpp.md)(long p_opts = 0L);

>virtual [~MTPDBParser](MTPDBParser_dtor.cpp.md)();

## /* reads and initializes a parser from a file in PDB format returns the structure */

>[MTStructure](MTStructure.hpp.md)* [parseStructurePtrFromPDBFile](MTPDBParser_parseStructureFromPDB.cpp.md)(std::string const & fn);

>[MTStructure](MTStructure.hpp.md)* [parseStructureFromPDBFile](MTPDBParser_parseStructureFromPDB.cpp.md)(std::string const & fn);

>[MTStructure](MTStructure.hpp.md)* [parseStructureFromPDBStream](MTPDBParser_parseStructureFromPDB.cpp.md)(std::istream & s);

## /* utilities */

>long [mkISOdate](MTPDBParser_parsers.cpp.md)(std::string const & dt) const;

>std::string [prtISOdate](MTPDBParser_parsers.cpp.md)(long dt) const;

## /* brewery */

>//[code header](MTPDBParser_-alpha-.md)();

>//[code trailer](MTPDBParser_-omega-.md)();

~~~ { .cpp }

#ifndef NDEBUG

int make_int(const char *, int) const;
double make_float(const char *, int) const;
void clipright(std::string &) const;
void clipleft(std::string &) const;
void clip(std::string &) const;

#endif

~~~

private:

## /* setup */

>void [setup_parsers](MTPDBParser_parsers.cpp.md)();


~~~ { .cpp }
};

} // namespace
~~~
