
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }
void MTCoordinates::transformBy(MTMatrix53 const & m)
{
        /*         0  1  2
         * 0     |r1 r2 r3|      |x|
         * 1     |r4 r5 r6|      |y|
         * 2 M = |r7 r8 r9|  v = |z|
         * 3     |o1 o2 o3|      |1|
         * 4     |t1 t2 t3|
         *
         *           |r1*x+r2*y+r3*z+t1*1|
         *           |r4*x+r5*x+r6*z+t2*1|
         * v' = Mv = |r7*x+r8*x+r9*z+t3*1|
         *           |o1*x+o2*x+o3*z+1*1 |
         *
         */
        double x1,y1,z1;
        double t1,t2,t3;
        double r1,r2,r3,r4,r5,r6,r7,r8,r9;
        x1=x()-m.atRowCol(3, 0); y1=y()-m.atRowCol(3, 1); z1=z()-m.atRowCol(3, 2);
        t1=m.atRowCol(4, 0); t2=m.atRowCol(4, 1); t3=m.atRowCol(4, 2);
        r1=m.atRowCol(0, 0); r2=m.atRowCol(0, 1); r3=m.atRowCol(0, 2);
        r4=m.atRowCol(1, 0); r5=m.atRowCol(1, 1); r6=m.atRowCol(1, 2);
        r7=m.atRowCol(2, 0); r8=m.atRowCol(2, 1); r9=m.atRowCol(2, 2);
        set( r1*x1+r2*y1+r3*z1+t1
           , r4*x1+r5*y1+r6*z1+t2
           , r7*x1+r8*y1+r9*z1+t3 );
}
~~~


original objc code:

~~~ { .ObjectiveC }
-(id)transformBy:(MTMatrix53*)m
{
        /*         0  1  2
         * 0     |r1 r2 r3|      |x|
         * 1     |r4 r5 r6|      |y|
         * 2 M = |r7 r8 r9|  v = |z|
         * 3     |o1 o2 o3|      |1|
         * 4     |t1 t2 t3|
         *
         *           |r1*x+r2*y+r3*z+t1*1|
         *           |r4*x+r5*x+r6*z+t2*1|
         * v' = Mv = |r7*x+r8*x+r9*z+t3*1|
         *           |o1*x+o2*x+o3*z+1*1 |
         *
         */
        double x,y,z;
        double t1,t2,t3;
        double r1,r2,r3,r4,r5,r6,r7,r8,r9;
        x=[self x]-[m atRow:3 col:0]; y=[self y]-[m atRow:3 col:1]; z=[self z]-[m atRow:3 col:2];
        t1=[m atRow:4 col:0]; t2=[m atRow:4 col:1]; t3=[m atRow:4 col:2];
        r1=[m atRow:0 col:0]; r2=[m atRow:0 col:1]; r3=[m atRow:0 col:2];
        r4=[m atRow:1 col:0]; r5=[m atRow:1 col:1]; r6=[m atRow:1 col:2];
        r7=[m atRow:2 col:0]; r8=[m atRow:2 col:1]; r9=[m atRow:2 col:2];
        [self setX:(r1*x+r2*y+r3*z+t1)
                 Y:(r4*x+r5*y+r6*z+t2)
                 Z:(r7*x+r8*y+r9*z+t3)];
        return self;
}

~~~
