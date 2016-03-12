~~~ { .cpp }
std::ostream & operator<<(std::ostream & o, MTQuaternion const & q) 
{
	o << q.toString();
	return o;
}

    } // namespace
~~~
