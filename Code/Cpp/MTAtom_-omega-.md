~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTAtom const & a) 
{
        o << "MTAtom(" << a.name() << ", " << a.number() << ")";
        return o;
}

    } // namespace
~~~
