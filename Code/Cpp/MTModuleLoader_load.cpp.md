
declared in [MTModuleLoader](MTModuleLoader.hpp.md)

~~~ { .cpp }


MTModule* MTModuleLoader::load(std::string const & n)
{
	std::clog << " MTModuleLoader::load : " << n << std::endl;
	// find object file
	std::string dname("./");
	std::string fname(dname); fname += n; fname += ".so";
	if (! boost::filesystem::exists(fname)) {
		fname = dname; fname += "lib"; fname += n; fname += ".so";
	}
	if (! boost::filesystem::exists(fname)) {
		dname = "./modules/";
		fname = dname; fname += n; fname += ".so";
	}
	if (! boost::filesystem::exists(fname)) {
		fname = dname; fname += "lib"; fname += n; fname += ".so";
	}

	if (! boost::filesystem::exists(fname)) {
		std::clog << "not found module: " << n << std::endl;
		return nullptr;
	}

	// load object file

	MTModule *_module = nullptr;
#ifdef Linux
        _module = load_linux(fname.c_str());
#endif
#ifdef Windows
        _module = load_win(fname.c_str());
#endif
	
	// return to caller

	return _module;
}

~~~

~~~ { .cpp }
MTModule* load_linux(const char * dllpath)
{
	void * _dll = dlopen(dllpath, RTLD_LOCAL | RTLD_LAZY);
	if (! _dll) {
		std::clog << "failed to open module: " << dllpath << std::endl;
		std::clog << " reason: " << dlerror() << std::endl;
		return nullptr;
	}

	// find address of loader function
	MTModule*(*_ldr)() = (MTModule*(*)())dlsym(_dll, "create_module");
	if (! _ldr) {
		std::clog << "failed to find entry function in module: " << dllpath << std::endl;
		std::clog << " reason: " << dlerror() << std::endl;
		return nullptr;
	}
        return _ldr();
}
~~~

