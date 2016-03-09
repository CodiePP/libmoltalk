
declared in [MTMatrix53](MTMatrix53.hpp.md)

TODO  :exclamation:

~~~ { .cpp }
MTMatrix53 MTMatrix53::transformation3By3(MTMatrix const & first, MTMatrix const & second)
{
	return MTMatrix53();
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   computes the transformation of the second onto the first coordinates
 *   the coordinates are passed in 3x3 matrices:
 *     P1X P1Y P1Z
 *     P2X P2Y P2Z
 *     P3X P3Y P3Z
 */
+(MTMatrix53*)transformation3By3:(MTMatrix*)first and:(MTMatrix*)second
{
        if (!first || !second || [first rows] != 3 || [first cols] != 3
         || [second rows] != 3 || [second cols] != 3)
        {
                [NSException raise:@"Matrix53_transformation3By3:" format:@"Input parameters must be 3x3 matrices of three v
ectors."];
        }

        double center1X = [first atRow: 0 col: 0] + [first atRow: 1 col: 0] + [first atRow: 2 col: 0]; 
        double center1Y = [first atRow: 0 col: 1] + [first atRow: 1 col: 1] + [first atRow: 2 col: 1]; 
        double center1Z = [first atRow: 0 col: 2] + [first atRow: 1 col: 2] + [first atRow: 2 col: 2]; 
        double center2X = [second atRow: 0 col: 0] + [second atRow: 1 col: 0] + [second atRow: 2 col: 0]; 
        double center2Y = [second atRow: 0 col: 1] + [second atRow: 1 col: 1] + [second atRow: 2 col: 1]; 
        double center2Z = [second atRow: 0 col: 2] + [second atRow: 1 col: 2] + [second atRow: 2 col: 2]; 

        center1X /= 3.0; center1Y /= 3.0; center1Z /= 3.0;
        center2X /= 3.0; center2Y /= 3.0; center2Z /= 3.0;

        MTCoordinates *v11 = [MTCoordinates coordsWithX: ([first atRow: 1 col: 0]-[first atRow: 0 col: 0]) Y: ([first atRow:
 1 col: 1]-[first atRow: 0 col: 1]) Z: ([first atRow: 1 col: 2]-[first atRow: 0 col: 2])];
        MTCoordinates *v12 = [MTCoordinates coordsWithX: ([first atRow: 2 col: 0]-[first atRow: 0 col: 0]) Y: ([first atRow: 2 col: 1]-[first atRow: 0 col: 1]) Z: ([first atRow: 2 col: 2]-[first atRow: 0 col: 2])];

        MTCoordinates *v21 = [MTCoordinates coordsWithX: ([second atRow: 1 col: 0]-[second atRow: 0 col: 0]) Y: ([second atRow: 1 col: 1]-[second atRow: 0 col: 1]) Z: ([second atRow: 1 col: 2]-[second atRow: 0 col: 2])];
        MTCoordinates *v22 = [MTCoordinates coordsWithX: ([second atRow: 2 col: 0]-[second atRow: 0 col: 0]) Y: ([second atRow: 2 col: 1]-[second atRow: 0 col: 1]) Z: ([second atRow: 2 col: 2]-[second atRow: 0 col: 2])];

        /* align normals to each other */
        MTCoordinates *n1 = [MTCoordinates coordsFromVector: [v11 vectorProductBy: v12]];
        [n1 normalize];
        MTCoordinates *n2 = [MTCoordinates coordsFromVector: [v21 vectorProductBy: v22]];
        [n2 normalize];
        MTMatrix44 *r1 = [n1 alignToZaxis];
        MTMatrix44 *r2 = [n2 alignToZaxis];

        [v11 normalize];
        [v21 normalize];
        [v11 rotateBy: r1]; // now in XY-plane
        [v21 rotateBy: r2]; // now in XY-plane

        /* check handedness */
        double handedness = 1.0; // right handed
        MTVector *thdn = [v11 vectorProductBy: v21];
        if ([thdn atDim: 2] < 0.0) 
        {
                // Z component indicates anti-parallel to Z-axis
                handedness = -1.0; // left handed
        }

        /* same rotation around normals */
        double phi = [v11 angleBetween: v21];
        MTMatrix44 *rZ = [MTMatrix44 rotationZ: (phi*handedness)];

        /* rotate second by r2 -> along Z-axis
           rotation around Z-axis -> both relative aligned
           rotate back from Z-axis using r1 (transposed)
        */
        [r1 transpose];
        MTMatrix44 *rot = [r1 x: rZ];
        rot = [rot x: r2];

        MTMatrix53 *trafo = [MTMatrix53 matrixIdentity];
        int i,j;
        double val;
        /* enter rotation */
        for (i=0; i<3; i++)
        {
                for (j=0; j<3; j++)
                {
                        val = [rot atRow: i col: j];
                        [trafo atRow: i col: j value: val];
                }
        }
        /* enter origin */
        [trafo atRow: 3 col: 0 value: center2X];
        [trafo atRow: 3 col: 1 value: center2Y];
        [trafo atRow: 3 col: 2 value: center2Z];
        /* enter translation */
        [trafo atRow: 4 col: 0 value: center1X];
        [trafo atRow: 4 col: 1 value: center1Y];
        [trafo atRow: 4 col: 2 value: center1Z];
        
        return trafo;
}

~~~
