~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTPDBParser const & p) 
{
        o << "MTPDBParser(" << p.getOptions() << ")";
        return o;
}

    } // namespace
~~~
