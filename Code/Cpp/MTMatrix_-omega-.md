
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }

std::ostream & operator<<(std::ostream & o, MTMatrix const & m)
{
	o << "MTM[";
	for (int r = 0; r < m.rows(); r++) {
		if (0==r) { o << " ["; }
		else { o << std::endl << "    ,["; }
		for (int c = 0; c < m.cols(); c++) {
			if (0==c) { o << " "; }
			else { o << ","; }
			o << m.atRowCol(r,c);
		}
		o << " ] ";
	}
	o << "]" << std::endl;
	return o;
}

    } // namespace
~~~
