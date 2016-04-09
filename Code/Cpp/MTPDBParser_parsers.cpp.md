
declared in [MTPDBParser](MTPDBParser.hpp.md)

~~~ { .cpp }

int mkInt (const char *buffer, int len);
double mkFloat (const char *buffer, int len);

#ifndef NDEBUG

int MTPDBParser::make_int(const char * s, int l) const
{
	return mkInt(s, l);
}

double MTPDBParser::make_float(const char * s, int l) const
{
	return mkFloat(s, l);
}

/*
timestamp MTPDBParser::mkISOdate(std::string const & s) const
{
	return _pimpl->mkISOdate(s);
}
std::string MTPDBParser::prtISOdate(timestamp const & s) const
{
	return _pimpl->prtISOdate(s);
} */

void MTPDBParser::clipright(std::string & s) const
{
	return _pimpl->clipright(s);
}
void MTPDBParser::clipleft(std::string & s) const
{
	return _pimpl->clipleft(s);
}
void MTPDBParser::clip(std::string & s) const
{
	return _pimpl->clip(s);
}

#endif


void pdbline::cleanup()
{
	// remove eol
	for (int i = length()-1; i >= 0; i--) {
		if (buf[i] < 15) { buf[i] = '\\0'; } }

	// clip from right
	for (int i = length()-1; i >= 0; i--) {
		if (buf[i] != 0 && buf[i] != ' ') { break; }
		buf[i] = '\\0'; }
	// clip from left
	int pos=0;
	for (pos = 0; pos < length(); pos++) {
		if (buf[pos] != ' ') { break; } }
	if (pos > 0) {
		for (int i=0; i<length()-pos; i++) {
			buf[i] = buf[i+pos]; }
		for (int i=length()-pos; i<length(); i++) {
			buf[i] = '\\0'; }
	}
}
int pdbline::length() const
{
	if (! buf) { return 0; }
	return strlen(buf);
}
std::string pdbline::toString() const
{
	int ll = length();
	if (ll <= 0) { return ""; }
	return std::string(buf, ll);
}
std::string pdbline::substr(int pos, int len) const
{
	int ll = std::min(len, length()-pos);
	if (ll <= 0) { return ""; }
	//std::clog << "substr => " << len << "@" << pos << "  on " << buf << std::endl;
	return std::string(buf, pos, ll);
}
std::string pdbline::getDescriptor() const
{
	int ll = length();
	if (ll < 6) { return ""; }
	return std::string(buf,0,6);
}
static int izehner[] = {1,10,100,1000,10000,100000,1000000,10000000,100000000};
int pdbline::getInt(int pos, int len) const
{
	if (pos + len >= 120) { return 0; }
	return mkInt(buf+pos, len);
}
static double fzehner[] = {0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1.0,10.0,100.0,1000.0,10000.0,100000.0,1000000.0,10000000.0,100000000.0};
double pdbline::getFloat(int pos, int len) const
{
	if (pos + len >= 120) { return 0; }
	return mkFloat(buf+pos, len);
}

double mkFloat (const char *buffer, int len)
{
	int i, pos, exponent;
	double res=0.0;
	char val;
	int sign=+1;
	pos=0;
	/* find decimal point first */
	for (i=0;i<len;i++) {
		if (buffer[i]=='.') { pos=i; break; }
	}
	/* make positive exponents */
	exponent=9; // == 10^0 == 1
	for (i=pos-1;i>=0;i--) {
		val = buffer[i]-48;
		if (val==('-'-48)) { sign = -1; break; }
		if (val>=0 && val<10) {
			res += val*fzehner[exponent];
			exponent++; }
		else { break; }
	}
	//res = mkInt(buffer, pos);
	/* make negative exponents */
	exponent=8; // == 10^-1 == 0.1
	for (i=pos+1;i<len;i++) {
		val = buffer[i]-48;
		if (val>=0 && val<10) {
			res += val*fzehner[exponent];
			exponent--; }
		else { break; }
	}
	if (sign==-1) { res = -res; }
	
	//printf("mkFloat:%s(%d)=%1.3f\n",buffer,len,res);
	return res;
}

int mkInt (const char *buffer, int len)
{
	int i, res, sign;
	char val;
	res = 0;
	sign = +1;
	for (i=0;i<len;i++) {
		val = buffer[i]-48;
		if (val>=0 && val<10) {
			res += val*izehner[len-1-i]; } 
		else if (val==('-'-48)) {
			sign = -1; }
	}
	//printf("mkInt:%s(%d)=%d\n",buffer,len,res);
	if (sign == -1) {
		return -res; } 
	else {
		return res; }
}

std::string MTPDBParser::pimpl::prtISOdate(timestamp const & s)
{
	struct tm _tm;
	time_t _t = boost::chrono::round<boost::chrono::seconds>(s.time_since_epoch()).count();
	localtime_r(&_t, &_tm);

	std::ostringstream ss;
	ss << _tm.tm_year << "-" << _tm.tm_mon << "-" << _tm.tm_mday;
	return ss.str();
}

timestamp MTPDBParser::pimpl::mkISOdate(std::string const & s)
 /* format: DD-MMM-YY */
{
/* given a string in the format DD-MMM-YY, where MMM is a textual repr. of
 * a month, return the ISO date as YYYY-MM-DD 
 */
	if (s.empty()) { return boost::chrono::system_clock::from_time_t(0); }
	const char *dstring = s.c_str();
	int month=1;
	int year=0;
	int day=1;
	if (dstring[7]>='0' && dstring[7]<='4') {
		year = 2000+(dstring[7]-48)*10+dstring[8]-48; } 
	else {
		year = 1900+(dstring[7]-48)*10+dstring[8]-48; }
	day = (dstring[0]-48)*10+dstring[1]-48;
	switch(dstring[3]) {
		case 'J':
			switch(dstring[4]) {
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
			if (dstring[5]=='R') {
				month = 3; } // March
			else {
				month = 5; } // May
			break;
		case 'A':
			if (dstring[4]=='P') {
				month = 4; } // April
			else {
				month = 8; } // August
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
	struct tm _tm;
	_tm.tm_year = year-1900;
	_tm.tm_mday = day;
	_tm.tm_mon = month;
	_tm.tm_hour = 0; _tm.tm_min = 0; _tm.tm_sec = 0;
	//std::clog << " y:" << year << " m:" << month << " d:" << day << std::endl;
	time_t _t = mktime(&_tm);
	//std::clog << " time is: " << ctime(&_t) << std::endl;
	return boost::chrono::system_clock::from_time_t(_t);
}

std::list<std::string> MTPDBParser::pimpl::make_list_of_strings(std::string const & s) const
{
	std::istringstream ss;
	ss.str(s);
	std::list<std::string> _list;
	struct pdbline buffer;
	std::string e;
	while (ss.good()) {
		buffer.buf[0]='\\0';
		ss.getline(buffer.buf, 127, ',');
		buffer.cleanup();
		if (buffer.length() > 0) {
			e = buffer.toString(); clip(e);
			_list.push_back(e);
			//std::cout << " entity: " << buffer.buf << std::endl;
		}
	}
	return std::move(_list);
}

void MTPDBParser::pimpl::clipright(std::string & s) const
{
	if (s.empty()) { return; }
	const char * str=s.c_str();
	int idx = s.length() - 1;
	if (idx < 0) { return; }
	while (idx >= 0) {
		if (str[idx] != ' ') {
			s = s.substr(0,idx+1); return; }
		--idx;
	}
	s.clear();
}

void MTPDBParser::pimpl::clipleft(std::string & s) const
{
	if (s.empty()) { return; }
	const char * str=s.c_str();
	int ll = s.length();
	int idx = 0;
	while (idx < ll) {
		if (str[idx] != ' ') {
			s = s.substr(idx,ll-idx); return; }
		++idx;
	}
	s.clear();
}

void MTPDBParser::pimpl::clip(std::string & s) const
{
	clipright(s);
	clipleft(s);
}

// parsers
void MTPDBParser::pimpl::readAtom(pdbline const & line)
{
	unsigned int i,j;
	unsigned int serial,resnr;
	char aname[5]; /* atom name */
	char rname[4]; /* residue name */
	double x,y,z,occ,bfact;
	char icode;
	char chain;
	char element[3]; /* element name */
	char segid[4]; /* segment id */
	int chrg=0;

	if (_haveModel1) { return; }

	/* serial number */
	serial = mkInt(line.buf+6,5); /* 7 - 11 atom serial number */
	/* atom name */
        j=0;
        for (i=0; i<4; i++) { aname[i]='\\0'; }
	for (i=0; i<4; i++) { if (line.buf[i+12]!=' ') { aname[j++]=line.buf[i+12]; } } /* 13 - 16 atom name */
	aname[4]='\\0';
	for (i=3; i>0; i--) { if (aname[i]==' ') aname[i]='\\0'; } /* remove trailing whitespace */
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=line.buf[i+17]; } /* 18 - 20 residue name */
	rname[3]='\\0';
	/* chain identifier */
	chain = line.buf[21]; /* 22 chain identifier */
	/* residue sequence nr */
	icode=line.buf[26]; /* 27 insertion code (\==32) */
	resnr = mkInt(line.buf+22,4); /* 23 - 26 residue sequence number */
	/* x */
	x = mkFloat(line.buf+30,8); /* 31 - 38 x coordinate */
	/* y */
	y = mkFloat(line.buf+38,8); /* 39 - 46 y coordinate */
	/* z */
	z = mkFloat(line.buf+46,8); /* 47 - 54 z coordinate */
	/* occupancy */
	//occ = mkFloat(line.buf+54,6); /* 55 - 60 occupancy */
	/* b factor */
	bfact = mkFloat(line.buf+60,6); /* 61 - 66 temperature factor */
	if (_newfileformat) {
		/* segment id */
		for (i=0; i<4; i++) { segid[i]=line.buf[i+72]; } /* 73 - 76 segment id */
		/* element name */
		for (i=0; i<2; i++) { element[i]=line.buf[i+76]; } /* 77 - 78 element name */
		element[2]='\\0';
		/* charge */
		if (line.buf[78] != 32) {   /* 79 - 80 charge */
			chrg = line.buf[78]-48;
			if (line.buf[79] == '-') {
				chrg = 0 - chrg; }
		}
	}
	
	auto t_chain = _strx->getChain(chain);
	if (!t_chain) {
		std::clog << "newChain: " << (int)chain << std::endl;
		t_chain = _chainfactory.newChain(chain);
		_strx->addChain(t_chain);
		_lastcarboxyl = nullptr;
		_last3prime = nullptr; }

	if (_options & long(parse_options::IGNORE_SIDECHAINS)) {
		if (!(aname[0]==' ' && aname[1]=='C' && aname[2]=='A' && aname[3]=='\\0')) {
			return; } // ignore it all (even nucleic acids!)
	}

	/* create atom - will also derive element name */
	MTAtomFactory _afactory;
	//std::clog << "newAtom: " << serial << " " << aname << std::endl;
	auto t_atom = _afactory.newAtom(serial, aname, x, y, z, bfact);
	if (serial >= 0 && serial < 9999) {
		_known_atoms[serial] = t_atom; }
	if (_options & long(parse_options::IGNORE_HYDROGENS)) {
		/* ignore if hydrogen */
		if (t_atom->element() == MTAtom::element_id::H) { return; }
		/* ignore if it shall be a hydrogen */
		if (element[0]==32 && element[1]=='H') { return; }
	}

	/* insert */
	//std::string resid = MTResidue::computeKey(resnr, icode);
	auto t_residue = t_chain->getResidue(resnr, icode);
	if (!t_residue) {
		t_residue = _residuefactory_aa.newResidue(resnr, rname, icode);
		t_chain->addResidue(t_residue);
		//std::clog << "newResidue: " << resnr << " " << rname << " " << icode << " key=" << resid << std::endl;
		/* set last alternate site from this very first atom of the residue */
/*		lastalternatesite = line.buf[16];
		if (segid[0] != ' ' || segid[1] != ' ' || segid[2] != ' ' || segid[3] != ' ')  // left justified
		{
			//printf("      segment id: %c%c%c%c\n",segid[0],segid[1],segid[2],segid[3]);
			[t_residue setSegid: [NSString stringWithFormat:@"%c%c%c%c", segid[0],segid[1],segid[2],segid[3] ]];
		} */
	} else {
		/* Skip entire atom if alternate location already known. Thus only read first one. */
                if (line.buf[16] != ' ') {
                        if (_lastalternatesite == ' ') {
                                _lastalternatesite = line.buf[16]; }
                        if (!(_options & long(parse_options::ALL_ALTERNATE_ATOMS))) {
                                if (line.buf[16] != _lastalternatesite) {
                                        return; }
                        }
                }
	}

	if (_newfileformat) {
		if (chrg != 0) {
			t_atom->setCharge(chrg); }
		if (element[1]!=' ') { // right justified
			if (element[0]==' ') {
				/* skip space */
				t_atom->setElement(element+1); } 
			else {
				t_atom->setElement(element); }
		}
	}

	t_residue->addAtom(t_atom);
	/* check if this is the amino end of the amino acid */
	if (_lastcarboxyl && aname[0]==' ' && aname[1]=='N' && aname[2]=='\\0') {
		t_atom->bondTo(_lastcarboxyl); }
	/* check if this is the phosphate atom */
	if (_last3prime && aname[0]==' ' && aname[1]=='P' && aname[2]=='\\0') {
		if (t_residue->isNucleicAcid()) {
			t_atom->bondTo(_last3prime); }
	}
	
	/* check if this is the carboxyl end of the amino acid */
	if (aname[0]==' ' && aname[1]=='C' && aname[2]=='\\0') {
		_lastcarboxyl = t_atom; }
	if (aname[0]==' ' && aname[1]=='O' && aname[2]=='3' && aname[3]=='*') {
		_last3prime = t_atom; }
}

void MTPDBParser::pimpl::readHetatom(pdbline const & line)
{
	unsigned int i;
	unsigned int serial,resnr;
	char aname[5]; /* atom name */
	char rname[4]; /* residue name */
	double x,y,z,occ,bfact;
	char icode;
	char chain;
	char element[3]; /* element name */
	char segid[4]; /* segment id */
	int chrg=0;
	bool isSolvent=false;

	if (_haveModel1) { return; }

	/* serial number */
	serial = mkInt(line.buf+6,5); /* 7 - 11 atom serial number */
	/* atom name */
	for (i=0; i<4; i++) { aname[i]=line.buf[i+12]; } /* 13 - 16 atom name */
	aname[4]='\\0';
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=line.buf[i+17]; } /* 18 - 20 residue name */
	rname[3]='\\0';
	if ((rname[0]=='H' && rname[1]=='O' && rname[2]=='H')
	 || (rname[0]=='S' && rname[1]=='O' && rname[2]=='L')
	 || (rname[0]=='D' && rname[1]=='I' && rname[2]=='S'))
	{
		isSolvent = true;
	}
	if (isSolvent && (_options & long(parse_options::IGNORE_SOLVENT)))
	{
		return;  // ignore it completely
	}
	/* chain identifier */
	chain = line.buf[21]; /* 22 chain identifier */
	/* residue sequence nr */
	icode=line.buf[26]; /* 27 insertion code (\==32) */
	resnr = mkInt(line.buf+22,4); /* 23 - 26 residue sequence number */
	//std::clog << boost::format(" read het=%s(%d)/%s(%d)") % aname % serial % rname % resnr << std::endl;
	//std::string resid = MTResidue::computeKey(resnr, icode);
	/* check for modified residue */
/*	if (!isSolvent && ([relation_residue_modres objectForKey:[NSString stringWithFormat:@"%c%@",chain,resid]]))
	{
		return readAtom(line);
	} */
	
	/* x */
	x = mkFloat(line.buf+30,8); /* 31 - 38 x coordinate */
	/* y */
	y = mkFloat(line.buf+38,8); /* 39 - 46 y coordinate */
	/* z */
	z = mkFloat(line.buf+46,8); /* 47 - 54 z coordinate */
	/* occupancy */
	//occ = mkFloat(line.buf+54,6); /* 55 - 60 occupancy */
	/* b factor */
	bfact = mkFloat(line.buf+60,6); /* 61 - 66 temperature factor */
	if (_newfileformat)
	{
		/* segment id */
		for (i=0; i<4; i++) { segid[i]=line.buf[i+72]; } /* 73 - 76 segment id */
		/* element name */
		for (i=0; i<2; i++) { element[i]=line.buf[i+76]; } /* 77 - 78 element name */
		element[2]='\\0';
		/* charge */
		if (line.buf[78] != 32)
		{   /* 79 - 80 charge */
			chrg = line.buf[78]-48;
			if (line.buf[79] == '-')
			{
				chrg = 0 - chrg;
			}
		}
	}
	
	auto t_chain = _strx->getChain(chain);
	if (!t_chain)
	{
		t_chain = _chainfactory.newChain(chain);
		_strx->addChain(t_chain);
		_lastcarboxyl = nullptr;
		_last3prime = nullptr;
	}
	/* insert */
	MTResidue* t_residue;
	if (isSolvent) {
	 	t_residue = t_chain->getSolvent(resnr, icode); }
	else {
		t_residue = t_chain->getHeterogen(resnr, icode);}
	if (!t_residue) {
		t_residue = _residuefactory_het.newResidue(resnr, rname, icode);
		if (isSolvent) {
			t_chain->addSolvent(t_residue); } 
		else {
			t_chain->addHeterogen(t_residue); }
		/* set last alternate site from this very first atom of the residue */
		_lastalternatesite=line.buf[16];
		if (segid[0] != ' ' || segid[1] != ' ' || segid[2] != ' ' || segid[3] != ' ')  // left justified
		{
			char segbuf[5] = { segid[0],segid[1],segid[2],segid[3], 0 };
			t_residue->_segid = segbuf;
		}
	} else {
		/* Skip entire atom if alternate location already known. Thus only read first one. */
		if (!(_options & long(parse_options::ALL_ALTERNATE_ATOMS))) {
			if (line.buf[16]!=_lastalternatesite) { return; }
		}
	}
	MTAtomFactory _atomfactory;
	auto t_atom = _atomfactory.newAtom(serial,aname, x, y, z, bfact);
	if (serial >= 0 && serial < 9999) {
		_known_atoms[serial] = t_atom; }
	if (_newfileformat) {
		if (chrg != 0) {
			t_atom->setCharge(chrg); }
		if (element[1]!=' ') { // right justified
			if (element[0]==' ') {
				/* skip space */
				t_atom->setElement(element+1); } 
			else {
				t_atom->setElement(element); }
		}
	}

	t_residue->addAtom(t_atom);
}

void MTPDBParser::pimpl::addBondBetween(int p_atm1, int p_atm2) const
{
	MTAtom *atm1=nullptr;
	MTAtom *atm2=nullptr;
	if (p_atm1 >= 0 && p_atm1 < _max_atoms_known) {
		atm1 = _known_atoms[p_atm1]; }
	if (p_atm2 >= 0 && p_atm2 < _max_atoms_known) {
		atm2 = _known_atoms[p_atm2]; }

	if (atm1 && atm2) {
		atm1->bondTo(atm2); }
}

void MTPDBParser::pimpl::readConnect(pdbline const & line)
{
	int atm1 = mkInt(line.buf+6,5);
	int atm2 = mkInt(line.buf+11,5);
	addBondBetween( atm1 , atm2 );
	atm2 = mkInt(line.buf+16,5);
	addBondBetween( atm1 , atm2 );
	atm2 = mkInt(line.buf+21,5);
	addBondBetween( atm1 , atm2 );
	atm2 = mkInt(line.buf+26,5);
	addBondBetween( atm1 , atm2 );
}

void MTPDBParser::pimpl::readHeader(pdbline const & line)
{
	int llength = line.length();
	/* get classification */
	if (llength>10)
	{
		_header = line.substr(10, std::min(llength-10,40));
		clipright(_header);
	} else {
		_header = "HEADER MISSING";
	}
	
	/* get pdb code */
	if (llength>65)
	{
		_pdbcode = line.substr(62,4);
	} else {
		_pdbcode = "0UNK";
	}
	
	/* get deposition date */
	if (llength>58)
	{
		std::string dstring = line.substr(50,9); /* format: DD-MMM-YY */
		_date = mkISOdate (dstring);
	}
}

void MTPDBParser::pimpl::readTitle(pdbline const & line)
{
	/* get TITLE */
	int ll = line.length();
	std::string t = line.substr(10, std::min(ll-10, 60));
	//std::clog << "readTitle: " << t << std::endl;
	if (_title.empty())
	{
		_title = t;
	} else {
		_title += t;
	}
}

void MTPDBParser::pimpl::readCompound(pdbline const & line)
{
	std::string _l(line.buf);
	size_t _pos = _l.find("MOL_ID:");
	if (_pos != std::string::npos) {
		_molid = mkInt(line.buf+_pos+8, 1);
		//std::clog << " found molecule id: " << _molid << std::endl;
		return;
	}
	_pos = _l.find("CHAIN:");
	if (_pos != std::string::npos) {
		size_t _ll = _l.find(';', _pos);
		if (std::string::npos == _ll) { _ll = line.length(); }
		_ll -= _pos+7;
		std::string _c = line.substr(_pos+7, _ll);
		//std::clog << " found chains: " << _c << std::endl;
		//std::string _k = "CHAIN_ "; _k.at(6) = _molid + '0';
		//_strx->setDescriptor(_k, _c);
		if (_molid <= 10) {
			_molid_chains[_molid-1] = make_list_of_strings(_c); }
		return;
	}
	_pos = _l.find(':');
	if (_pos != std::string::npos) {
		size_t _ll = _l.find(';', _pos+1);
		if (std::string::npos == _ll) { _ll = line.length(); }
		_ll -= _pos+2;
		std::string _k = line.substr(11, _pos-11);
		std::string _v = line.substr(_pos+2, _ll);
		_k += "_ "; _k.back() = _molid + '0';
		//std::clog << " found '" << _k << "'='" << _v << "'" << std::endl;
		_strx->setDescriptor(_k, _v);
		return;
	}
/*	_pos = _l.find("MOLECULE:");
	if (_pos != std::string::npos) {
		size_t _ll = _l.find(';', _pos);
		if (std::string::npos == _ll) { _ll = line.length(); }
		_ll -= _pos+10;
		std::string _m = line.substr(_pos+10, _ll);
		//std::clog << " found molecule: " << _m << std::endl;
		std::string _k = "MOLECULE_ "; _k.at(9) = _molid + '0';
		_strx->setDescriptor(_k, _m);
		return;
	} */
}

void MTPDBParser::pimpl::readSource(pdbline const & line)
{
	std::string _l(line.buf);
	size_t _pos = _l.find("MOL_ID:");
	if (_pos != std::string::npos) {
		_molid = mkInt(line.buf+_pos+8, 1);
		//std::clog << " found molecule id: " << _molid << std::endl;
		return;
	}
	_pos = _l.find(':');
	if (_pos != std::string::npos) {
		size_t _ll = _l.find(';', _pos+1);
		if (std::string::npos == _ll) { _ll = line.length(); }
		_ll -= _pos+2;
		std::string _k = line.substr(11, _pos-11);
		std::string _v = line.substr(_pos+2, _ll);
		_k += "_ "; _k.back() = _molid + '0';
		//std::clog << " found '" << _k << "'='" << _v << "'" << std::endl;
		_strx->setDescriptor(_k, _v);
		return;
	}
#ifdef _OBJC_CODE_
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
#endif
}

void MTPDBParser::pimpl::readKeywords(pdbline const & line)
{
	/* get KEYWDS */
	int ll = line.length();
	std::string t = line.substr(10, std::min(ll-10, 60));
	if (_keywords.empty())
	{
		_keywords = t;
	} else {
		_keywords += t;
	}
}

void MTPDBParser::pimpl::readExpdata(pdbline const & line)
{
	if (! line.buf) { return; }
	/* get experiment type (EXPDTA) */
	if (strstr(line.buf, "X-RAY DIFFRACTION")) {
		_expdata = MTStructure::ExperimentType::XRay;
		return;
	}
	if (strstr(line.buf, "NMR")) {
		_expdata = MTStructure::ExperimentType::NMR;
		return;
	}
	if (strstr(line.buf, "THEORETICAL MODEL")) {
		_expdata = MTStructure::ExperimentType::TheoreticalModel;
		return;
	}
	_expdata = MTStructure::ExperimentType::Other;
}

void MTPDBParser::pimpl::readRemark350(pdbline const & line)
{
/*
REMARK 350   BIOMT1   1  1.000000  0.000000  0.000000        0.00000           
REMARK 350   BIOMT2   1  0.000000  1.000000  0.000000        0.00000            
REMARK 350   BIOMT3   1  0.000000  0.000000  1.000000        0.00000            */

	if (line.substr(13,5) != "BIOMT") { return; }
	int nrow = line.buf[18] - '0';
	int nmol = mkInt(line.buf+20, 3);
	float x,y,z,t;
	x = mkFloat(line.buf+23, 10);
	y = mkFloat(line.buf+33, 10);
	z = mkFloat(line.buf+43, 10);
	t = mkFloat(line.buf+59, 10);

	MTMatrix53 m;
	char tbuf[32];
	snprintf(tbuf, 32, "BIOMT_%d", nmol);
	const std::string k(tbuf);
	if (_strx->getDescriptor(k, m)) {
		_strx->unsetDescriptor(k); }
	m.atRowColValue(nrow-1, 0, x);
	m.atRowColValue(nrow-1, 1, y);
	m.atRowColValue(nrow-1, 2, z);
	m.atRowColValue(4, nrow-1, t);
	_strx->setDescriptor(k, m);
	//std::clog << " BIOMT #" << nmol << " row=" << nrow << "  m=" << m << std::endl;
}

void MTPDBParser::pimpl::readRemark(pdbline const & line)
{
/*
REMARK   2 RESOLUTION.    2.80 ANGSTROMS.                                       */
	int nrem = mkInt(line.buf+6, 4);

	//std::clog << "REMARK " << nrem << std::endl;
	if (2 == nrem && strstr(line.buf, "RESOLUTION.")) {
		_resolution = mkFloat(line.buf+23, 8); }
	if (4 == nrem && strstr(line.buf, "COMPLIES WITH FORMAT")) {
		_newfileformat = true; }

	// contains BIOMT transformation matrices
	if (350 == nrem) { readRemark350(line); }

	if ((_options & long(parse_options::ALL_REMARKS)) == 0) { return; }

	char tbuf[32];
	snprintf(tbuf, 32, "REMARK_%d", nrem);
	const std::string k(tbuf);
	std::string s;
	if (_strx->getDescriptor(k, s)) {
		_strx->unsetDescriptor(k);
		s += line.substr(10, line.length() - 10); }
	else {
		s = line.substr(10, line.length() - 10); }

	clip(s);
	_strx->setDescriptor(k, s);
	//std::clog << " options=" << _options << " flag=" << long(parse_options::ALL_REMARKS) << " read remark: " << k << " = " << s << std::endl;
}

void MTPDBParser::pimpl::readModel(pdbline const & line)
{
	int t_mnr = mkInt(line.buf+10,4);
	//std::clog << " mnr = " << t_mnr << " _options = " << long(_options) << std::endl;
	if (_options & long(parse_options::ALL_NMRMODELS))
	{
		if (t_mnr > 1)
		{
			_modelnr = _strx->addModel(); // will store structure in new model
			//std::clog << " added new model, now active = " << _modelnr << std::endl;
		}
	}
}

void MTPDBParser::pimpl::readEndModel(pdbline const & line)
{
	if ((_options & long(parse_options::ALL_NMRMODELS)) == 0)
	{
		_haveModel1 = true;
		/* stop reading ATOM and HETATM records (in other models) */
		_parserSelectors["ATOM  "] = [](pdbline const & ){return;};
		_parserSelectors["HETATM"] = [](pdbline const & ){return;};
	}
}

void MTPDBParser::pimpl::readRevDat(pdbline const & line)
{
/*
REVDAT   2   24-FEB-09 1IM2    1       VERSN                                    
REVDAT   1   08-AUG-01 1IM2    0                                               */
	char tbuf[32];
	int n = mkInt(line.buf+7, 3);
	snprintf(tbuf, 32, "REVDAT_%d", n);
	//std::clog << "setting rev date: " << line.substr(13, 9) << " for number = " << n << std::endl;
	_strx->setDescriptor(std::string(tbuf), line.substr(13, 9));
}

void MTPDBParser::pimpl::readHetname(pdbline const & line)
{
	std::string _rname(line.buf+11,3);
	std::string _hname(line.buf+15,line.length()-15);
	clip(_hname);
	_strx->setDescriptor(std::string("HETNAME_")+_rname, _hname);
}

void MTPDBParser::pimpl::readFormula(pdbline const & line)
{
	std::string _rname(line.buf+12,3);
	std::string _hform(line.buf+19,line.length()-19);
	clip(_hform);
	_strx->setDescriptor(std::string("FORMULA_")+_rname, _hform);
}

void MTPDBParser::pimpl::readModres(pdbline const & line)
{
/*
MODRES 1IM2 MSE A   55  MET  SELENOMETHIONINE                                   
*/
	std::string _modname(line.buf+12,3);
	std::string _moddesc(line.buf+29,line.length()-29);
	char _ch = line.buf[16];
	int _rnum = mkInt(line.buf+18,4);
	modified_residues.push_back(std::make_tuple(_ch, _rnum, _modname, _moddesc));
}

void MTPDBParser::pimpl::readChainTerminator(pdbline const & line) {};
void MTPDBParser::pimpl::readSeqres(pdbline const & line) {};

void MTPDBParser::pimpl::readCryst(pdbline const & line)
{
	MTVector unitvector(3);
	MTVector unitangles(3);
	double t_val;
	std::string spcgrp; /* space group */

	/* crystallographic unit cell vectors */
	t_val = mkFloat(line.buf+6,9);  /*  7 - 15  unit cell: a */
	unitvector.atDim(0, t_val);
	t_val = mkFloat(line.buf+15,9); /* 16 - 24  unit cell: b */
	unitvector.atDim(1, t_val);
	t_val = mkFloat(line.buf+24,9); /* 25 - 33  unit cell: c */
	unitvector.atDim(2, t_val);
	_strx->setDescriptor("UNITVECTOR", unitvector);

	/* crystallographic unit cell angles */
	t_val = mkFloat(line.buf+33,7); /* 34 - 40  unit cell: alpha */
	unitangles.atDim(0, t_val);
	t_val = mkFloat(line.buf+40,7); /* 41 - 47  unit cell: beta */
	unitangles.atDim(1, t_val);
	t_val = mkFloat(line.buf+47,7); /* 48 - 54  unit cell: gamma */
	unitangles.atDim(2, t_val);
	_strx->setDescriptor("UNITANGLES", unitangles);

	/* space group */
	//range.location=55; /* 56 - 66  space group*/
	spcgrp = line.substr(55, 11);
	clipright(spcgrp);
	_strx->setDescriptor("SPACEGROUP", spcgrp);

	/* Z value */
	int t_ival = mkInt(line.buf+66,4); /* 67 - 70  Z value */
	_strx->setDescriptor("ZVALUE", t_ival);
}

void MTPDBParser::pimpl::readScale(pdbline const & line)
{
	MTMatrix44 smat;
	double t_val;
	int col;
	col = line.buf[5] - '1';
	//std::clog << "readScale: " << col << std::endl;
	if (col > 0)
	{
		// read back matrix
		if (! _strx->getDescriptor("SCALEMATRIX", smat)) {
			std::cerr << "SCALE matrix not yet defined in strx!" << std::endl;
			return;
		}
	}
	/* matrix columns */
	t_val = mkFloat(line.buf+10,10); /* 11 - 20  Sn1 */
	smat.atRowColValue(0, col, t_val);
	t_val = mkFloat(line.buf+20,10); /* 21 - 30  Sn2 */
	smat.atRowColValue(1, col, t_val);
	t_val = mkFloat(line.buf+30,10); /* 31 - 40  Sn3 */
	smat.atRowColValue(2, col, t_val);
	t_val = mkFloat(line.buf+45,10); /* 46 - 55  U */
	smat.atRowColValue(3, col, t_val);

	// store matrix
	_strx->unsetDescriptor("SCALEMATRIX");
	if (! _strx->setDescriptor("SCALEMATRIX", smat)) {
		std::cerr << "SCALE matrix cannot be stored in strx!" << std::endl;
		return;
	}
}

void MTPDBParser::pimpl::readMatrix(pdbline const & line)
{
	MTMatrix44 mmat;
	double t_val;
	int col;
	col = line.buf[5] - '1';
	//std::clog << "readMatrix : " << col << std::endl;
	if (col > 0)
	{
		// read back matrix
		if (! _strx->getDescriptor("NCSMATRIX", mmat)) {
			std::cerr << "NCS matrix not yet defined in strx!" << std::endl;
			return;
		}
	}
	/* matrix columns */
	t_val = mkFloat(line.buf+10,10); /* 11 - 20  Mn1 */
	mmat.atRowColValue(0, col, t_val);
	t_val = mkFloat(line.buf+20,10); /* 21 - 30  Mn2 */
	mmat.atRowColValue(1, col, t_val);
	t_val = mkFloat(line.buf+30,10); /* 31 - 40  Mn3 */
	mmat.atRowColValue(2, col, t_val);
	t_val = mkFloat(line.buf+45,10); /* 46 - 55  Vn */
	mmat.atRowColValue(3, col, t_val);

	// store matrix
	_strx->unsetDescriptor("NCSMATRIX");
	if (! _strx->setDescriptor("NCSMATRIX", mmat)) {
		std::cerr << "NCS matrix cannot be stored in strx!" << std::endl;
		return;
	}
}

void MTPDBParser::pimpl::readOrigx(pdbline const & line)
{
	MTMatrix44 omat;
	double t_val;
	int col;
	col = line.buf[5] - '1';
	//std::clog << "readOrigx : " << col << std::endl;
	if (col > 0)
	{
		// read back matrix
		if (! _strx->getDescriptor("ORIGMATRIX", omat)) {
			std::cerr << "ORIGX matrix not yet defined in strx!" << std::endl;
			return;
		}
	}
	/* matrix columns */
	t_val = mkFloat(line.buf+10,10); /* 11 - 20  On1 */
	omat.atRowColValue(0, col, t_val);
	t_val = mkFloat(line.buf+20,10); /* 21 - 30  On2 */
	omat.atRowColValue(1, col, t_val);
	t_val = mkFloat(line.buf+30,10); /* 31 - 40  On3 */
	omat.atRowColValue(2, col, t_val);
	t_val = mkFloat(line.buf+45,10); /* 46 - 55  Tn */
	omat.atRowColValue(3, col, t_val);

	// store matrix
	_strx->unsetDescriptor("ORIGMATRIX");
	if (! _strx->setDescriptor("ORIGMATRIX", omat)) {
		std::cerr << "ORIGX matrix cannot be stored in strx!" << std::endl;
		return;
	}
}

void MTPDBParser::pimpl::readSite(pdbline const & line) {};

void MTPDBParser::pimpl::readLine(struct pdbline const & _pdbline)
{
	const std::string sel(_pdbline.getDescriptor());
	auto it = _parserSelectors.find(sel);
	if (it != _parserSelectors.cend()) {
		//std::clog << "selector: " << sel << std::endl;
		it->second(_pdbline);
	}
}

void MTPDBParser::pimpl::finish_parsing()
{
        // set the parsed data in the structure
        _strx->_pdbcode = _pdbcode;
        _strx->_title = _title;
        _strx->_header = _header;
        _strx->_keywords = make_list_of_strings(_keywords);
        _strx->_resolution = _resolution;
	_strx->setDescriptor("EXPDATA", long(_expdata));

	// data by molecule id
	std::string k,v;
	for (int i=1; i<=10; i++) {
		for (auto const & s : _molid_chains[i-1]) {
			//std::clog << " molid = " << i << " -> chain = " << s << std::endl;
			auto _ch = _strx->getChain(s.at(0));
			if (! _ch) {
				_ch = _chainfactory.newChain(s.at(0));
				_strx->addChain(_ch); }
			// source
			k = "ORGANISM_SCIENTIFIC_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			k = "ORGANISM_COMMON_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			k = "ORGANISM_TAXID_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			k = "GENE_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			k = "SYNTHETIC_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			// compound
			k = "MOLECULE_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
			k = "ENGINEERED_ ";
			k.back() = i + '0';
			if (_strx->getDescriptor(k, v)) { _ch->setDescriptor(k.substr(0,k.length()-2), v); }
		}
	}

	// modified residues
	for (auto const e : modified_residues) {
		char _c;
		int _rnum;
		std::string _modname, _moddesc;
		_c = std::get<0>(e);
		_rnum = std::get<1>(e);
		_modname = std::get<2>(e);
		_moddesc = std::get<3>(e);
		auto _chain = _strx->getChain(_c);
		if (_chain) {
			auto _residue = _chain->getResidue(_rnum);
			if (_residue) {
				_residue->_modname = _modname;
				_residue->_moddesc = _moddesc;
			}
		}
	}
}

void MTPDBParser::setup_parsers()
{
	_pimpl->setup_parsers();
}
void MTPDBParser::pimpl::setup_parsers()
{
	_srcOldStyle = true;
	_cmpndOldStyle = true;
	_newfileformat = false;
	
	_residuefactory_aa.setFactory( ([]()->MTResidue*{ return new MTResidueAA(); }) );
	_residuefactory_het.setFactory( ([]()->MTResidue*{ return new MTResidue(); }) );

	_modelnr = 1;
	_haveModel1 = false;

	_lastrevnr = 0;
	_lastcarboxyl = nullptr; // connect amino acids N-term - C-term
	_last3prime = nullptr;   // connect nucleic acids 5' - 3'
	_lastalternatesite = ' '; // the id of the last alternate site read

	// default information
	_pdbcode = "0UNK";
	_header = "HEADER MISSING";
	//_date = 0;
	//_lastrevdate = 0;
	_title = "";
	_keywords = "";
	_resolution = 0.0;
	_expdata = MTStructure::ExperimentType::Unknown;

	_parserSelectors.insert({"ATOM  " , std::bind(&MTPDBParser::pimpl::readAtom, this, _1)});
	_parserSelectors.insert({"HETATM" , std::bind(&MTPDBParser::pimpl::readHetatom, this, _1)});
	_parserSelectors.insert({"CONECT" , std::bind(&MTPDBParser::pimpl::readConnect, this, _1)});
	_parserSelectors.insert({"HEADER" , std::bind(&MTPDBParser::pimpl::readHeader, this, _1)});
	_parserSelectors.insert({"TITLE " , std::bind(&MTPDBParser::pimpl::readTitle, this, _1)});
	_parserSelectors.insert({"COMPND" , std::bind(&MTPDBParser::pimpl::readCompound, this, _1)});
	_parserSelectors.insert({"SOURCE" , std::bind(&MTPDBParser::pimpl::readSource, this, _1)});
	_parserSelectors.insert({"KEYWDS" , std::bind(&MTPDBParser::pimpl::readKeywords, this, _1)});
	_parserSelectors.insert({"EXPDTA" , std::bind(&MTPDBParser::pimpl::readExpdata, this, _1) });
	_parserSelectors.insert({"REMARK" , std::bind(&MTPDBParser::pimpl::readRemark, this, _1)});
	_parserSelectors.insert({"MODEL " , std::bind(&MTPDBParser::pimpl::readModel, this, _1)});
	_parserSelectors.insert({"ENDMDL" , std::bind(&MTPDBParser::pimpl::readEndModel, this, _1)});
	_parserSelectors.insert({"REVDAT" , std::bind(&MTPDBParser::pimpl::readRevDat, this, _1)});
	_parserSelectors.insert({"TER   " , std::bind(&MTPDBParser::pimpl::readChainTerminator, this, _1)});
	_parserSelectors.insert({"HETNAM" , std::bind(&MTPDBParser::pimpl::readHetname, this, _1)});
	_parserSelectors.insert({"FORMUL" , std::bind(&MTPDBParser::pimpl::readFormula, this, _1)});
	_parserSelectors.insert({"MODRES" , std::bind(&MTPDBParser::pimpl::readModres, this, _1)});
	_parserSelectors.insert({"SEQRES" , std::bind(&MTPDBParser::pimpl::readSeqres, this, _1)});
	_parserSelectors.insert({"CRYST1" , std::bind(&MTPDBParser::pimpl::readCryst, this, _1)});
	_parserSelectors.insert({"SCALE1" , std::bind(&MTPDBParser::pimpl::readScale, this, _1)});
	_parserSelectors.insert({"SCALE2" , std::bind(&MTPDBParser::pimpl::readScale, this, _1)});
	_parserSelectors.insert({"SCALE3" , std::bind(&MTPDBParser::pimpl::readScale, this, _1)});
	_parserSelectors.insert({"MTRIX1" , std::bind(&MTPDBParser::pimpl::readMatrix, this, _1)});
	_parserSelectors.insert({"MTRIX2" , std::bind(&MTPDBParser::pimpl::readMatrix, this, _1)});
	_parserSelectors.insert({"MTRIX3" , std::bind(&MTPDBParser::pimpl::readMatrix, this, _1)});
	_parserSelectors.insert({"ORIGX1" , std::bind(&MTPDBParser::pimpl::readOrigx, this, _1)});
	_parserSelectors.insert({"ORIGX2" , std::bind(&MTPDBParser::pimpl::readOrigx, this, _1)});
	_parserSelectors.insert({"ORIGX3" , std::bind(&MTPDBParser::pimpl::readOrigx, this, _1)});
	_parserSelectors.insert({"SITE  " , std::bind(&MTPDBParser::pimpl::readSite, this, _1)});
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
	aname[4]='\\0';
	for (i=3; i>0; i--) { if (aname[i]==' ') aname[i]='\\0'; } /* remove trailing whitespace */
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=buffer[i+17]; } /* 18 - 20 residue name */
	rname[3]='\\0';
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
		element[2]='\\0';
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
		if (!(aname[0]==' ' && aname[1]=='C' && aname[2]=='A' && aname[3]=='\\0'))
		{
			return; // ignore it all (even nucleic acids!)
		}
	}

	/* create atom - will also derive element name */
	MTAtom *t_atom = [MTAtomFactory newAtomWithNumber:serial name:aname X:x Y:y Z:z B:bfact];
	if (options & PDBPARSER_IGNORE_HYDROGENS)
	{
		/* ignore if hydrogen */
		if ([t_atom element] == element_id::H)
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
			char segbuf[5] = { segid[0],segid[1],segid[2],segid[3], 0 };
			t_residue->_segid = segbuf;
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
	if (lastcarboxyl && aname[0]==' ' && aname[1]=='N' && aname[2]=='\\0')
	{
		[t_atom bondTo: lastcarboxyl];
	}
	/* check if this is the phosphate atom */
	if (last3prime && aname[0]==' ' && aname[1]=='P' && aname[2]=='\\0')
	{
		if ([t_residue isNucleicAcid])
		{
			[t_atom bondTo: last3prime];
		}
	}
	
	/* check if this is the carboxyl end of the amino acid */
	if (aname[0]==' ' && aname[1]=='C' && aname[2]=='\\0')
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
	aname[4]='\\0';
	/* residue name */
	for (i=0; i<3; i++) { rname[i]=buffer[i+17]; } /* 18 - 20 residue name */
	rname[3]='\\0';
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
		element[2]='\\0';
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
		_date = mkISOdate(dstring);
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
		cstring[30] = '\\0';
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
	cline[14] = '\\0';
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

	linstr[10]='\\0';
	linstr[22]='\\0';
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
			buffer[6]='\\0';
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
			buffer[6]='\\0';
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
			buffer[6]='\\0';
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
