~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <functional>

/*
#define PDBPARSER_ALL_NMRMODELS 1L
#define PDBPARSER_IGNORE_SIDECHAINS 2L
#define PDBPARSER_IGNORE_HETEROATOMS 4L
#define PDBPARSER_IGNORE_SOLVENT 8L
#define PDBPARSER_IGNORE_COMPOUND 16L
#define PDBPARSER_IGNORE_SOURCE 32L
#define PDBPARSER_IGNORE_KEYWORDS 64L
#define PDBPARSER_IGNORE_EXPDTA 128L
#define PDBPARSER_IGNORE_REMARK 256L
#define PDBPARSER_IGNORE_REVDAT 512L
#define PDBPARSER_DONT_VERIFYCONNECTIVITY 1024L
#define PDBPARSER_IGNORE_SEQRES 2048L 
#define PDBPARSER_ALL_ALTERNATE_ATOMS 4096L
#define PDBPARSER_IGNORE_HYDROGENS 8192L
#define PDBPARSER_ALL_REMARKS 16384L
*/


/*
 *   This factory can instantiate objects of the class @MTStructure. 
 *   If you want to create subclasses of @MTStructure, implement a subclass of @MTStructureFactory and
 *   overwrite @method(MTStructureFactory,+newInstance). Then set it to be the new default factory class 
 *   with @method(MTStructureFactory,+setDefaultStructureFactory:).
 *   <p>
 *   options that will be passed to the parser:<br>
 *   |PDBPARSER_ALL_NMRMODELS|=1 <br>
 *   |PDBPARSER_IGNORE_SIDECHAINS|=2 <br>
 *   |PDBPARSER_IGNORE_HETEROATOMS|=4 <br>
 *   |PDBPARSER_IGNORE_SOLVENT|=8 <br>
 *   |PDBPARSER_IGNORE_COMPOUND|=16 <br>
 *   |PDBPARSER_IGNORE_SOURCE|=32 <br>
 *   |PDBPARSER_IGNORE_KEYWORDS|=64 <br>
 *   |PDBPARSER_IGNORE_EXPDTA|=128 <br>
 *   |PDBPARSER_IGNORE_REMARK|=256 <br>
 *   |PDBPARSER_IGNORE_REVDAT|=512 <br>
 *   |PDBPARSER_DONT_VERIFYCONNECTIVITY|=1024 <br>
 *   |PDBPARSER_IGNORE_SEQRES|=2048 <br>
 *   |PDBPARSER_ALL_ALTERNATE_ATOMS|=4096 <br>
 *   |PDBPARSER_IGNORE_HYDROGENS|=8192 <br>
 *   |PDBPARSER_ALL_REMARKS|=16384 <br>
 *
 */
~~~

namespace [mt](namespace_mt.list) {

>class MTStructure;

# class IStructureFactory
{

public:
	enum class optPDBPARSER {
		common 			= 	    0 ,
		ALL_NMRMODELS 		= 	    1L,
		IGNORE_SIDECHAINS 	=	    2L,
		IGNORE_HETEROATOMS 	=	    4L,
		IGNORE_SOLVENT 		=	    8L,
		IGNORE_COMPOUND 	=	   16L,
		IGNORE_SOURCE 		=	   32L,
		IGNORE_KEYWORDS 	=	   64L,
		IGNORE_EXPDTA 		=	  128L,
		IGNORE_REMARK 		=	  256L,
		IGNORE_REVDAT 		=	  512L,
		DONT_VERIFYCONNECTIVITY =	 1024L,
		IGNORE_SEQRES 		=	 2048L ,
		ALL_ALTERNATE_ATOMS 	=	 4096L,
		IGNORE_HYDROGENS 	=	 8192L,
		ALL_REMARKS 		=	16384L };
	//long operator long(optPDBPARSER const & o) { return (long)o; }

 virtual [~IStructureFactory](MTStructureFactory_dtor.cpp.md)();

 static int instance_count();

 virtual void setFactory(std::function\\<MTStructure*()\\> const & fn) final { _factory = fn; }

 virtual MTStructure* newInstance() final;

protected:

	static std::function\\<MTStructure*()\\> _factory;

};

# class MTStructureFactory : public IStructureFactory
{

public:

## /* creation */

virtual MTStructure* [newStructureFromPDBFile](MTStructureFactory_creation.cpp.md)(std::string const fn, long options = 0L);

virtual MTStructure* [newStructureFromPDBDirectory](MTStructureFactory_creation.cpp.md)(std::string const code, long options = 0L);

virtual MTStructure* [newStructure](MTStructureFactory_creation.cpp.md)();

## /* ctor, dtor */

[MTStructureFactory](MTStructureFactory_ctor.cpp.md)();

virtual ~MTStructureFactory() {};

## /* brewery */

>//[code header](MTStructureFactory_-alpha-.md)();

>//[code trailer](MTStructureFactory_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~
