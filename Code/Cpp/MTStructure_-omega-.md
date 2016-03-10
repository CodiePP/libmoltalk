~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTStructure const & s) 
{
        o << "MTStructure(" << s.pdbcode() << ")";
        return o;
}

    } // namespace
~~~
