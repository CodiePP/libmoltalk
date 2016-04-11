
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix53 MTMatrix::alignTo(MTMatrix const & p_m2)
{
  if (cols() != 3 || p_m2.cols() != 3) {
      std::clog << "MTMatrix::alignTo only works on matrices with 3 columns." << std::endl;
      return MTMatrix53();
  }
  if (rows() != p_m2.rows()) {
      std::clog << "MTMatrix::alignTo only works on matrices with equal number of rows." << std::endl;
      return MTMatrix53();
  }

  MTMatrix m2(p_m2);
  MTMatrix com1 = centerOfMass();
  MTMatrix com2 = m2.centerOfMass();

  int irow;
  double o11,o12,o13;
  double o21,o22,o23;
  o11 = com1.atRowCol(0, 0);
  o12 = com1.atRowCol(0, 1);
  o13 = com1.atRowCol(0, 2);
  o21 = com2.atRowCol(0, 0);
  o22 = com2.atRowCol(0, 1);
  o23 = com2.atRowCol(0, 2);
  for (irow=0; irow<rows(); irow++) {
      /* move to origin */
      atRowColSub(irow, 0, o11);
      atRowColSub(irow, 1, o12);
      atRowColSub(irow, 2, o13);
      m2.atRowColSub(irow, 0, o21);
      m2.atRowColSub(irow, 1, o22);
      m2.atRowColSub(irow, 2, o23);
  }
  MTMatrix subm = m2.msubtract(*this);
  MTMatrix subp = this->madd(m2);
  MTMatrix xm = subm.matrixOfColumn(0);
  MTMatrix ym = subm.matrixOfColumn(1);
  MTMatrix zm = subm.matrixOfColumn(2);
  MTMatrix xp = subp.matrixOfColumn(0);
  MTMatrix yp = subp.matrixOfColumn(1);
  MTMatrix zp = subp.matrixOfColumn(2);

  MTMatrix xmym = xm.mmultiply(ym);
  MTMatrix xmyp = xm.mmultiply(yp);
  MTMatrix xpym = xp.mmultiply(ym);
  MTMatrix xpyp = xp.mmultiply(yp);
  MTMatrix xmzm = xm.mmultiply(zm);
  MTMatrix xmzp = xm.mmultiply(zp);
  MTMatrix xpzm = xp.mmultiply(zm);
  MTMatrix xpzp = xp.mmultiply(zp);
  MTMatrix ymzm = ym.mmultiply(zm);
  MTMatrix ymzp = ym.mmultiply(zp);
  MTMatrix ypzm = yp.mmultiply(zm);
  MTMatrix ypzp = yp.mmultiply(zp);

  MTMatrix mdiag(4, 4);
  double sumall;
  sumall = ypzm.msubtract(ymzp).sum();
  mdiag.atRowColValue(0, 1, sumall);
  sumall = xmzp.msubtract(xpzm).sum();
  mdiag.atRowColValue(0, 2, sumall);
  sumall = xpym.msubtract(xmyp).sum();
  mdiag.atRowColValue(0, 3, sumall);
  sumall = ypzm.msubtract(ymzp).sum();
  mdiag.atRowColValue(1, 0, sumall);
  sumall = xmym.msubtract(xpyp).sum();
  mdiag.atRowColValue(1, 2, sumall);
  sumall = xmzm.msubtract(xpzp).sum();
  mdiag.atRowColValue(1, 3, sumall);
  sumall = xmzp.msubtract(xpzm).sum();
  mdiag.atRowColValue(2, 0, sumall);
  sumall = xmym.msubtract(xpyp).sum();
  mdiag.atRowColValue(2, 1, sumall);
  sumall = ymzm.msubtract(ypzp).sum();
  mdiag.atRowColValue(2, 3, sumall);
  sumall = xpym.msubtract(xmyp).sum();
  mdiag.atRowColValue(3, 0, sumall);
  sumall = xmzm.msubtract(xpzp).sum();
  mdiag.atRowColValue(3, 1, sumall);
  sumall = ymzm.msubtract(ypzp).sum();
  mdiag.atRowColValue(3, 2, sumall);

  xm.square();
  xp.square();
  ym.square();
  yp.square();
  zm.square();
  zp.square();

  sumall = xm.madd(ym).madd(zm).sum();
  mdiag.atRowColValue(0, 0, sumall);
  sumall = yp.madd(zp).madd(xm).sum();
  mdiag.atRowColValue(1, 1, sumall);
  sumall = xp.madd(zp).madd(ym).sum();
  mdiag.atRowColValue(2, 2, sumall);
  sumall = xp.madd(yp).madd(zm).sum();
  mdiag.atRowColValue(3, 3, sumall);

  MTMatrix eigen = mdiag.diagonalizeWithMaxError(1.0e-10);
  double q1=0.0,q2=0.0,q3=0.0,q4=0.0;
  double t_val;
  double vmax = 1e199; //FLT_MAX;
  for (irow=0; irow<eigen.cols(); irow++) {
      /* find smallest eigenvalue and corresponding eigenvector */
      t_val = eigen.atRowCol(0, irow);
      if (t_val < vmax) {
          q1 = eigen.atRowCol(1, irow);
          q2 = eigen.atRowCol(2, irow);
          q3 = eigen.atRowCol(3, irow);
          q4 = eigen.atRowCol(4, irow);
          vmax = t_val;
      }
  }

  //std::clog << (boost::format("minimum: %1.3f\\neigenvalues/eigenvectors: %s") % vmax % eigen.toString()).str() << std::endl;

  /* return RT operator */
  MTMatrix53 res;
  /* enter rotation */
  res.atRowColValue(0, 0, (q1*q1 + q2*q2 - q3*q3 - q4*q4));
  res.atRowColValue(0, 1, (2.0*(q2*q3 + q1*q4)));
  res.atRowColValue(0, 2, (2.0*(q2*q4 - q1*q3)));
  res.atRowColValue(1, 0, (2.0*(q2*q3 - q1*q4)));
  res.atRowColValue(1, 1, (q1*q1 - q2*q2 + q3*q3 - q4*q4));
  res.atRowColValue(1, 2, (2.0*(q3*q4 + q1*q2)));
  res.atRowColValue(2, 0, (2.0*(q2*q4 + q1*q3)));
  res.atRowColValue(2, 1, (2.0*(q3*q4 - q1*q2)));
  res.atRowColValue(2, 2, (q1*q1 - q2*q2 - q3*q3 + q4*q4));
  /* enter origin */
  res.atRowColValue(3, 0, com1.atRowCol(0, 0));
  res.atRowColValue(3, 1, com1.atRowCol(0, 1));
  res.atRowColValue(3, 2, com1.atRowCol(0, 2));
  /* enter translation */
  res.atRowColValue(4, 0, com2.atRowCol(0, 0));
  res.atRowColValue(4, 1, com2.atRowCol(0, 1));
  res.atRowColValue(4, 2, com2.atRowCol(0, 2));

  return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *
 */
-(MTMatrix53*)alignTo:(MTMatrix*)m2
{
        if (!([self cols] == 3 && [m2 cols] == 3))
        {
                [NSException raise:@"unimplemented" format:@"Matrices must have cols = 
3."];
        }
        if ([self rows] != [m2 rows])
        {
                [NSException raise:@"unimplemented" format:@"Matrices must have same nu
mber of rows."];
        }
#ifdef DEBUG_COMPUTING_TIME
        clock_t timebase1,timebase2;
        timebase1 = clock ();
#endif  

        CREATE_AUTORELEASE_POOL(pool);
                
        MTMatrix *com1 = [self centerOfMass];
        //NSLog(@"com1: %@",com1);
        MTMatrix *com2 = [m2 centerOfMass];
        //NSLog(@"com2: %@",com2);
        
        int irow;
        double o11,o12,o13;
        double o21,o22,o23;
        o11 = [com1 atRow: 0 col: 0];
        o12 = [com1 atRow: 0 col: 1];
        o13 = [com1 atRow: 0 col: 2];
        o21 = [com2 atRow: 0 col: 0];
        o22 = [com2 atRow: 0 col: 1];
        o23 = [com2 atRow: 0 col: 2];
        for (irow=0; irow<[self rows]; irow++)
        { /* move to origin */
                [self atRow: irow col: 0 subtract: o11];
                [self atRow: irow col: 1 subtract: o12];
                [self atRow: irow col: 2 subtract: o13];
                [m2 atRow: irow col: 0 subtract: o21];
                [m2 atRow: irow col: 1 subtract: o22];
                [m2 atRow: irow col: 2 subtract: o23];
        }
        MTMatrix *subm = [m2 msubtract: self];
        //NSLog(@"subm: %@",subm);
        MTMatrix *subp = [self madd: m2];
        //NSLog(@"subp: %@",subp);
        MTMatrix *xm = [subm matrixOfColumn: 0];
        MTMatrix *ym = [subm matrixOfColumn: 1];
        MTMatrix *zm = [subm matrixOfColumn: 2];
        MTMatrix *xp = [subp matrixOfColumn: 0];
        MTMatrix *yp = [subp matrixOfColumn: 1];
        MTMatrix *zp = [subp matrixOfColumn: 2];

        MTMatrix *xmym = [xm mmultiply: ym];
        MTMatrix *xmyp = [xm mmultiply: yp];
        MTMatrix *xpym = [xp mmultiply: ym];
        MTMatrix *xpyp = [xp mmultiply: yp];
        MTMatrix *xmzm = [xm mmultiply: zm];
        MTMatrix *xmzp = [xm mmultiply: zp];
        MTMatrix *xpzm = [xp mmultiply: zm];
        MTMatrix *xpzp = [xp mmultiply: zp];
        MTMatrix *ymzm = [ym mmultiply: zm];
        MTMatrix *ymzp = [ym mmultiply: zp];
        MTMatrix *ypzm = [yp mmultiply: zm];
        MTMatrix *ypzp = [yp mmultiply: zp];
        MTMatrix *mdiag = [MTMatrix matrixWithRows: 4 cols: 4];
        
        double sumall;
        sumall = [[ypzm msubtract: ymzp] sum];
        [mdiag atRow: 0 col: 1 value: sumall];
        sumall = [[xmzp msubtract: xpzm] sum];
        [mdiag atRow: 0 col: 2 value: sumall];
        sumall = [[xpym msubtract: xmyp] sum];
        [mdiag atRow: 0 col: 3 value: sumall];
        sumall = [[ypzm msubtract: ymzp] sum];
        [mdiag atRow: 1 col: 0 value: sumall];
        sumall = [[xmym msubtract: xpyp] sum];
        [mdiag atRow: 1 col: 2 value: sumall];
        sumall = [[xmzm msubtract: xpzp] sum];
        [mdiag atRow: 1 col: 3 value: sumall];
        sumall = [[xmzp msubtract: xpzm] sum];
        [mdiag atRow: 2 col: 0 value: sumall];
        sumall = [[xmym msubtract: xpyp] sum];
        [mdiag atRow: 2 col: 1 value: sumall];
        sumall = [[ymzm msubtract: ypzp] sum];
        [mdiag atRow: 2 col: 3 value: sumall];
        sumall = [[xpym msubtract: xmyp] sum];
        [mdiag atRow: 3 col: 0 value: sumall];
        sumall = [[xmzm msubtract: xpzp] sum];
        [mdiag atRow: 3 col: 1 value: sumall];
        sumall = [[ymzm msubtract: ypzp] sum];
        [mdiag atRow: 3 col: 2 value: sumall];

        [xm square];
        [xp square];
        [ym square];
        [yp square];
        [zm square];
        [zp square];
        
        sumall = [[[xm madd: ym] madd: zm] sum];
        [mdiag atRow: 0 col: 0 value: sumall];
        sumall = [[[yp madd: zp] madd: xm] sum];
        [mdiag atRow: 1 col: 1 value: sumall];
        sumall = [[[xp madd: zp] madd: ym] sum];
        [mdiag atRow: 2 col: 2 value: sumall];
        sumall = [[[xp madd: yp] madd: zm] sum];
        [mdiag atRow: 3 col: 3 value: sumall];
        
        MTMatrix *eigen = [mdiag diagonalizeWithMaxError: 1.0e-10];
        double q1=0.0,q2=0.0,q3=0.0,q4=0.0;
        double t_val;
       double vmax = FLT_MAX;
        for (irow=0; irow<[eigen cols]; irow++)
        { /* find smallest eigenvalue and corresponding eigenvector */
                t_val = [eigen atRow: 0 col: irow];
                if (t_val < vmax)
                {
                        q1 = [eigen atRow: 1 col: irow];
                        q2 = [eigen atRow: 2 col: irow];
                        q3 = [eigen atRow: 3 col: irow];
                        q4 = [eigen atRow: 4 col: irow];
                        vmax = t_val;
                }
        }
        
        //printf("minimum: %1.3f\neigenvalues/eigenvectors: %s\n",vmax,[[eigen description]cString]);
        
        /* return RT operator */
        MTMatrix53 *res = [MTMatrix53 new];
        /* enter rotation */
        [res atRow: 0 col: 0 value: (q1*q1 + q2*q2 - q3*q3 - q4*q4)];
        [res atRow: 0 col: 1 value: (2.0*(q2*q3 + q1*q4))];
        [res atRow: 0 col: 2 value: (2.0*(q2*q4 - q1*q3))];
        [res atRow: 1 col: 0 value: (2.0*(q2*q3 - q1*q4))];
        [res atRow: 1 col: 1 value: (q1*q1 - q2*q2 + q3*q3 - q4*q4)];
        [res atRow: 1 col: 2 value: (2.0*(q3*q4 + q1*q2))];
        [res atRow: 2 col: 0 value: (2.0*(q2*q4 + q1*q3))];
        [res atRow: 2 col: 1 value: (2.0*(q3*q4 - q1*q2))];
        [res atRow: 2 col: 2 value: (q1*q1 - q2*q2 - q3*q3 + q4*q4)];
        /* enter origin */
        [res atRow: 3 col: 0 value: [com1 atRow: 0 col: 0]];
        [res atRow: 3 col: 1 value: [com1 atRow: 0 col: 1]];
        [res atRow: 3 col: 2 value: [com1 atRow: 0 col: 2]];
        /* enter translation */
        [res atRow: 4 col: 0 value: [com2 atRow: 0 col: 0]];
        [res atRow: 4 col: 1 value: [com2 atRow: 0 col: 1]];
        [res atRow: 4 col: 2 value: [com2 atRow: 0 col: 2]];

        RELEASE(pool);
#ifdef DEBUG_COMPUTING_TIME
        timebase2 = clock ();
        printf("  time spent in Matrix_alignTo: %1.1f ms\n",((timebase2-timebase1)*1000.0f/CLOCKS_PER_SEC));
        timebase1 = timebase2;
#endif

        return AUTORELEASE(res);
}
~~~
