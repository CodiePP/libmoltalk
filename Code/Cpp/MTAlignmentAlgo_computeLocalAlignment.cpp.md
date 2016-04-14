
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }

#undef VERBOSE_TRACEBACK

void MTAlignmentAlgo::computeLocalAlignment()
{
	float f_gop = _gop;
	float f_gep = _gep;
	int maxrow, maxcol;
	float maxscore;
	float *scorematrix;
	float *hinsert, *vinsert;
	int *tbmatrix;
	int len1, len2;
	int row,col,i,j,dir;
	float score, h1,h2,h3,tval;

	_positions = {};

	i = 0;
	//for (auto r : _residues1) {
		//std::clog << _chain1->name() << ": " << (++i) << " " << r->name() << "/" << r->oneLetterCode() << std::endl; }
	len1 = _seq1.size()+1;

	i = 0;
	//for (auto r : _residues2) {
		//std::clog << _chain2->name() << ": " << (++i) << " " << r->name() << "/" << r->oneLetterCode() << std::endl; }
	len2 = _seq2.size()+1;

	scorematrix = (float*)calloc((len1)*(len2),sizeof(float));
	vinsert = (float*)calloc((len1)*(len2),sizeof(float));
	hinsert = (float*)calloc((len1)*(len2),sizeof(float));
	tbmatrix = (int*)calloc((len1)*(len2),sizeof(int));	
	
	if (! (scorematrix && vinsert && hinsert && tbmatrix))
	{
		std::clog << "failed to allocate scoring matrix." << std::endl;
		return;
	}

	/* prepare scoring matrix */
	dir = 0;
	for (row=0; row<len2; row++) {
		for (col=0; col<len1; col++) {
			scorematrix[dir] = 0.0f;
			vinsert[dir] = 0.0f;
			hinsert[dir] = 0.0f;
			tbmatrix[dir] = 0;
			dir++;
		}
	}
	maxrow=0; maxcol=0; // will hold row/col of highest value in matrix
	maxscore=0.0f; // maximum score
	dir=0; // direction of transition: -1==down, 1==right, 2==diagonal, 0==end of alignment
	for (col=1; col<len1; col++) {
		for (row=1; row<len2; row++) {
			h1=0.0f;h2=0.0f;h3=0.0f;
			score = _substm->scoreBetween(_seq1[col-1], _seq2[row-1]);
			//printf("%@ - %@ d:%2.2f h1=%2.2f\n",here,there,dist,h1);
			h1 = scorematrix[(row-1)*len1+(col-1)] + score; // diagonal element
			h2 = hinsert[(row-1)*len1+(col-1)] + score; // end of gap horizontal
			h3 = vinsert[(row-1)*len1+(col-1)] + score; // end of gap vertical
			score = h1;
			dir = 0;
			if (h3>score) {
				score = h3;
				dir = -1; // vertical
			}
			if (h2>score) {
				score = h2;
				dir = 1; // horizontal
			}
			if (h1>=score) { // overwrite in case of same value
				score = h1;
				dir = 2;
			}
			scorematrix[(row)*len1+(col)] = score; // save maximum value in matrix
			tbmatrix[(row)*len1+(col)] = dir; // save traceback direction
			
			// update maximum row/col
			if (score >= maxscore) {
				maxscore = score;
				maxrow = row; maxcol = col;
			}

			// update insertion matrices
			score = scorematrix[(row)*len1+(col-1)] - f_gop;
			tval = hinsert[(row)*len1+(col-1)] - f_gep;
			hinsert[(row)*len1+(col)] = (score>tval?score:tval);
			score = scorematrix[(row-1)*len1+(col)] - f_gop;
			tval = vinsert[(row-1)*len1+(col)] - f_gep;
			vinsert[(row)*len1+(col)] = (score>tval?score:tval);
		} // all rows
	} // all columns

#ifdef VERBOSE_TRACEBACK
	/* write score matrix to file */
	printf("maximum: %1.1f at i=%d j=%d\\n",maxscore,maxcol,maxrow);
	FILE *outfile = fopen("t_scores.csv","w");
	if (outfile)
	{
		fprintf(outfile,". .  ");
		for (col=1; col<len1; col++) {
			fprintf(outfile,"   %c  ",_seq1[col-1]);
		}
		fprintf(outfile,"\\n");
		for (row=0; row<len2; row++) {
			if (row > 0) fprintf(outfile,"%c ",_seq2[row-1]);
			else fprintf(outfile,"   ");
			for (col=0; col<len1; col++) {
				fprintf(outfile,"% 3.1f ",scorematrix[row*len1+col]);
			}
			fprintf(outfile,"\\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_tb.csv","w");
	if (outfile) {
		fprintf(outfile,".     ");
		for (col=1; col<len1; col++) {
			fprintf(outfile,"  %c ",_seq1[col-1]);
		}
		fprintf(outfile,"\\n");
		for (row=0; row<len2; row++) {
			if (row > 0) fprintf(outfile,"%c ",_seq2[row-1]);
			else fprintf(outfile,"  ");
			for (col=0; col<len1; col++) {
				fprintf(outfile,"% 3d ",tbmatrix[row*len1+col]);
			}
			fprintf(outfile,"\\n");
		}
		fclose(outfile);
	}
#endif /* VERBOSE_TRACEBACK */

/*  T R A C E B A C K  */

	i=maxcol; j=maxrow;
	score = scorematrix[j*len1+i];
	dir = 2;
	while (score > 0)
	{
		if (dir == 2)
		{
#ifdef VERBOSE_TRACEBACK
			printf("%c  %c  %1.1f @%d/%d\\n",_seq1[i-1],_seq2[j-1],score,i,j);
#endif
			_positions.push_back(MTAlPos(_residues1[(i-1)], _residues2[(j-1)]));
		} else if (dir == -1) { // gap in seq1 
#ifdef VERBOSE_TRACEBACK
			printf("-  %c\\n",_seq2[j-1]);
			_positions.push_back(MTAlPos(nullptr, _residues2[(j-1)]));
#endif
		} else if (dir == 1) { // gap in seq2 
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\\n",_seq1[i-1]);
#endif
			_positions.push_back(MTAlPos(_residues1[(i-1)], nullptr));
		} else {
#ifdef VERBOSE_TRACEBACK
			printf("?  ?  %1.1f\\n",score);
#endif
		}
		dir = tbmatrix[j*len1+i];
		if (dir == 2)
		{
			j--; i--;
		} else if (dir == -1) {
			j--;
		} else if (dir == 1) {
			i--;
		} else {
			printf("error in traceback at i=%d, j=%d\\n",i,j);
			j--; i--;
		}
		score = scorematrix[j*len1+i];
	}

	free (hinsert);
	free (vinsert);
	free (scorematrix);
	free (tbmatrix);

	_computed = true;
}

#undef VERBOSE_TRACEBACK
~~~

original objc code:

~~~ { .ObjectiveC }

/*
 *   compute the local (Smith-Waterman) alignment between the two @class(MTChain), derive the structural alignment based on the pairwise assignment
 */
-(void)computeLocalAlignment
{
	MTAlPos *alpos;
	float *scorematrix;
	float *hinsert, *vinsert;
	int *tbmatrix;
	const char *seq1, *seq2;
	int len1, len2;
	int row,col,i,j,dir;
	int maxrow, maxcol;
	float score, h1,h2,h3,tval, maxscore;
	NSMutableArray *residues1, *residues2;

	CREATE_AUTORELEASE_POOL(pool);

	if (positions)
	{
		[positions removeAllObjects]; 
		RELEASE(positions); // get rid of old MTAlPos(itions)
		positions = nil;
	}
	positions = RETAIN([NSMutableArray arrayWithCapacity: 200]);
	
	
	/* prepare sequence 1 and 2 */
	seq1 = [[chain1 get3DSequence] cString];
	len1 = [chain1 countStandardAminoAcids]+1;
	seq2 = [[chain2 get3DSequence] cString];
	len2 = [chain2 countStandardAminoAcids]+1;
	residues1 = [NSMutableArray arrayWithCapacity: len1-1 ];
	residues2 = [NSMutableArray arrayWithCapacity: len2-1 ];
	MTResidue *tres;
	NSEnumerator *resenum = [chain1 allResidues];
	while ((tres = [resenum nextObject]))
	{
		if ([tres isStandardAminoAcid])
		{
			[residues1 addObject: tres];
		}
	}
	resenum = [chain2 allResidues];
	while ((tres = [resenum nextObject]))
	{
		if ([tres isStandardAminoAcid])
		{
			[residues2 addObject: tres];
		}
	}
	if ([residues1 count] != (len1 - 1))
	{
		NSLog(@"Not the same number of residues found in chain1 as in 3D sequence.");
		return;
	}
	if ([residues2 count] != (len2 - 1))
	{
		NSLog(@"Not the same number of residues found in chain2 as in 3D sequence.");
		return;
	}

	scorematrix = (float*)calloc((len1)*(len2),sizeof(float));
	vinsert = (float*)calloc((len1)*(len2),sizeof(float));
	hinsert = (float*)calloc((len1)*(len2),sizeof(float));
	tbmatrix = (int*)calloc((len1)*(len2),sizeof(int));	
	
	if (! (scorematrix && vinsert && hinsert && tbmatrix))
	{
		NSLog(@"failed to allocate scoring matrix.");
		RELEASE(pool);
		return;
	}

	/* prepare scoring matrix */
	dir = 0;
	for (row=0; row<len2; row++)
	{
		for (col=0; col<len1; col++)
		{
			scorematrix[dir] = 0.0f;
			vinsert[dir] = 0.0f;
			hinsert[dir] = 0.0f;
			tbmatrix[dir] = 0;
			dir++;
		}
	}
	maxrow=0; maxcol=0; // will hold row/col of highest value in matrix
	maxscore=0.0f; // maximum score
	dir=0; // direction of transition: -1==down, 1==right, 2==diagonal, 0==end of alignment
	for (col=1; col<len1; col++)
	{
		for (row=1; row<len2; row++)
		{
			h1=0.0f;h2=0.0f;h3=0.0f;
			score = [substitutionMatrix exchangeScoreBetween: seq1[col-1] and: seq2[row-1] ];
			//printf("%@ - %@ d:%2.2f h1=%2.2f\\n",here,there,dist,h1);
			h1 = scorematrix[(row-1)*len1+(col-1)] + score; // diagonal element
			h2 = hinsert[(row-1)*len1+(col-1)] + score; // end of gap horizontal
			h3 = vinsert[(row-1)*len1+(col-1)] + score; // end of gap vertical
			score = h1;
			dir = 0;
			if (h3>score)
			{
				score = h3;
				dir = -1; // vertical
			}
			if (h2>score)
			{
				score = h2;
				dir = 1; // horizontal
			}
			if (h1>=score)	// overwrite in case of same value
			{
				score = h1;
				dir = 2;
			}
			scorematrix[(row)*len1+(col)] = score; // save maximum value in matrix
			tbmatrix[(row)*len1+(col)] = dir; // save traceback direction
			
			// update maximum row/col
			if (score >= maxscore)
			{
				maxscore = score;
				maxrow = row; maxcol = col;
			}

			// update insertion matrices
			score = scorematrix[(row)*len1+(col-1)] - f_gop;
			tval = hinsert[(row)*len1+(col-1)] - f_gep;
			hinsert[(row)*len1+(col)] = (score>tval?score:tval);
			score = scorematrix[(row-1)*len1+(col)] - f_gop;
			tval = vinsert[(row-1)*len1+(col)] - f_gep;
			vinsert[(row)*len1+(col)] = (score>tval?score:tval);
		} // all rows
	} // all columns


	/* write score matrix to file */
#ifdef VERBOSE_TRACEBACK
	printf("maximum: %1.1f at i=%d j=%d\n",maxscore,maxcol,maxrow);
	FILE *outfile = fopen("t_scores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".    ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"   %c  ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c ",seq2[row-1]);
			else fprintf(outfile,"   ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 3.1f ",scorematrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_tb.csv","w");
	if (outfile)
	{
		fprintf(outfile,".     ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"  %c ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c ",seq2[row-1]);
			else fprintf(outfile,"  ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 3d ",tbmatrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
#endif /* VERBOSE_TRACEBACK */


/*  T R A C E B A C K  */

	i=maxcol; j=maxrow;
	score = scorematrix[j*len1+i];
	dir = 2;
	while (score > 0)
	{
		if (dir == 2)
		{
#ifdef VERBOSE_TRACEBACK
			printf("%c  %c  %1.1f\n",seq1[i-1],seq2[j-1],score);
#endif
			alpos = [MTAlPos alposWithRes1: [residues1 objectAtIndex: (i-1)] res2: [residues2 objectAtIndex: (j-1)]];
		} else if (dir == -1) { // gap in seq1 
#ifdef VERBOSE_TRACEBACK
			printf("-  %c\n",seq2[j-1]);
#endif
			alpos = [MTAlPos alposWithRes1: nil res2: [residues2 objectAtIndex: (j-1)]];
		} else if (dir == 1) { // gap in seq2 
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\n",seq1[i-1]);
#endif
			alpos = [MTAlPos alposWithRes1: [_residues1 objectAtIndex: (i-1)] res2: nil];
		} else {
#ifdef VERBOSE_TRACEBACK
			printf("?  ?  %1.1f\n",score);
#endif
			alpos = nil;
		}
		if (alpos)
		{
			[positions addObject: alpos];
		}
		dir = tbmatrix[j*len1+i];
		if (dir == 2)
		{
			j--; i--;
		} else if (dir == -1) {
			j--;
		} else if (dir == 1) {
			i--;
		} else {
			printf("error in traceback at i=%d, j=%d\n",i,j);
			j--; i--;
		}
		score = scorematrix[j*len1+i];
	}

	free (hinsert);
	free (vinsert);
	free (scorematrix);
	free (tbmatrix);

	computed = YES;

	RELEASE(pool);
}
~~~
