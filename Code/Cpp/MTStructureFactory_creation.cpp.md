
declared in [MTStructureFactory](MTStructureFactory.hpp.md)

~~~ { .cpp }
std::shared_ptr<MTStructure> IStructureFactory::newInstance()
{
    if (_factory) {
        ++_instance_counter;
        return std::shared_ptr<MTStructure>(_factory()); }
    return nullptr;
}
~~~

~~~ { .cpp }
std::shared_ptr<MTStructure> MTStructureFactory::newStructure()
{
    return newInstance();
}
~~~

~~~ { .cpp }
std::shared_ptr<MTStructure> MTStructureFactory::newStructureFromPDBDirectory(std::string const p_code, long options)
{
	if (p_code.length() < 4) {
	   std::clog << "structure code is too short!" << std::endl;
	   return nullptr; }
	char *pdbd = getenv("PDBDIR");
	if (!pdbd) {
	   std::clog << "no env var PDBDIR defined!" << std::endl;
	   return nullptr; }
	const std::string _bp(pdbd);
	char d1,d2;
	std::string _code(p_code);
	for (int i=0; i<_code.length(); i++) {
		char c = _code.at(i);
		if (c >= 'A' && c <= 'Z') {
			_code.at(i) = c + 'a' - 'A'; }
	}
	d1 = _code.at(1); d2 = _code.at(2);
	std::string fp = (boost::format("%s/%c%c/pdb%s.ent.gz") % _bp % d1 % d2 % _code).str();
	if (boost::filesystem::exists(fp)) {
		std::clog << "found file " << fp << std::endl;
	} else {
		std::clog << "missing file " << fp << std::endl;
		return nullptr;
	}

	std::ifstream _infile(fp, std::ios_base::in | std::ios_base::binary);
	boost::iostreams::filtering_istreambuf _inbuf;
	_inbuf.push(boost::iostreams::gzip_decompressor());
	_inbuf.push(_infile);
	std::istream _istr(&_inbuf);
	
	MTPDBParser _parser(options);
	return _parser.parseStructureFromPDBStream(_istr);
}
~~~

~~~ { .cpp }
std::shared_ptr<MTStructure> MTStructureFactory::newStructureFromPDBFile(std::string const p_fn, long options)
{
    return newInstance();
}
~~~


original objc code:

~~~ { .ObjectiveC }

~~~
