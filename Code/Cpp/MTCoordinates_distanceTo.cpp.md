
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }

double MTCoordinates::distance2To(MTCoordinates const & c2) const
{
        double a = x() - c2.x();
        double b = y() - c2.y();
        double c = z() - c2.z();
        return (a*a + b*b + c*c);
}

double MTCoordinates::distanceTo(MTCoordinates const & c2) const
{
	double d2 = distance2To(c2);
	if (d2 > 0.0) {
		return sqrt(d2); }
	return 0.0;
}

/*
 *   calculate distance of this coordinates to the line given by (v2,v3)
 */
double MTCoordinates::distanceToLineFrom(MTCoordinates const & v2, MTCoordinates const & v3) const
{
/*
 *              D
 *              |
 *         P    |A
 *     ----x----x------------ plane
 *              |
 *              |
 *              O
 *  Abbildung von OP auf OD(Normale): OD . OP / |OD| => h
 *  Streckung von OD mit h ergiebt OA
 *  Distanz ist gegeben von A zu P   []
 */
        /* calculate plane through this point with normal: v3-v2 */
        MTCoordinates normal = v2.differenceTo(v3);
        MTCoordinates base = v2.differenceTo(*this);
        double h = base.scalarProductBy(normal) / normal.length();
	normal.normalize();
        normal.scaleByScalar(h);
	normal.add(v2);
        return distanceTo(normal);
}

~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   calculate distance of this coordinates to the line given by (v2,v3)
 */
-(double)distanceToLineFrom:(MTCoordinates*)v2 to:(MTCoordinates*)v3
{
/*
 *              D
 *              |
 *         P    |A
 *     ----x----x------------ plane
 *              |
 *              |
 *              O
 *  Abbildung von OP auf OD(Normale): OD . OP / |OD| => h
 *  Streckung von OD mit h ergiebt OA
 *  Distanz ist gegeben von A zu P   []
 */
        /* calculate plane through this point with normal: v3-v2 */
        MTCoordinates *normal = [v2 differenceTo: v3];
        MTCoordinates *base = [v2 differenceTo: self];
        double h = [base scalarProductBy: normal]/[normal length];
        [[[normal normalize] scaleByScalar: h] add:v2];
        return [self distanceTo: normal];
}

~~~
