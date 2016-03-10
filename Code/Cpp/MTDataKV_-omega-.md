
declared in [MTDataKV](MTDataKV.hpp.md)

~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTDataKV::_kvpair const & d) 
{
	switch (d._t) {
	case MTDataKV::t_kvpair::MTVector: o << "mtv: " /*<< *(MTVector*)d._v*/; break;
	case MTDataKV::t_kvpair::MTMatrix: o << "mtm: " /*<< *(MTMatrix*)d._v*/; break;
	case MTDataKV::t_kvpair::MTMatrix44: o << "m44: " /*<< *(MTMatrix44*)d._v*/; break;
	case MTDataKV::t_kvpair::MTMatrix53: o << "m53: " /*<< *(MTMatrix53*)d._v*/; break;
	case MTDataKV::t_kvpair::MTCoordinates: o << "mtc: " /*<< *(MTCoordinates*)d._v*/; break;
	case MTDataKV::t_kvpair::REAL: o << "r: " << *(double*)d._v; break;
	case MTDataKV::t_kvpair::INT: o << "i: " << *(int64_t*)d._v; break;
	case MTDataKV::t_kvpair::STR: o << "s: " << *(std::string*)d._v; break;
	}
        return o;
}

std::ostream & operator<<(std::ostream & o, MTDataKV const & d) 
{
        o << d.toString();
        return o;
}

    } // namespace
~~~
