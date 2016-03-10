~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTResidue const & r) 
{
        o << "MTResidue(" << r.key() << ")";
        return o;
}

    } // namespace
~~~
