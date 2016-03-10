
declared in [MTPDBParser](MTPDBParser.hpp.md)

~~~ { .cpp }

std::shared_ptr<MTStructure> MTPDBParser::parseStructureFromPDBStream(std::istream & str)
{
	if (! str.good()) {
		std::cerr << "Error on input stream" << std::endl;
		return nullptr; }
		
	MTStructureFactory _factory;
	_pimpl->_strx = _factory.newInstance();

	struct pdbline _pdbline;

	std::string _ts;
	while (str.good()) {
		_ts.clear();
		str.getline(_pdbline.buf, 120);
		//strncpy(_pdbline.buf, _ts.c_str(), 120);
		_pdbline.cleanup();
		_pimpl->readLine(_pdbline);
	} // while

	_pimpl->finish_parsing();

	return std::move(_pimpl->_strx);
}
~~~


~~~ { .cpp }

std::shared_ptr<MTStructure> MTPDBParser::parseStructureFromPDBFile(std::string const & fn)
{
	if (! boost::filesystem::exists(fn)) {
		std::cerr << "File " << fn << " cannot be read." << std::endl;
		return nullptr; }

	FILE *fin = fopen(fn.c_str(), "rb");
	if (! fin) {
		std::cerr << "Error on opening " << fn << std::endl;
		return nullptr; }
		
	MTStructureFactory _factory;
	_pimpl->_strx = _factory.newInstance();

	struct pdbline _pdbline;

	int lineno=0;
	while (! feof(fin)) {
		fgets(_pdbline.buf, 120, fin);
		++lineno;
		_pdbline.cleanup();
		_pimpl->readLine(_pdbline);
	} // while

	fclose(fin);

	_pimpl->finish_parsing();

	return std::move(_pimpl->_strx);
}
~~~


original objc code:

~~~ { .ObjectiveC }
/* Copyright 2003-2006  Alexander V. Diemand

    This file is part of MolTalk.

    MolTalk is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    MolTalk is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MolTalk; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
 
/* vim: set filetype=objc: */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "MTPDBParser.oh"
#include "privateMTStructure.oh"
#include "privateMTChain.oh"
#include "privateMTResidue.oh"
#include "MTAtom.oh"
#include "MTCompressedFileStream.oh"
#include "MTString.oh"
#include "MTStructureFactory.oh"
#include "MTChainFactory.oh"
#include "MTResidueFactory.oh"
#include "MTAtomFactory.oh"
#include "MTMatrix44.oh"
#include "MTSelection.oh"


/*  s e t  t o  g e t  memory allocation debugging */
#undef MEMDEBUG


static NSCalendarDate *mkISOdate (char *dstring);
static int mkInt (const char *buffer, int len);
static double mkFloat (const char *buffer, int len);


/* private declaration */
@interface MTPDBParser (Private)	//@nodoc

/*
 *   add a bond between two atoms (indicated by atom numbers)
 */
-(void)addBondFrom:(unsigned int)atm1 to:(unsigned int)atm2;

/*
 *   callbacks for reading lines from PDB files
 */
-(oneway void)readAtom:(in NSString*)line;
-(oneway void)readHetatom:(in NSString*)line;
-(oneway void)readConnect:(in NSString*)line;
-(oneway void)readHeader:(in NSString*)line;
-(oneway void)readTitle:(in NSString*)line;
-(oneway void)readCompound:(in NSString*)line;
-(oneway void)readSource:(in NSString*)line;
-(oneway void)readKeywords:(in NSString*)line;
-(oneway void)readExpdata:(in NSString*)line;
-(oneway void)readRemark:(in NSString*)line;
-(oneway void)readModel:(in NSString*)line;
-(oneway void)readEndModel:(in NSString*)line;
-(oneway void)readRevDat:(in NSString*)line;
-(oneway void)readChainTerminator:(in NSString*)line;
-(oneway void)readHetname:(in NSString*)line;
-(oneway void)readModres:(in NSString*)line;
-(oneway void)readSeqres:(in NSString*)line;
-(oneway void)readCryst:(in NSString*)line;
-(oneway void)readScale:(in NSString*)line;
-(oneway void)readMatrix:(in NSString*)line;
-(oneway void)readOrigx:(in NSString*)line;
-(oneway void)readSite:(in NSString*)line;

@end

@implementation MTPDBParser	//@nodoc

-(id)initWithOptions:(long)p_opts
{
	[super init];

	// internal state variables
	options = p_opts;
	SrcOldStyle = YES;
	CmpndOldStyle = YES;
	newfileformat = NO;
	
	modelnr = 0;
	haveModel1 = NO;

	lastrevnr = 0;
	lastcarboxyl = nil; // connect amino acids N-term - C-term
	last3prime = nil;   // connect nucleic acids 5' - 3'
	lastalternatesite = ' '; // the id of the last alternate site read

	// default information
	pdbcode = @"0UNK";
	header = @"HEADER MISSING";
	date = nil;
	lastrevdate = nil;
	title = @"";
	keywords = @"";
	resolution = 0.0;
	expdata = Structure_Unknown;

	/* connect PDB formatted line heads to our selectors */
	parserSelectors = [NSMutableDictionary new];

	NSInvocation *invoc;
	
	/* ATOM */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readAtom:)]];
	[invoc setSelector:  @selector(readAtom:)];
	[parserSelectors setObject: invoc forKey: @"ATOM  "];
	
	/* HETATM */
	/* CONECT */
	if (!(options & PDBPARSER_IGNORE_HETEROATOMS))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readHetatom:)]];
		[invoc setSelector: @selector(readHetatom:)];
		[parserSelectors setObject: invoc forKey: @"HETATM"];
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readConnect:)]];
		[invoc setSelector: @selector(readConnect:)];
		[parserSelectors setObject: invoc forKey: @"CONECT"];
	}

	/* HEADER */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readHeader:)]];
	[invoc setSelector: @selector(readHeader:)];
	[parserSelectors setObject: invoc forKey: @"HEADER"];
	
	/* REVDAT */
	if (!(options & PDBPARSER_IGNORE_REVDAT))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readRevDat:)]];
		[invoc setSelector: @selector(readRevDat:)];
		[parserSelectors setObject: invoc forKey: @"REVDAT"];
	}
	
	/* TITLE */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readTitle:)]];
	[invoc setSelector: @selector(readTitle:)];
	[parserSelectors setObject: invoc forKey: @"TITLE "];
	
	/* COMPND */
	if (!(options & PDBPARSER_IGNORE_COMPOUND))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readCompound:)]];
		[invoc setSelector: @selector(readCompound:)];
		[parserSelectors setObject: invoc forKey: @"COMPND"];
	}
	
	/* SOURCE */
	if (!(options & PDBPARSER_IGNORE_SOURCE))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readSource:)]];
		[invoc setSelector: @selector(readSource:)];
		[parserSelectors setObject: invoc forKey: @"SOURCE"];
	}

	/* KEYWDS */
	if (!(options & PDBPARSER_IGNORE_KEYWORDS))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readKeywords:)]];
		[invoc setSelector: @selector(readKeywords:)];
		[parserSelectors setObject: invoc forKey: @"KEYWDS"];
	}
	
	/* EXPDTA */
	if (!(options & PDBPARSER_IGNORE_EXPDTA))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readExpdata:)]];
		[invoc setSelector: @selector(readExpdata:)];
		[parserSelectors setObject: invoc forKey: @"EXPDTA"];
	}
	
	/* REMARK */
	if (!(options & PDBPARSER_IGNORE_REMARK))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readRemark:)]];
		[invoc setSelector: @selector(readRemark:)];
		[parserSelectors setObject: invoc forKey: @"REMARK"];
	}
	
	/* SEQRES */
	if (!(options & PDBPARSER_IGNORE_SEQRES))
	{
		invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readSeqres:)]];
		[invoc setSelector: @selector(readSeqres:)];
		[parserSelectors setObject: invoc forKey: @"SEQRES"];
	}
	
	/* TER */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readChainTerminator:)]];
	[invoc setSelector: @selector(readChainTerminator:)];
	[parserSelectors setObject: invoc forKey: @"TER   "];
	
	/* ENDMDL */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readEndModel:)]];
	[invoc setSelector: @selector(readEndModel:)];
	[parserSelectors setObject: invoc forKey: @"ENDMDL"];
	
	/* MODEL */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readModel:)]];
	[invoc setSelector: @selector(readModel:)];
	[parserSelectors setObject: invoc forKey: @"MODEL "];
	
	/* HETNAME */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readHetname:)]];
	[invoc setSelector: @selector(readHetname:)];
	[parserSelectors setObject: invoc forKey: @"HETNAM"];

	/* MODRES */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readModres:)]];
	[invoc setSelector: @selector(readModres:)];
	[parserSelectors setObject: invoc forKey: @"MODRES"];

	/* SITE */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readSite:)]];
	[invoc setSelector: @selector(readSite:)];
	[parserSelectors setObject: invoc forKey: @"SITE  "];

	/* CRYST1 */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readCryst:)]];
	[invoc setSelector: @selector(readCryst:)];
	[parserSelectors setObject: invoc forKey: @"CRYST1"];

	/* SCALE */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readScale:)]];
	[invoc setSelector: @selector(readScale:)];
	[parserSelectors setObject: invoc forKey: @"SCALE1"];
	[parserSelectors setObject: invoc forKey: @"SCALE2"];
	[parserSelectors setObject: invoc forKey: @"SCALE3"];

	/* MTRIX */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readMatrix:)]];
	[invoc setSelector: @selector(readMatrix:)];
	[parserSelectors setObject: invoc forKey: @"MTRIX1"];
	[parserSelectors setObject: invoc forKey: @"MTRIX2"];
	[parserSelectors setObject: invoc forKey: @"MTRIX3"];
	
	/* ORIGX */
	invoc = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(readOrigx:)]];
	[invoc setSelector: @selector(readOrigx:)];
	[parserSelectors setObject: invoc forKey: @"ORIGX1"];
	[parserSelectors setObject: invoc forKey: @"ORIGX2"];
	[parserSelectors setObject: invoc forKey: @"ORIGX3"];
	
	relation_chain_seqres = [NSMutableDictionary new];
	relation_chain_molid = [NSMutableDictionary new];
	relation_molid_eccode = [NSMutableDictionary new];
	relation_molid_compound = [NSMutableDictionary new];
	relation_molid_source = [NSMutableDictionary new];
	relation_residue_modres = [NSMutableDictionary new];
	
	/* where we can temporarily store atoms */
	temporaryatoms = nil; //[NSMutableDictionary new];

	return self;
}

-(void)dealloc
{
	//printf("MTPDBParser_dealloc\n\n");
	if (parserSelectors)
	{
		[parserSelectors removeAllObjects];
		RELEASE(parserSelectors);
	}
	if (relation_chain_seqres)
	{
		[relation_chain_seqres removeAllObjects];
		RELEASE(relation_chain_seqres);
	}
	if (relation_chain_molid)
	{
		[relation_chain_molid removeAllObjects];
		RELEASE(relation_chain_molid);
	}
	if (relation_molid_eccode)
	{
		[relation_molid_eccode removeAllObjects];
		RELEASE(relation_molid_eccode);
	}
	if (relation_molid_compound)
	{
		[relation_molid_compound removeAllObjects];
		RELEASE(relation_molid_compound);
	}
	if (relation_molid_source)
	{
		[relation_molid_source removeAllObjects];
		RELEASE(relation_molid_source);
	}
	if (relation_residue_modres)
	{
		[relation_residue_modres removeAllObjects];
		RELEASE(relation_residue_modres);
	}
	if (temporaryatoms)
	{
		[temporaryatoms removeAllObjects];
		RELEASE(temporaryatoms);
	}

        [super dealloc];
}


+(MTStructure*)parseStructureFromPDBFile:(NSString*)fn compressed:(BOOL)compr options:(long)p_options
{
	MTStructure *res = [MTStructureFactory newStructure];
	CREATE_AUTORELEASE_POOL(pool);
#ifdef MEMDEBUG
	GSDebugAllocationActive(YES);
	NSLog(@"allocated objects on entering -structureFromPDBFile\n%s",GSDebugAllocationList(NO));
#endif

	MTPDBParser *parser = [[MTPDBParser alloc] initWithOptions:p_options];
	parser->strx = res;
	
	NSString *line;
	MTFileStream *stream;
	if (compr)
	{
		stream = [MTCompressedFileStream streamFromFile: fn];
	} else {
		stream = [MTFileStream streamFromFile: fn];
	}
	if (![stream ok])
	{
		[NSException raise:@"Error" format:@"streaming from file: %@ failed.",fn];
		return nil;
	}

	NSInvocation *invoc=nil;
	NSString *head=nil;
	NSRange range;
	int linelength;
	while ((line = [stream readStringLineLength:81]))
	{
		linelength = [line length];
		range.location=0; range.length=(linelength>=6?6:linelength);
		head = [line substringWithRange: range];
		//printf("head:%@\n",head);
		invoc = [parser->parserSelectors objectForKey: head];
		if (invoc)
		{
			[invoc setArgument: &line atIndex: 2];
			[invoc invokeWithTarget: parser];
		}
		invoc = nil;
		//printf("allocated objects\n%s",GSDebugAllocationList(YES));
	}
	[stream close];

	/* do some C L E A N U P  */
	
	/* some structures are of XRay data (have resolution) but do not have a EXPDTA record */
	if (!(parser->options & PDBPARSER_IGNORE_EXPDTA))
	{
		if (parser->expdata == Structure_Unknown && parser->resolution > 0.1f && parser->resolution < 6.0f)
		{
			//fprintf(stderr,"missing EXPDTA information: was setting X-RAY DIFFRACTION because resolution %1.1f<6.0A.\n",parser->resolution);
			parser->expdata = Structure_XRay;
		}
	}	
	/* traverse parsed information and put it into structure object */
	[parser->strx pdbcode:parser->pdbcode];
	[parser->strx date:parser->date];
	[parser->strx revdate:parser->lastrevdate];
	[parser->strx header:parser->header];
	[parser->strx title:parser->title];
	[parser->strx keywords:parser->keywords];
	[parser->strx resolution:parser->resolution];
	[parser->strx expdata:parser->expdata];
	
	/* traverse parsed information source,compound for molids and put it in the corresponding chain */

	if ([parser->strx models] > 1)
	{
		[parser->strx switchToModel: 1];
	}
	
	NSEnumerator *chains_enum = [parser->relation_chain_molid keyEnumerator];
	id t_chain;
	id t_molid;
	MTChain *curr_chain;
	NSNumber *chainid;

	while ((t_chain = [chains_enum nextObject]))
	{
		chainid = [NSNumber numberWithChar: *[t_chain cString]];
		curr_chain = [parser->strx getChain: chainid];
		if (!curr_chain)
		{
			curr_chain = [parser->strx mkChain:chainid];
		}
		t_molid = [parser->relation_chain_molid objectForKey: t_chain];
		if (curr_chain && t_molid)
		{
			id t_data;
			t_data = [parser->relation_molid_eccode objectForKey: t_molid];
			if (t_data)
			{
				[curr_chain setECCode:t_data];
			}
			t_data = [parser->relation_molid_compound objectForKey: t_molid];
			if (t_data)
			{
				[curr_chain setCompound:t_data];
			}
			t_data = [parser->relation_molid_source objectForKey: t_molid];
			if (t_data)
			{
				[curr_chain setSource:t_data];
			}
		}
		
	} // while

	/* put MODRES information directly into residues */
	NSEnumerator *e_modres = [parser->relation_residue_modres objectEnumerator];
	NSArray *modresarr;
	while ((modresarr = [e_modres nextObject]))
	{
		MTResidue *t_res;
		MTChain *t_chain = [modresarr objectAtIndex:0];
		NSString *t_rname = [modresarr objectAtIndex:1];
		NSString *modname = [modresarr objectAtIndex:2];
		NSString *moddesc = [modresarr objectAtIndex:3];
		t_res = [t_chain getResidue:t_rname];
		if (t_res)
		{
			[t_res setModName: modname];
			[t_res setModDesc: moddesc];
		}
	}
	
	/* put SEQRES information directly into chain */
	e_modres = [parser->relation_chain_seqres keyEnumerator];
	while ((chainid = [e_modres nextObject]))
	{
		curr_chain = [parser->strx getChain: chainid];
		if (!curr_chain)
		{
			curr_chain = [parser->strx mkChain:chainid];
		}
		NSString *seqres = [parser->relation_chain_seqres objectForKey:chainid];
		if (seqres)
		{
			[curr_chain setSeqres: seqres];
		}
	}
	
	/* verify connectivity of all residues in chain */
	if (!(p_options & PDBPARSER_DONT_VERIFYCONNECTIVITY))
	{
		int i;
		for (i=[parser->strx models]; i>0; i--)
		{
			[parser->strx switchToModel: i];
			chains_enum = [parser->strx allChains];
			NSEnumerator *res_enum;
			MTResidue *t_res;
			while ((t_chain = [chains_enum nextObject]))
			{
				res_enum = [t_chain allResidues];
				while ((t_res = [res_enum nextObject]))
				{
					[t_res verifyAtomConnectivity];
				}
			} // while
		} // for i
	}	

	AUTORELEASE(parser);
#ifdef MEMDEBUG
	NSLog(@"change of allocated objects since last list\n%s",GSDebugAllocationList(YES));
#endif
	RELEASE(pool);
#ifdef MEMDEBUG
	NSLog(@"change of allocated objects since last list\n%s",GSDebugAllocationList(YES));
	NSLog(@"allocated objects\n%s",GSDebugAllocationList(NO));
	GSDebugAllocationActive(NO);
#endif

	return res;
}


@end


@implementation MTPDBParser (Private)

-(void)addBondFrom:(unsigned int)p_atm1 to:(unsigned int)p_atm2
{
	if ((p_atm1 == 0) || (p_atm2 == 0))
	{
		return;
	}
	if (temporaryatoms == nil)
	{
		return;
	}
	MTAtom *atom1=[temporaryatoms objectForKey: [NSNumber numberWithInt:p_atm1]];
	MTAtom *atom2=[temporaryatoms objectForKey: [NSNumber numberWithInt:p_atm2]];
	if (atom1 && atom2)
	{ /* add bond */
		[atom1 bondTo: atom2];
		[atom2 bondTo: atom1];
	}
}


-(oneway void)readAtom:(in NSString*)line
{
	unsigned int i;
	char buffer[81];
	unsigned int serial,resnr;
	char aname[5]; /* atom name */
	char rname[4]; /* residue name */
	double x,y,z,occ,bfact;
	char icode;
	char chain;
	char element[3]; /* element name */
	char segid[4]; /* segment id */
	int chrg=0;


	if (haveModel1)
	{
		return;
	}
	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	/* serial number */
	serial = mkInt(buffer+6,5); /* 7 - 11 atom serial number */
	/* atom name */
	for (i=0; i<4; i++) { aname[i]=buffer[i+12]; } /* 13 - 16 atom name */
	aname[4]='\0';
	for (i=3; i>0; i--) { if (aname[i]==' ') aname[i]='\0'; } /* remove trailing whitespace */
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=buffer[i+17]; } /* 18 - 20 residue name */
	rname[3]='\0';
	/* chain identifier */
	chain = buffer[21]; /* 22 chain identifier */
	/* residue sequence nr */
	icode=buffer[26]; /* 27 insertion code (\==32) */
	resnr = mkInt(buffer+22,4); /* 23 - 26 residue sequence number */
	/* x */
	x = mkFloat(buffer+30,8); /* 31 - 38 x coordinate */
	/* y */
	y = mkFloat(buffer+38,8); /* 39 - 46 y coordinate */
	/* z */
	z = mkFloat(buffer+46,8); /* 47 - 54 z coordinate */
	/* occupancy */
	//occ = mkFloat(buffer+54,6); /* 55 - 60 occupancy */
	/* b factor */
	bfact = mkFloat(buffer+60,6); /* 61 - 66 temperature factor */
	if (newfileformat)
	{
		/* segment id */
		for (i=0; i<4; i++) { segid[i]=buffer[i+72]; } /* 73 - 76 segment id */
		/* element name */
		for (i=0; i<2; i++) { element[i]=buffer[i+76]; } /* 77 - 78 element name */
		element[2]='\0';
		/* charge */
		if (buffer[78] != 32)
		{   /* 79 - 80 charge */
			chrg = buffer[78]-48;
			if (buffer[79] == '-')
			{
				chrg = 0 - chrg;
			}
		}
	}
	
	id t_chain = [strx getChainForChar:chain];
	if (t_chain == nil)
	{
		t_chain = [strx mkChain: [NSNumber numberWithChar:chain]];
		lastcarboxyl = nil;
		last3prime = nil;
	}

// stage 1: 420 ms, VmRSS:     14860 k
	if (options & PDBPARSER_IGNORE_SIDECHAINS)
	{
		if (!(aname[0]==' ' && aname[1]=='C' && aname[2]=='A' && aname[3]=='\0'))
		{
			return; // ignore it all (even nucleic acids!)
		}
	}

	/* create atom - will also derive element name */
	MTAtom *t_atom = [MTAtomFactory newAtomWithNumber:serial name:aname X:x Y:y Z:z B:bfact];
	if (options & PDBPARSER_IGNORE_HYDROGENS)
	{
		/* ignore if hydrogen */
		if ([t_atom element] == ELEMENT_ID_H)
			return;
		/* ignore if it shall be a hydrogen */
		if (element[0]==32 && element[1]=='H')
			return;
	}

//stage 2: 600 ms, VmRSS:     20060 kB
	/* insert */
	NSString *resid = [MTResidue computeKeyFromInt:resnr subcode:icode];
	id t_residue = [t_chain getResidue:resid];
	if (t_residue == nil)
	{
		t_residue = [MTResidueFactory newResidueWithNumber:resnr subcode:icode name:rname];
		[t_chain addResidue: t_residue];
		/* set last alternate site from this very first atom of the residue */
		lastalternatesite = buffer[16];
		if (segid[0] != ' ' || segid[1] != ' ' || segid[2] != ' ' || segid[3] != ' ')  // left justified
		{
			//printf("      segment id: %c%c%c%c\n",segid[0],segid[1],segid[2],segid[3]);
			[t_residue setSegid: [NSString stringWithFormat:@"%c%c%c%c", segid[0],segid[1],segid[2],segid[3] ]];
		}
	} else {
		/* Skip entire atom if alternate location already known. Thus only read first one. */
                if (buffer[16] != ' ')
                {
                        if (lastalternatesite == ' ')
                        {
                                lastalternatesite = buffer[16];
                        }
                        if (!(options & PDBPARSER_ALL_ALTERNATE_ATOMS))
                        {
                                if (buffer[16] != lastalternatesite)
                                {
                                        return;
                                }
                        }
                }
	}

// stage 3: 730 ms, VmRSS:     21440 kB
	if (newfileformat)
	{
		if (chrg != 0)
		{
			[t_atom setCharge: chrg];
		}
		if (element[1]!=32)  // right justified
		{
			if (element[0]==32)
			{
				/* skip space */
				[t_atom setElementWithName: &(element[1])];
			} else {
				[t_atom setElementWithName: element];
			}
		}
	}

	[t_residue addAtom: t_atom];
	/* check if this is the amino end of the amino acid */
	if (lastcarboxyl && aname[0]==' ' && aname[1]=='N' && aname[2]=='\0')
	{
		[t_atom bondTo: lastcarboxyl];
	}
	/* check if this is the phosphate atom */
	if (last3prime && aname[0]==' ' && aname[1]=='P' && aname[2]=='\0')
	{
		if ([t_residue isNucleicAcid])
		{
			[t_atom bondTo: last3prime];
		}
	}
	
	/* check if this is the carboxyl end of the amino acid */
	if (aname[0]==' ' && aname[1]=='C' && aname[2]=='\0')
	{
		lastcarboxyl = t_atom;
	}
	if (aname[0]==' ' && aname[1]=='O' && aname[2]=='3' && aname[3]=='*')
	{
		last3prime = t_atom;
	}

// stage 4: 800 ms, VmRSS:     22184 kB
}


-(oneway void)readHetatom:(in NSString*)line
{
	unsigned int i;
	char buffer[81];
	unsigned int serial,resnr;
	char aname[5]; /* atom name */
	char rname[4]; /* residue name */
	double x,y,z,occ,bfact;
	char icode;
	char chain;
	char element[3]; /* element name */
	char segid[4]; /* segment id */
	int chrg=0;
	id t_residue=nil;
	BOOL isSolvent=NO;

	if (haveModel1)
	{
		return;
	}
	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	/* serial number */
	serial = mkInt(buffer+6,5); /* 7 - 11 atom serial number */
	/* atom name */
	for (i=0; i<4; i++) { aname[i]=buffer[i+12]; } /* 13 - 16 atom name */
	aname[4]='\0';
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=buffer[i+17]; } /* 18 - 20 residue name */
	rname[3]='\0';
	if ((rname[0]=='H' && rname[1]=='O' && rname[2]=='H')
	 || (rname[0]=='S' && rname[1]=='O' && rname[2]=='L')
	 || (rname[0]=='D' && rname[1]=='I' && rname[2]=='S'))
	{
		isSolvent = YES;
	}
	if (isSolvent && (options & PDBPARSER_IGNORE_SOLVENT))
	{
		return;  // ignore it completely
	}
	/* chain identifier */
	chain = buffer[21]; /* 22 chain identifier */
	/* residue sequence nr */
	icode=buffer[26]; /* 27 insertion code (\==32) */
	resnr = mkInt(buffer+22,4); /* 23 - 26 residue sequence number */
	NSString *resid = [MTResidue computeKeyFromInt:resnr subcode:icode];	
	/* check for modified residue */
	if (!isSolvent && ([relation_residue_modres objectForKey:[NSString stringWithFormat:@"%c%@",chain,resid]]))
	{
		[self readAtom:line];
                return;
	}
	
	/* x */
	x = mkFloat(buffer+30,8); /* 31 - 38 x coordinate */
	/* y */
	y = mkFloat(buffer+38,8); /* 39 - 46 y coordinate */
	/* z */
	z = mkFloat(buffer+46,8); /* 47 - 54 z coordinate */
	/* occupancy */
	//occ = mkFloat(buffer+54,6); /* 55 - 60 occupancy */
	/* b factor */
	bfact = mkFloat(buffer+60,6); /* 61 - 66 temperature factor */
	if (newfileformat)
	{
		/* segment id */
		for (i=0; i<4; i++) { segid[i]=buffer[i+72]; } /* 73 - 76 segment id */
		/* element name */
		for (i=0; i<2; i++) { element[i]=buffer[i+76]; } /* 77 - 78 element name */
		element[2]='\0';
		/* charge */
		if (buffer[78] != 32)
		{   /* 79 - 80 charge */
			chrg = buffer[78]-48;
			if (buffer[79] == '-')
			{
				chrg = 0 - chrg;
			}
		}
	}
	
	id t_chain = [strx getChainForChar:chain];
	if (t_chain == nil)
	{
		t_chain = [strx mkChain: [NSNumber numberWithChar:chain]];
		lastcarboxyl = nil;
		last3prime = nil;
	}
	/* insert */
	if (isSolvent)
	{
	 	t_residue = [t_chain getSolvent: resid];
	} else {
		t_residue = [t_chain getHeterogen: resid];
	}
	if (t_residue == nil)
	{
		t_residue = [MTResidueFactory newResidueWithNumber:resnr subcode:icode name:rname];
		if (isSolvent)
		{
			[t_chain addSolvent: t_residue];
		} else {
			[t_chain addHeterogen: t_residue];
		}
		/* set last alternate site from this very first atom of the residue */
		lastalternatesite=buffer[16];
		if (segid[0] != ' ' || segid[1] != ' ' || segid[2] != ' ' || segid[3] != ' ')  // left justified
		{
			//printf("      segment id: %c%c%c%c\n",segid[0],segid[1],segid[2],segid[3]);
			[t_residue setSegid: [NSString stringWithFormat:@"%c%c%c%c", segid[0],segid[1],segid[2],segid[3] ]];
		}
	} else {
		/* Skip entire atom if alternate location already known. Thus only read first one. */
		if (!(options & PDBPARSER_ALL_ALTERNATE_ATOMS))
		{
			if (buffer[16]!=lastalternatesite)
			{
				return;
			}
		}
	}
	id t_atom = [MTAtomFactory newAtomWithNumber:serial name:aname X:x Y:y Z:z B:bfact];
	if (newfileformat)
	{
		if (chrg != 0)
		{
			[t_atom setCharge: chrg];
		}
		if (element[1]!=32)  // right justified
		{
			if (element[0]==32)
			{
				/* skip space */
				[t_atom setElementWithName: &(element[1])];
			} else {
				[t_atom setElementWithName: element];
			}
		}
	}

	[t_residue addAtom: t_atom];
}


-(oneway void)readConnect:(in NSString*)line
{
        const char *t_str;
	char buffer[38];
	unsigned int atm1,atm2;
        t_str = [line lossyCString];
	//[line getCString: buffer maxLength: 37];
	if (temporaryatoms == nil)
	{
		// have to prepare dictionary of atom with keys = serial number
		temporaryatoms = [NSMutableDictionary new];
		int m = [strx models];
		int i;
		for (i=1; i<=m; i++)
		{
			[strx switchToModel: i];
			NSEnumerator *cenum = [strx allChains];
			MTChain *ch;
			while ((ch = [cenum nextObject]))
			{
				NSEnumerator *renum = [ch allHeterogens];   //          <<-- only heterogens
				MTResidue *res;
				while ((res = [renum nextObject]))
				{
					NSEnumerator *aenum = [res allAtoms];
					MTAtom *atm;
					while ((atm = [aenum nextObject]))
					{
						[temporaryatoms setObject:atm forKey:[atm number]];
					}
				}
			}
		}
	}
	strncpy(buffer,t_str,38);
	atm1 = mkInt(buffer+6,5);
	atm2 = mkInt(buffer+11,5);
	[self addBondFrom: atm1 to: atm2];
	atm2 = mkInt(buffer+16,5);
	[self addBondFrom: atm1 to: atm2];
	atm2 = mkInt(buffer+21,5);
	[self addBondFrom: atm1 to: atm2];
	atm2 = mkInt(buffer+26,5);
	[self addBondFrom: atm1 to: atm2];
}


-(oneway void)readHeader:(in NSString*)line
{
	NSRange range;
	int llength = [line length];
	int lmin;
	/* get classification */
	if (llength>10)
	{
		range.location = 10;
		lmin = llength-10;
		range.length = lmin<40?lmin:40;
		header = [[line substringWithRange: range] clipright];
	} else {
		header = @"HEADER MISSING";
	}
	
	/* get pdb code */
	if (llength>65)
	{
		range.location = 62; range.length = 4;
		pdbcode = [line substringWithRange: range];
	} else {
		pdbcode = @"0UNK";
	}
	
	/* get deposition date */
	if (llength>58)
	{
		range.location = 50; range.length = 9;
		char *dstring = (char*)[[line substringWithRange: range] cString]; /* format: DD-MMM-YY */
		date = mkISOdate (dstring);
	}
}


-(oneway void)readTitle:(in NSString*)line
{
	/* get TITLE */
	NSRange range;
	int lmin=[line length]-10;
	range.location=10;
	range.length=lmin<60?lmin:60;
	NSString *t_title = [[line substringWithRange: range] clipright];
	if (title)
	{
		title = [title stringByAppendingString: t_title];
	} else {
		title = t_title;
	}
}


-(oneway void)readCompound:(in NSString*)line
{
	if (!molid)
	{
		molid = [NSNumber numberWithInt: 1];
		[relation_chain_molid setObject: molid forKey: @" "];
	}
	NSRange range;
	/* search for E.C. code */
	range = [line rangeOfString: @"E.C."];
	if (range.length > 0)
	{
		NSScanner *scanner = [NSScanner scannerWithString: line];
		[scanner setScanLocation: range.location+range.length];
		NSString *t_eccode;
		int t_vals[] = {-1,-1,-1,-1};
		int t_val_cnt=0;
		[scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ. "]];
		while (t_val_cnt<4 && [scanner scanInt: &(t_vals[t_val_cnt])])
		{
			//printf("found: %d\n",t_vals[t_val_cnt]);
			t_val_cnt++;
		}
		t_eccode = [NSString stringWithFormat: @"%d.%d.%d.%d",t_vals[0],t_vals[1],t_vals[2],t_vals[3]];
		//printf("found EC: %@\n",t_eccode);
		[relation_molid_eccode setObject: t_eccode forKey: molid];
		return;
	} /* E.C. */

	/* search for molid */
	range = [line rangeOfString: @"MOL_ID:"];
	if (range.length > 0)
	{
		NSScanner *scanner = [NSScanner scannerWithString: line];
		CmpndOldStyle = NO;
		int t_molid;
		[scanner setScanLocation: range.location+range.length];
		[scanner scanInt: &t_molid];
		//printf("now have molid=%d\n",t_molid);
		molid = [NSNumber numberWithInt: t_molid];
		return;
	} /* MOLID */
	
	/* search for MOLECULE */
	range = [line rangeOfString: @"MOLECULE:"];
	if (range.length > 0)
	{
		CmpndOldStyle = NO;
		int lmin=[line length]-20;
		range.location = 20;
		range.length = lmin<50?lmin:50;
		NSString *t_molecule = [[line substringWithRange: range] clip];
		if ([t_molecule hasSuffix: @";"])
		{
			t_molecule = [t_molecule substringToIndex: [t_molecule length]-1];
		}
		NSString *old_molecule = [relation_molid_compound objectForKey: molid];
		if (old_molecule)
		{
			[relation_molid_compound setObject: [old_molecule stringByAppendingString: t_molecule] forKey: molid];
		} else {
			[relation_molid_compound setObject: t_molecule forKey: molid];
		}
		return;
	}
			
	/* search for E.C. code */
	range = [line rangeOfString: @"EC:"];
	if (range.length > 0)
	{
		NSScanner *scanner = [NSScanner scannerWithString: line];
		[scanner setScanLocation: range.location+range.length];
		NSString *t_eccode;
		int t_vals[] = {-1,-1,-1,-1};
		int t_val_cnt=0;
		[scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ:. "]];
		while (t_val_cnt<4 && [scanner scanInt: &(t_vals[t_val_cnt])])
		{
			//printf("found: %d\n",t_vals[t_val_cnt]);
			t_val_cnt++;
		}
		t_eccode = [NSString stringWithFormat: @"%d.%d.%d.%d",t_vals[0],t_vals[1],t_vals[2],t_vals[3]];
		[relation_molid_eccode setObject: t_eccode forKey: molid];
		//printf("found EC: %@\n",t_eccode);
		return;
	}

	range = [line rangeOfString: @"CHAIN:"];
	/* search for CHAIN */
	if (range.length > 0)
	{
		NSScanner *scanner = [NSScanner scannerWithString: line];
		CmpndOldStyle = NO;
		[scanner setScanLocation: range.location+range.length];
		NSString *t_chain;
		[scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString:@":;., "]];
		while ([scanner scanCharactersFromSet: [NSCharacterSet uppercaseLetterCharacterSet] intoString: &t_chain])
		{
			//printf("found chain: %@\n",t_chain);
			if ([t_chain isEqualToString: @"NULL"])
			{
				t_chain = @" ";
			}
			[relation_chain_molid setObject: molid forKey: t_chain];
		}
		return;
	}

	/* old files just have a continuation of COMPND lines */
	int lmin=[line length]-10;
	range.location = 10;
	range.length = lmin<60?lmin:60;
	NSString *t_cmpnd = [[line substringWithRange:range] clipright];
	NSString *old_molecule = [relation_molid_compound objectForKey: molid];
	if (old_molecule)
	{
		[relation_molid_compound setObject: [old_molecule stringByAppendingString:t_cmpnd] forKey: molid];
	} else {
		[relation_molid_compound setObject:t_cmpnd forKey: molid];
	}
	//printf("have COMPND: %@\n",[line substringWithRange:range]);
}


-(oneway void)readSource:(in NSString*)line
{
	if (!molid)
	{
		molid = [NSNumber numberWithInt: 1];
		[relation_chain_molid setObject: molid forKey: @" "];
	}
	NSRange range;
	/* get source organism (SOURCE) */
	range = [line rangeOfString: @"MOL_ID:"];
	if (range.length > 0)
	{
		int t_molid;
		NSScanner *scanner = [NSScanner scannerWithString: line];
		SrcOldStyle = NO;
		[scanner setScanLocation: range.location+range.length];
		[scanner scanInt: &t_molid];
		//printf("now have molid=%d\n",t_molid);
		molid = [NSNumber numberWithInt: t_molid];
		return;
	}
	
	/* search for ORGANISM_SCIENTIFIC */
	range = [line rangeOfString: @"ORGANISM_SCIENTIFIC:"];
	if (range.length > 0)
	{
		NSString *t_src=nil;
		SrcOldStyle = NO;
		range.location += range.length+1;
		int lmin=[line length]-range.location;
		range.length = lmin<40?lmin:40;
		NSString *tt_src = [[line substringWithRange: range] clipright];
		NSScanner *scanner = [NSScanner scannerWithString: tt_src];
		[scanner scanUpToString: @";" intoString: &t_src];
		//printf("in '%@' found SOURCE: '%@'\n", tt_src,t_src);
		if (t_src)
		{
			[relation_molid_source setObject: t_src forKey: molid];
		}
		return;
	}

	if (SrcOldStyle)
	{
		/* old style without any heading */
		int lmin=[line length]-10;
		range.location = 10;
		range.length = lmin<60?lmin:60;
		NSString *t_src = [[line substringWithRange: range] clipright];
		//printf("found SOURCE: %@\n", t_src);
		NSString *prev_src = [relation_molid_source objectForKey: molid];
		if (prev_src)
		{
			t_src = [prev_src stringByAppendingString: t_src];
		}
		//printf("found SOURCE: %@\n", t_src);
		[relation_molid_source setObject: t_src forKey: molid];
	}
}


-(oneway void)readKeywords:(in NSString*)line
{
	/* get KEYWDS */
	NSRange range;
	int lmin=[line length]-10;
	range.location=10;
	range.length=lmin<60?lmin:60;
	NSString *t_kw = [[line substringWithRange: range] clipright];
	if (keywords)
	{
		keywords = [keywords stringByAppendingString: t_kw];
	} else {
		keywords = t_kw;
	}
}


-(oneway void)readSeqres:(in NSString*)line
{
	int idx,tgt;
	int llen;
	char seqbuf[80];
	tgt = 0;
	char *linestr = (char*)[line cString];
	//printf("line='%s'\n",linestr);
	llen = [line length];
	if (llen < 12)
	{
		return; // abort
	}
	memset(seqbuf,0,80);
	/* get chain identifier */
	NSNumber *ch_id = [NSNumber numberWithChar: (linestr[11])];
	for (idx=19; idx<(llen-3); idx+=4)
	{
		//printf("char at %d = %c\n",idx, linestr[idx]);
		switch (linestr[idx])
		{
		case 'A': // ALA ARG ASP ASN
			if (linestr[idx+1] == 'L' && linestr[idx+2] == 'A')
			{
				seqbuf[tgt++]='A';
			} else if (linestr[idx+1] == 'R' && linestr[idx+2] == 'G')
			{
				seqbuf[tgt++]='R';
			} else if (linestr[idx+1] == 'S' && linestr[idx+2] == 'P')
			{
				seqbuf[tgt++]='D';
			} else if (linestr[idx+1] == 'S' && linestr[idx+2] == 'N')
			{
				seqbuf[tgt++]='N';
			}
			break;
		case 'C': // CYS
			if (linestr[idx+1] == 'Y' && linestr[idx+2] == 'S')
			{
				seqbuf[tgt++]='C';
			}
			break;
		case 'G': // GLY GLN GLU
			if (linestr[idx+1] == 'L' && linestr[idx+2] == 'Y')
			{
				seqbuf[tgt++]='G';
			} else if (linestr[idx+1] == 'L' && linestr[idx+2] == 'N')
			{
				seqbuf[tgt++]='Q';
			} else if (linestr[idx+1] == 'L' && linestr[idx+2] == 'U')
			{
				seqbuf[tgt++]='E';
			}
			break;
		case 'H': // HIS
			if (linestr[idx+1] == 'I' && linestr[idx+2] == 'S')
			{
				seqbuf[tgt++]='H';
			}
			break;
		case 'I': // ILE
			if (linestr[idx+1] == 'L' && linestr[idx+2] == 'E')
			{
				seqbuf[tgt++]='I';
			}
			break;
		case 'L': // LEU LYS
			if (linestr[idx+1] == 'E' && linestr[idx+2] == 'U')
			{
				seqbuf[tgt++]='L';
			} else if (linestr[idx+1] == 'Y' && linestr[idx+2] == 'S')
			{
				seqbuf[tgt++]='K';
			}
			break;
		case 'M': // MET
			if (linestr[idx+1] == 'E' && linestr[idx+2] == 'T')
			{
				seqbuf[tgt++]='M';
			}
			break;
		case 'P': // PHE PRO
			if (linestr[idx+1] == 'H' && linestr[idx+2] == 'E')
			{
				seqbuf[tgt++]='F';
			} else if (linestr[idx+1] == 'R' && linestr[idx+2] == 'O')
			{
				seqbuf[tgt++]='P';
			}
			break;
		case 'S': // SER
			if (linestr[idx+1] == 'E' && linestr[idx+2] == 'R')
			{
				seqbuf[tgt++]='S';
			}
			break;
		case 'T': // THR TRP TYR
			if (linestr[idx+1] == 'H' && linestr[idx+2] == 'R')
			{
				seqbuf[tgt++]='T';
			} else if (linestr[idx+1] == 'R' && linestr[idx+2] == 'P')
			{
				seqbuf[tgt++]='W';
			} else if (linestr[idx+1] == 'Y' && linestr[idx+2] == 'R')
			{
				seqbuf[tgt++]='Y';
			}
			break;
		case 'V': // VAL
			if (linestr[idx+1] == 'A' && linestr[idx+2] == 'L')
			{
				seqbuf[tgt++]='V';
			}
			break;
		case 'U': // UNK
			if (linestr[idx+1] == 'N' && linestr[idx+2] == 'K')
			{
				seqbuf[tgt++]='X';
			}
			break;
		default:  // all others
			break; // ignored
		} // switch
	}

	NSString *t_seqres;
	NSString *prev_seqres = [relation_chain_seqres objectForKey: ch_id];
	if (prev_seqres)
	{
		t_seqres = [prev_seqres stringByAppendingFormat:@"%s", seqbuf];
	} else {
		t_seqres = [NSString stringWithCString: seqbuf];
	}
	[relation_chain_seqres setObject: t_seqres forKey: ch_id];
}


-(oneway void)readExpdata:(in NSString*)line
{
	/* get experiment type (EXPDTA) */
	NSRange range;
	range = [line rangeOfString: @"X-RAY DIFFRACTION"];
	if (range.length > 0)
	{
		expdata = Structure_XRay;
		return;
	}
	range = [line rangeOfString: @"NMR"];
	if (range.length > 0)
	{
		expdata = Structure_NMR;
		return;
	}
	range = [line rangeOfString: @"THEORETICAL MODEL"];
	if (range.length > 0)
	{
		expdata = Structure_TheoreticalModel;
	} else  {
		//NSLog(@"unknown EXPDTA type: %@",line);
		expdata = Structure_Other;
	}
}


-(oneway void)readRemark:(in NSString*)line
{
	NSRange range;
	char *cstring = (char*)[line cString];
	/* get resolution (REMARK 2) */
	if (cstring[8]==' ' && cstring[9]=='2' && cstring[10]==' ')
	{
		cstring[30] = '\0';
		resolution = (float)atof(cstring + 22);
		return;
	}

	/* get REMARK 4: new format indicator */
	if (cstring[8]==' ' && cstring[9]=='4' && cstring[10]==' ')
	{
		// "COMPLIES WITH FORMAT " 17-
		range.location=16;
		range.length=21;
		NSString *complies = [line substringWithRange: range];
		if ([complies isEqualToString:@"COMPLIES WITH FORMAT "])
		{
			newfileformat = YES;
		}
		return;
	}
	
	if (! (options & PDBPARSER_ALL_REMARKS))
	{
		/* skip over all other remarks unless requested */
		return; 
	}

	/* all other remarks are parsed and stored */
	
	range.location=0;
	range.length=10;
	NSString *key = [line substringWithRange: range];
	if ([line length] > 12)
	{
		NSString *remstr = [strx getDescriptorForKey: key];
		range.location=11;
		range.length=[line length] - 12;
		if (range.length > 59) range.length = 59;  // limit length
		NSString *remark = @"";
		if (range.length > 0)
		{
			remark = [line substringWithRange: range];
		}
		if (range.length < 59)
		{
			remark = [remark stringByAppendingString: @"                                                            "];
		}
		range.location=0;
		range.length=59;
		remark = [remark substringWithRange: range];
		if (remstr)
		{
			remstr = [remstr stringByAppendingString: remark];
		} else {
			remstr = remark;
		}
		remstr = [remstr stringByAppendingString: @"\n"];
		[strx setDescriptor: remstr withKey: key];
	}
}


-(oneway void)readModel:(in NSString*)line
{
	char *cline = (char*)[line cString];
	cline[14] = '\0';
	//printf("Model line: '%s'\n",cline+10);
	int t_mnr = atol(cline+10);
	if (t_mnr > 0 && t_mnr < 16384)
	{
		modelnr = t_mnr;
	}
	if (options & PDBPARSER_ALL_NMRMODELS)
	{
		if (modelnr > 1)
		{
			[strx addModel]; // will store structure in new model
		}
	}
}


-(oneway void)readHetname:(in NSString*)line
{
	NSRange range;
	range.location=11;
	range.length=3;
	NSString *resname = [line substringWithRange: range];
	range.location=15;
	range.length=[line length] - 16;
	NSString *hetname = [[line substringWithRange: range] clipright];
	//printf("HETNAM: %@ = %@\n",resname,hetname);
	NSString *oldname = [strx hetnameForKey:resname];
	if (oldname != nil)
	{
		[strx hetname:[oldname stringByAppendingString:hetname] forKey:resname]; // store it
	} else {
		[strx hetname:hetname forKey:resname]; // store it
	}
}


-(oneway void)readModres:(in NSString*)line
{
	char buffer[81];
	int resnr;
	NSString *hname; /* hetero name */
	NSString *rname; /* standard residue name */
	NSString *desc; /* description of modification */
	NSString *resid; /* key of residue */
	char icode;
	NSNumber *chain;
	NSRange range;

	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	/* hetero name */
	range.location=12; /* 13 - 15 hetero name */
	range.length=3;
	hname = [line substringWithRange: range];
	/* chain identifier */
	chain = [NSNumber numberWithChar:buffer[16]]; /* 17 chain identifier */
	/* standard residue name */
	range.location=24; /* 25 - 27 residue name */
	range.length=3;
	rname = [line substringWithRange: range];
	/* residue sequence number */
	resnr = mkInt(buffer+18,4); /* 19 - 22 residue sequence number */
	icode=buffer[22]; /* 23 insertion code (\==32) */
	resid = [MTResidue computeKeyFromInt:resnr subcode:icode];
	/* description */
	range.location=29; /* description of modification */
	range.length=41;
	desc = [[line substringWithRange: range] clipright];

	id t_chain = [strx getChain:chain];
	if (t_chain == nil)
	{
		t_chain = [strx mkChain:chain];
	}
	NSArray *modresarr = [NSArray arrayWithObjects:t_chain,resid,rname,desc,nil];
	//printf("MODRES: %s = %s\n",[[resid description] cString],[[modresarr description] cString]);
	[relation_residue_modres setObject:modresarr forKey:[NSString stringWithFormat:@"%c%@",buffer[16],resid]];
}


-(oneway void)readEndModel:(in NSString*)line
{
	if (!(options & PDBPARSER_ALL_NMRMODELS) && (modelnr == 1))
	{
		haveModel1 = YES;
		/* stop reading ATOM and HETATM records (in other models) */
		[parserSelectors removeObjectForKey: @"ATOM  "];
		[parserSelectors removeObjectForKey: @"HETATM"];
	}
}


-(oneway void)readRevDat:(in NSString*)line
{
	char *linstr = (char*)[line cString];
	if (linstr[11]!=' ' || linstr[12]!=' ')
	{
		/* nothing to do, this is just a continuation */
		return;
	}

	linstr[10]='\0';
	linstr[22]='\0';
	int t_revdatnr = atoi(linstr+7);
	if (t_revdatnr >= lastrevnr)
	{
		lastrevdate = mkISOdate (linstr+13);
		lastrevnr = t_revdatnr;
	}
}


-(oneway void)readChainTerminator:(in NSString*)line
{
}


-(oneway void)readCryst:(in NSString*)line
{
	MTVector *unitvector = [MTVector vectorWithDimensions: 3];
	MTVector *unitangles = [MTVector vectorWithDimensions: 3];
	double t_val;
	char buffer[81];
	int t_ival;
	NSString *spcgrp; /* space group */
	NSRange range;

	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	/* crystallographic unit cell vectors */
	t_val = mkFloat(buffer+6,9);  /*  7 - 15  unit cell: a */
	[unitvector atDim: 0 value: t_val];
	t_val = mkFloat(buffer+15,9); /* 16 - 24  unit cell: b */
	[unitvector atDim: 1 value: t_val];
	t_val = mkFloat(buffer+24,9); /* 25 - 33  unit cell: c */
	[unitvector atDim: 2 value: t_val];
	[strx setDescriptor: unitvector withKey: @"UNITVECTOR"];

	/* crystallographic unit cell angles */
	t_val = mkFloat(buffer+33,7); /* 34 - 40  unit cell: alpha */
	[unitangles atDim: 0 value: t_val];
	t_val = mkFloat(buffer+40,7); /* 41 - 47  unit cell: beta */
	[unitangles atDim: 1 value: t_val];
	t_val = mkFloat(buffer+47,7); /* 48 - 54  unit cell: gamma */
	[unitangles atDim: 2 value: t_val];
	[strx setDescriptor: unitangles withKey: @"UNITANGLES"];

	/* space group */
	range.location=55; /* 56 - 66  space group*/
	range.length=11;
	spcgrp = [[line substringWithRange: range] clipright];
	[strx setDescriptor: spcgrp withKey: @"SPACEGROUP"];

	/* Z value */
	t_ival = mkInt(buffer+66,4); /* 67 - 70  Z value */
	[strx setDescriptor: [NSNumber numberWithInt: t_ival] withKey: @"ZVALUE"];
}


-(oneway void)readSite:(in NSString*)line
{
	NSMutableString *rsel = [NSMutableString string];
	//int serial;
	//int counter;
	char buffer[81];
	NSString *key;

	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	//serial = mkInt(buffer+7,3); /* serial number 8 - 10 */
	/* site name */
	NSRange range;
	range.location = 11; range.length = 3;
	NSString *sname = [line substringWithRange: range];
	key = [NSString stringWithFormat:@"SITE %@",sname];
	NSString *rselstr = [strx getDescriptorForKey: key];
	if (rselstr)
	{
		[rsel appendString: rselstr];
	}
	//counter = mkInt(buffer+15,2); /* residue count 16 - 17 */
	//printf("reading site '%s' for %d residues\n",[sname cString],counter);
	/* entries */
	char ch1,ch2,ch3,ch4;
	int res1,res2,res3,res4;
	char sc1,sc2,sc3,sc4;
	ch1 = buffer[22];
	ch2 = buffer[33];
	ch3 = buffer[44];
	ch4 = buffer[55];
	res1 = mkInt(buffer+23,4);
	res2 = mkInt(buffer+34,4);
	res3 = mkInt(buffer+45,4);
	res4 = mkInt(buffer+56,4);
	sc1 = buffer[27];
	sc2 = buffer[38];
	sc3 = buffer[49];
	sc4 = buffer[60];
	/* residue 1 */
	if (buffer[18]!=' ')
	{
		if (sc1!=' ')
		{
			key = [NSString stringWithFormat: @"%d(%d%c)",ch1,res1,sc1];
		} else {
			key = [NSString stringWithFormat: @"%d(%d)",ch1,res1];
		}
		[rsel appendString: key];
	}
	/* residue 2 */
	if (buffer[29]!=' ')
	{
		if (sc2!=' ')
		{
			key = [NSString stringWithFormat: @"%d(%d%c)",ch2,res2,sc2];
		} else {
			key = [NSString stringWithFormat: @"%d(%d)",ch2,res2];
		}
		[rsel appendString: key];
	}
	/* residue 3 */
	if (buffer[40]!=' ')
	{
		if (sc3!=' ')
		{
			key = [NSString stringWithFormat: @"%d(%d%c)",ch3,res3,sc3];
		} else {
			key = [NSString stringWithFormat: @"%d(%d)",ch3,res3];
		}
		[rsel appendString: key];
	}
	/* residue 4 */
	if (buffer[61]!=' ')
	{
		if (sc4!=' ')
		{
			key = [NSString stringWithFormat: @"%d(%d%c)",ch4,res4,sc4];
		} else {
			key = [NSString stringWithFormat: @"%d(%d)",ch4,res4];
		}
		[rsel appendString: key];
	}
	key = [NSString stringWithFormat:@"SITE %@",sname];
	[strx setDescriptor: rsel withKey: key];
}


-(oneway void)readScale:(in NSString*)line
{
	MTMatrix44 *scalemat;
	double t_val;
	int col;
	char buffer[81];

	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	col = buffer[5] - '1';
	if (col == 0)
	{
		scalemat = [MTMatrix44 matrixIdentity];
		[strx setDescriptor: scalemat withKey: @"SCALEMATRIX"];
	} else {
		scalemat = [strx getDescriptorForKey: @"SCALEMATRIX"];
		if (!scalemat)
		{
			buffer[6]='\0';
			[NSException raise:@"Error" format:@"SCALE matrix not defined in line: %s",buffer];
		}
	}
	/* scale matrix columns */
	t_val = mkFloat(buffer+10,10); /* 11 - 20  Sn1 */
	[scalemat atRow: 0 col: col value: t_val];
	t_val = mkFloat(buffer+20,10); /* 21 - 30  Sn2 */
	[scalemat atRow: 1 col: col value: t_val];
	t_val = mkFloat(buffer+30,10); /* 31 - 40  Sn3 */
	[scalemat atRow: 2 col: col value: t_val];
	t_val = mkFloat(buffer+45,10); /* 46 - 55  U */
	[scalemat atRow: 3 col: col value: t_val];
}


-(oneway void)readMatrix:(in NSString*)line
{
	MTMatrix44 *matx;
	double t_val;
	int serial;
	int col;
	char buffer[81];
	NSString *key;

	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	col = buffer[5] - '1';
	serial = mkInt(buffer+7,3); /* serial number 8 - 10 */
	key = [NSString stringWithFormat:@"NCSMATRIX%d",serial];
	if (col == 0)
	{
		matx = [MTMatrix44 matrixIdentity];
		[strx setDescriptor: matx withKey: key];
	} else {
		matx = [strx getDescriptorForKey: key];
		if (!matx)
		{
			buffer[6]='\0';
			[NSException raise:@"Error" format:@"NCS MTRIXn matrix not defined in line: %s",buffer];
		}
	}
	/* matrix columns */
	t_val = mkFloat(buffer+10,10); /* 11 - 20  Mn1 */
	[matx atRow: 0 col: col value: t_val];
	t_val = mkFloat(buffer+20,10); /* 21 - 30  Mn2 */
	[matx atRow: 1 col: col value: t_val];
	t_val = mkFloat(buffer+30,10); /* 31 - 40  Mn3 */
	[matx atRow: 2 col: col value: t_val];
	t_val = mkFloat(buffer+45,10); /* 46 - 55  Vn */
	[matx atRow: 3 col: col value: t_val];
	if (buffer[59] == '1')
	{
		/* coordinates for the given transformation are approx. already present in the file */
		key = [NSString stringWithFormat:@"NCSMATRIX%d present",serial];
		[strx setDescriptor: @"1" withKey: key];
	}
}


-(oneway void)readOrigx:(in NSString*)line
{
	MTMatrix44 *omat;
	double t_val;
	int col;
	char buffer[81];
	
	memset(buffer,0,81);
	[line getCString: buffer maxLength: 81];
	col = buffer[5] - '1';
	if (col == 0)
	{
		omat = [MTMatrix44 matrixIdentity];
		[strx setDescriptor: omat withKey: @"ORIGMATRIX"];
	} else {
		omat = [strx getDescriptorForKey: @"ORIGMATRIX"];
		if (!omat)
		{
			buffer[6]='\0';
			[NSException raise:@"Error" format:@"ORIGX matrix not defined in line: %s",buffer];
		}
	}
	/* matrix columns */
	t_val = mkFloat(buffer+10,10); /* 11 - 20  On1 */
	[omat atRow: 0 col: col value: t_val];
	t_val = mkFloat(buffer+20,10); /* 21 - 30  On2 */
	[omat atRow: 1 col: col value: t_val];
	t_val = mkFloat(buffer+30,10); /* 31 - 40  On3 */
	[omat atRow: 2 col: col value: t_val];
	t_val = mkFloat(buffer+45,10); /* 46 - 55  Tn */
	[omat atRow: 3 col: col value: t_val];
}


@end

/* given a string in the format DD-MMM-YY, where MMM is a textual repr. of
 * a month, return the ISO date as YYYY-MM-DD 
 */
NSCalendarDate *mkISOdate (char *dstring)
{
	int month=1;
	int year=0;
	int day=1;
	if (dstring[7]=='0' || dstring[7]=='1' || dstring[7]=='2')
	{
		year = 2000+(dstring[7]-48)*10+dstring[8]-48;
	} else {
		year = 1900+(dstring[7]-48)*10+dstring[8]-48;
	}
	day = (dstring[0]-48)*10+dstring[1]-48;
	switch(dstring[3])
	{
		case 'J':
			switch(dstring[4])
			{
				case 'A': month = 1; break; // January
				case 'U': if (dstring[5]=='N')
					  {
						month = 6; // June
					  } else {
						month = 7; // July
					  }; break;
			}
			break;
		case 'M':
			if (dstring[5]=='R')
			{
				month = 3; // March
			} else {
				month = 5; // May
			}
			break;
		case 'A':
			if (dstring[4]=='P')
			{
				month = 4; // April
			} else {
				month = 8; // August
			}
			break;
		case 'N':
			month = 11; // November
			break;
		case 'S':
			month = 9; // September
			break;
		case 'D':
			month = 12; // December
			break;
		case 'F':
			month = 2; // February
			break;
		case 'O':
			month = 10; // October
			break;
	}
	NSString *t_date = [NSString stringWithFormat:@"%4d-%02d-%02d",year,month,day];
	return [NSCalendarDate dateWithString: t_date calendarFormat: @"%Y-%m-%d"];
}


static double fzehner[] = {0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1.0,10.0,100.0,1000.0,10000.0,100000.0,1000000.0,10000000.0,100000000.0};
static int izehner[] = {1,10,100,1000,10000,100000,1000000,10000000,100000000};


double mkFloat (const char *buffer, int len)
{
	int i;
	int pos;
	int exponent;
	double res;
	char val;
	int sign;
	res=0.0;
	pos=0;
	sign=+1;
	/* find decimal point first */
	for (i=0;i<len;i++)
	{
		if (buffer[i]=='.')
		{
			pos=i;
			break;
		}
	}
	/* make positive exponents */
	exponent=9; // == 10^0 == 1
	for (i=pos-1;i>=0;i--)
	{
		val = buffer[i];
		if (val>47 && val<58)
		{
			res += (double)(val-48)*fzehner[exponent];
			exponent++;
		}
		if (val==' ')
		{
			break;
		}
		if (val=='-')
		{
			sign = -1;
			break;
		}
	}
	/* make negative exponents */
	exponent=8; // == 10^-1 == 0.1
	for (i=pos+1;i<len;i++)
	{
		val = buffer[i];
		if (val>47 && val<58)
		{
			res += (double)(val-48)*fzehner[exponent];
			exponent--;
		}
		if (val==' ')
		{
			break;
		}
	}
	if (sign==-1)
	{
		res = 0.0 - res;
	}
	
	//printf("mkFloat:%s(%d)=%1.3f\n",buffer,len,res);
	return res;
}


int mkInt (const char *buffer, int len)
{
	int i;
	int res;
	int sign;
	char val;
	res = 0;
	sign = +1;
	for (i=0;i<len;i++)
	{
		val = buffer[i];
		if (val>47 && val<58)
		{
			res += (val-48)*izehner[len-1-i];
		} else if (val==45)
		{
			sign = -1;
		}
	}
	//printf("mkInt:%s(%d)=%d\n",buffer,len,res);
	if (sign == -1)
	{
		return res*sign;
	} else {
		return res;
	}
}

~~~
