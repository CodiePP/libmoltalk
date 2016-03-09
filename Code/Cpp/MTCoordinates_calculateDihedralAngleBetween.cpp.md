
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }
double MTCoordinates::calculateDihedralAngleBetween( MTCoordinates const & p1, MTCoordinates const & p2, MTCoordinates const & p3, MTCoordinates const & p4)
{
        MTCoordinates v21 = p1.differenceTo(p2);
        MTCoordinates v23 = p3.differenceTo(p2);
        MTCoordinates v32 = p2.differenceTo(p3);
        MTCoordinates v34 = p4.differenceTo(p3);
        MTCoordinates n1 = v21.vectorProductBy(v23);
        n1.normalize();
//	std::clog << "n1 = " << n1 << std::endl;
        MTCoordinates n2 = v32.vectorProductBy(v34);
        n2.normalize();
//	std::clog << "n2 = " << n2 << std::endl;
        double Spat = v23.mixedProductBy(n1, n2);
//	std::clog << "  Spat = " << Spat << std::endl;
	if (fabs(Spat) - 1e-10 <= 0.0) { return 0.0; } // should be nan!
        double Sign = 1.0;
        if (Spat >= 0.0) { Sign = -1.0; };
	n2.scaleByScalar(Sign);
        double angle = n1.angleBetween(n2);
        return angle;
}
~~~


original objc code:

~~~ { .ObjectiveC }
+(double)calculateDihedralAngleBetween: (MTCoordinates*)P1 and:(MTCoordinates*)P2 to:(MTCoordinates*)P3 and:(MTCoordinates*)P4
{
        MTCoordinates *V21 = [P1 differenceTo: P2];
        MTCoordinates *V23 = [P3 differenceTo: P2];
        MTCoordinates *V32 = [P2 differenceTo: P3];
        MTCoordinates *V34 = [P4 differenceTo: P3];
        MTCoordinates *N1 = [V21 vectorProductBy: V23];
        [N1 normalize];
        MTCoordinates *N2 = [V32 vectorProductBy: V34];
        [N2 normalize];
        double Spat = [V23 mixedProductBy: N1 and: N2];
        double Sign = 1.0;
        if (Spat >= 0.0) { Sign = -1.0; };
        double angle = [N1 angleBetween: N2] * Sign;
        return angle;
}

~~~
