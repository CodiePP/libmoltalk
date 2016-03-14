~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTCoordinates.hpp"

#include <string>
#include <list>
#include <functional>
~~~

namespace [mt](namespace_mt.list) {

# class MTAtom 

>//: public [MTCoordinates](MTCoordinates.hpp)

~~~ { .cpp }
{
public:

enum element_id { 
        Unknown = 0,
        H  =  1,
        He =  2,

        Li =  3,
        Be =  4,
        B  =  5,
        C  =  6,
        N  =  7,
        O  =  8,
        F  =  9,

        Ne = 10,
        Na = 11,
        Mg = 12,
        Al = 13,
        Si = 14,
        P  = 15,
        S  = 16,
        Cl = 17,
        Ar = 18,

        K  = 19,
        Ca = 20,
        Sc = 21,
        Ti = 22,
        V  = 23,
        Cr = 24,
        Mn = 25,
        Fe = 26,
        Co = 27,
        Ni = 28,
        Cu = 29,
        Zn = 30,
        Ga = 31,
        Ge = 32,
        As = 33,
        Se = 34,
        Br = 35,
        Kr = 36,

        Rb = 37,
        Sr = 38,
        Y  = 39,
        Zr = 40,
        Nb = 41,
        Mo = 42,
        Tc = 43,
        Ru = 44,
        Rh = 45,
        Pd = 46,
        Ag = 47,
        Cd = 48,
        In = 49,
        Sn = 50,
        Sb = 51,
        Te = 52,
        I  = 53,
        Xe = 54,

        Cs = 55,
        Ba = 56,
        Lu = 71,
        Hf = 72,
        Ta = 73,
        W  = 74,
        Re = 75,
        Os = 76,
        Ir = 77,
        Pt = 78,
        Au = 79,
        Hg = 80,
        Tl = 81,
        Pb = 82,
        Bi = 83,
        Po = 84,
        At = 85,
        Rn = 86
};

protected:
        const int _number;
        std::string _name;
        //element_id _element;
        //float _temperature;
        //float _charge;
        std::list<MTAtom*> _bonds;

public:
~~~

## /* readonly access */

>virtual unsigned int [number](MTAtom_getters.cpp.md)() const;

>virtual unsigned int [serial](MTAtom_getters.cpp.md)() const;

>virtual std::string [name](MTAtom_getters.cpp.md)() const;

>virtual MTAtom::element_id [element](MTAtom_getters.cpp.md)() const;

>virtual float [temperature](MTAtom_getters.cpp.md)() const;

>virtual float [charge](MTAtom_getters.cpp.md)() const;

>virtual std::string [elementName](MTAtom_getters.cpp.md)() const;

>virtual MTCoordinates [coords](MTAtom_getters.cpp.md)() const;

## /* bonding */

>virtual void [bondTo](MTAtom_bonds.cpp.md)(MTAtom*);

>virtual const std::list\\<MTAtom*\\> [allBondedAtoms](MTAtom_bonds.cpp.md)() const;

>virtual MTAtom* [findBondedAtom](MTAtom_bonds.cpp.md)(std::function\\<bool(MTAtom*)\\> const &) const;

>virtual void [dropBondTo](MTAtom_bonds.cpp.md)(MTAtom*);

>virtual void [dropAllBonds](MTAtom_bonds.cpp.md)();

## /* setters */

>virtual void [setSerial](MTAtom_setters.cpp.md)(unsigned int);

>virtual void [setName](MTAtom_setters.cpp.md)(std::string const &);

>virtual void [setXYZB](MTAtom_setters.cpp.md)(double,double,double,double);

>virtual void [setTemperature](MTAtom_setters.cpp.md)(float);

>//virtual void [setNumber](MTAtom_setters.cpp.md)(unsigned int);

>virtual void [setCharge](MTAtom_setters.cpp.md)(float);

>virtual void [setElement](MTAtom_setters.cpp.md)(MTAtom::element_id const &);

>virtual void [setElement](MTAtom_setters.cpp.md)(char const s[3]);

## /* transformations */

>virtual void [transformBy](MTAtom_trafo.cpp.md)(MTMatrix53 const & c);

>virtual void [rotateBy](MTAtom_trafo.cpp.md)(MTMatrix44 const & c);

>virtual void [translateBy](MTAtom_trafo.cpp.md)(MTCoordinates const & c);

## /* creation */

>// +(MTAtom*)atomWithNumber:(unsigned int)num name:(char*)nm X:(double)x Y:(double)y Z:(double)z B:(float)b;

>[MTAtom](MTAtom_ctor.cpp.md)();

>virtual [~MTAtom](MTAtom_dtor.cpp.md)();

## /* brewery */

>//[code header](MTAtom_-alpha-.md)();

>//[code trailer](MTAtom_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~
