
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }

std::string MTResidue::computeKey(int n, char c)
{
	std::ostringstream ss;
	ss << n;
	if (c != ' ') { ss << c; }
	return ss.str();
}
~~~

