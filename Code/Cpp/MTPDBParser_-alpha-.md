~~~ { .cpp }

#include "MTPDBParser.hpp"
#include "MTStructureFactory.hpp"
#include "MTChainFactory.hpp"
#include "MTResidueFactory.hpp"
#include "MTAtomFactory.hpp"
#include "MTAtom.hpp"
#include "MTResidue.hpp"
#include "MTResidueAA.hpp"
#include "MTChain.hpp"
#include "MTStructure.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"
#include "MTCoordinates.hpp"

#include "boost/format.hpp"
#include "boost/filesystem.hpp"
#include "boost/chrono/chrono.hpp"
#include "boost/chrono/round.hpp"
#include "boost/chrono/chrono_io.hpp"

#include <iostream>
#include <fstream>
#include <sstream>

#include <ctime>

#include <functional>
#include <unordered_map>

using namespace std::placeholders;
using timestamp = boost::chrono::system_clock::time_point;


namespace mt {

struct pdbline {
	char buf[120];
	void cleanup();
	int length() const;
	std::string toString() const;
	std::string substr(int pos, int len) const;
	std::string getDescriptor() const;
	int getInt(int pos, int len) const;
	double getFloat(int pos, int len) const;
};

struct MTPDBParser::pimpl {
	pimpl() { setup_parsers(); }
	~pimpl() {};

        using fn_parser = std::function<void(struct pdbline const &)>;
        std::unordered_map<std::string, fn_parser> _parserSelectors;

	MTChainFactory _chainfactory;
	MTResidueFactory _residuefactory_aa;
	MTResidueFactory _residuefactory_het;

	long _options;
        MTStructure* _strx;
        int _molid { 0 };
	std::list<std::string> _molid_chains[10];
        std::string _pdbcode;
        timestamp _date;
        std::string _header;
        std::string _title;
        std::string _keywords;
        float _resolution;
        MTStructure::ExperimentType _expdata;
        int _lastrevnr;
        timestamp _lastrevdate;

        std::unordered_map<char, MTChain*> relation_chain_seqres;
        std::unordered_map<char, int> relation_chain_molid;
        std::unordered_map<int, std::string> relation_molid_eccode;
        std::unordered_map<int, std::string> relation_molid_compound;
        std::unordered_map<int, std::string> relation_molid_source;
        std::unordered_map<std::string, std::string> relation_residue_modres;

        bool _isCompressed;
        bool _srcOldStyle;
        bool _cmpndOldStyle;
        bool _newfileformat;
        int _modelnr;
        bool _haveModel1;

	MTAtom* _known_atoms[9999];
	int _max_atoms_known { 9999 };
        MTAtom* _lastcarboxyl { nullptr };
        MTAtom* _last3prime { nullptr };
        char _lastalternatesite;

	void setup_parsers();

	std::list<std::string> make_list_of_strings(std::string const &) const;

	std::list<std::tuple<char,int,std::string,std::string>> modified_residues;

	void clipright(std::string &) const;
	void clipleft(std::string &) const;
	void clip(std::string &) const;

	std::string prtISOdate(timestamp const & dt);
	timestamp mkISOdate(std::string const & dt);

	void finish_parsing();
	void readLine(pdbline const & line);

	void addBondBetween(int, int) const;

	void readAtom(pdbline const & line);
	void readHetatom(pdbline const & line);
	void readConnect(pdbline const & line);
	void readHeader(pdbline const & line);
	void readTitle(pdbline const & line);
	void readCompound(pdbline const & line);
	void readSource(pdbline const & line);
	void readKeywords(pdbline const & line);
	void readExpdata(pdbline const & line);
	void readRemark(pdbline const & line);
	void readRemark350(pdbline const & line);
	void readModel(pdbline const & line);
	void readEndModel(pdbline const & line);
	void readRevDat(pdbline const & line);
	void readChainTerminator(pdbline const & line);
	void readHetname(pdbline const & line);
	void readFormula(pdbline const & line);
	void readModres(pdbline const & line);
	void readSeqres(pdbline const & line);
	void readCryst(pdbline const & line);
	void readScale(pdbline const & line);
	void readMatrix(pdbline const & line);
	void readOrigx(pdbline const & line);
	void readSite(pdbline const & line);
};


~~~

