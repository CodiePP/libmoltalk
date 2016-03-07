~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTVector const & v) 
{
        o << v.toString();
        return o;
}

    } // namespace
~~~
