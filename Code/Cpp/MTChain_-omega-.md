~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTChain const & c) 
{
        o << "MTChain(" << c.fullPDBCode() << ")";
        return o;
}

    } // namespace
~~~
