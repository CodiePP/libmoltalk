
declared in [MTCoordinates](MTCoordinates.hpp.md)

>   return the rotation matrix to align the vector along the Z-axis

~~~ { .cpp }
MTMatrix44 MTCoordinates::alignToZaxis() const
{
	MTCoordinates axis = *this;
	axis.normalize();
	double a = axis.x();
	double b = axis.y();
	double c = axis.z();
	double d = sqrt( (b * b) + (c * c) );

	double cos_a = c / d;
	double a_alpha = (acos (cos_a) * 180.0 / M_PI);
	if (b >= 0) { a_alpha = 0.0 - a_alpha; }
	MTMatrix44 M1 = MTMatrix44::rotationX(a_alpha);

	double cos_b = d;
	double a_beta = (acos (cos_b) * 180.0 / M_PI);
	if (a < 0) { a_beta = 0.0 - a_beta; }
	MTMatrix44 M2 = MTMatrix44::rotationY(a_beta);

	MTMatrix44 res = M2.x(M1);
	return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
-(MTMatrix44*)alignToZaxis
{
        MTCoordinates *axis = [self copy];
        [axis normalize];
        //NSLog(@"axis : %@", axis);
        double a = [axis x];
        double b = [axis y];
        double c = [axis z];
        double d = sqrt( (b * b) + (c * c) );
        double cos_a = c / d;
        double a_alpha = (acos (cos_a) * 180.0 / M_PI);
        if (b >= 0) { a_alpha = 0.0 - a_alpha; }
        //NSLog(@"                                        alpha: %2f", a_alpha);
        MTMatrix44 *M1 = [MTMatrix44 rotationX: a_alpha];
#ifdef REALLY_DEBUG
        [axis rotateBy: M1];
        [axis normalize];
        NSLog(@"axis : %@", axis);
#endif

        double cos_b = d;
        double a_beta = (acos (cos_b) * 180.0 / M_PI);
        if (a < 0) { a_beta = 0.0 - a_beta; }
        //NSLog(@"                                        beta: %2f", a_beta);
        MTMatrix44 *M2 = [MTMatrix44 rotationY: a_beta];
#ifdef REALLY_DEBUG
        [axis rotateBy: M2];
        [axis normalize];
        NSLog(@"axis : %@", axis);
#endif

        MTMatrix44 *res = [M2 x: M1];
#ifdef REALLY_DEBUG
        axis = [self copy];
        [axis normalize];
        [axis rotateBy: res];
        NSLog(@"test : %@", axis);
#endif

        return res;
}


~~~
