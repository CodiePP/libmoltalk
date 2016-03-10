~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTResidueAA const & r) 
{
        o << "MTResidueAA(" << r.key() << ")";
        return o;
}

    } // namespace
~~~
