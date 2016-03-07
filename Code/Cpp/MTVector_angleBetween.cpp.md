
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
/*
 *   calculates the angle between two vectors (in degrees)
 */
double MTVector::angleBetween(MTVector const & v2) const
{
	double l1 = length();
	double l2 = v2.length();
	if (l1 == 0.0 || l2 == 0.0) { return 0.0; }
        double t_scal = scalarProductBy(v2) / l1 / l2;
	//std::clog << " l1=" << l1 << " l2=" << l2 << "  => scal=" << t_scal << std::endl;
	if (t_scal == 0) { return 0.0; }
	if (t_scal >=  1.0 - 0.00001) { return 0.0; }
	if (t_scal <= -1.0 + 0.00001) { return 180.0; }
        return (acos(t_scal) * 180.0 / M_PI);
}
~~~


original objc code:

~~~ { .ObjectiveC }
-(double)angleBetween:(MTVector*)v2
{
        double t_scal = [self scalarProductBy: v2] / [self length] / [v2 length];
        if (t_scal >= 1.0 || t_scal <= -1.0)
        {
                /* cannot compute acos(1.0) -> 0.0 */
                return 0.0;
        }
        return (acos(t_scal) * 180.0 / M_PI);
}

~~~
