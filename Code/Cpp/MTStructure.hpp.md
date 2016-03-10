~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTDataKV.hpp"

#include <iosfwd>
#include <string>
#include <memory>
#include <unordered_map>
#include <list>

/* 
 *   following the keys for predefined descriptors
 */
/*
extern id MTSTRX_HEADER_key;
extern id MTSTRX_TITLE_key;
extern id MTSTRX_PDBCODE_key;
extern id MTSTRX_DATE_key;
extern id MTSTRX_REVDATE_key;
extern id MTSTRX_RESOLUTION_key;
extern id MTSTRX_EXPERIMENT_key;
extern id MTSTRX_KEYWORDS_key;
*/

/*
 *   Class @MTStructure is the top class of the hierarchical mapping of PDB files to<br>
 *   object space.
 *   
 */

~~~

# namespace [mt](namespace_mt.list) {

class MTChain;

# class MTStructure

~~~ { .cpp }
{
friend class MTPDBParser;

protected:
	MTDataKV _descriptors;
        
	std::string _pdbcode;
	std::string _title;
	std::string _header;
	std::list<std::string> _keywords;
	float _resolution;

	struct pimpl;
	std::unique_ptr<pimpl> _pimpl;

public:
~~~

enum class ExperimentType { 
		XRay=100, 
		NMR, 
		TheoreticalModel, 
		Other, 
		Unknown };

## /* readonly access */

>virtual std::string [header](MTStructure_access.cpp.md)() const;

>virtual std::string [pdbcode](MTStructure_access.cpp.md)() const;

>virtual std::string [title](MTStructure_access.cpp.md)() const;

>virtual std::list\\<std::string\\> [keywords](MTStructure_access.cpp.md)() const;

> //-(NSCalendarDate*)date;

> //-(NSCalendarDate*)revdate;

>virtual float [resolution](MTStructure_access.cpp.md)() const;

>virtual ExperimentType [expdata](MTStructure_access.cpp.md)() const;

> //-(std::string)hetnameForKey:(NSString*)key;

## /* descriptors */

bool [unsetDescriptor](MTStructure_descriptors.cpp.md)(std::string const &);

>template \\<typename T\\>
bool [getDescriptor](MTStructure_descriptors.cpp.md)(std::string const &, T &) const;

>template \\<typename T\\>
bool [setDescriptor](MTStructure_descriptors.cpp.md)(std::string const &, T const &);

>virtual std::list\\<std::string\\> [allDescriptorKeys](MTStructure_descriptors.cpp.md)() const;

## /* model context */

>virtual int [models](MTStructure_models.cpp.md)() const;

>virtual int [currentModel](MTStructure_models.cpp.md)() const;

>virtual int [switchToModel](MTStructure_models.cpp.md)(int p_mnum);

>virtual int [addModel](MTStructure_models.cpp.md)();

>virtual void [removeModel](MTStructure_models.cpp)();

## /* writes out the complete structure to a file in PDB format */

> //-(void)writePDBFile:(std::string)fn;

> //-(void)writePDBToStream:(MTStream*)str;

## /* chain access */

>virtual std::shared_ptr\\<MTChain\\> [getChain](MTStructure_chains.cpp.md)(int p_chain) const;

>virtual std::shared_ptr\\<MTChain\\> [getChain](MTStructure_chains.cpp.md)(char p_chain) const;

>virtual std::shared_ptr\\<MTChain\\> [findChain](MTStructure_chains.cpp.md)(std::function\\<bool(std::shared_ptr\\<MTChain\\> const &)\\> const &) const;

## /* manipulations */

>virtual void [addChain](MTStructure_chains.cpp.md)(std::shared_ptr\\<MTChain\\>);

>virtual void [removeChain](MTStructure_chains.cpp.md)(std::shared_ptr\\<MTChain\\>);

## /* utilities */

>virtual void [inferDisulphideBridges](MTStructure_utilities.cpp.md)();

##  /* creation */

>[MTStructure](MTStructure_ctor.cpp.md)(MTStructure const &);

>[MTStructure](MTStructure_ctor.cpp.md)();

>virtual [~MTStructure](MTStructure_dtor.cpp.md)();

## /* brewery */

>//[code header](MTStructure_-alpha-.md)();

>//[code trailer](MTStructure_-omega-.md)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTStructure::ExperimentType const & t);

} // namespace
~~~
