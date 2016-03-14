
declared in [MTChainFactory](MTChainFactory.hpp.md)

~~~ { .cpp }
MTChain* IChainFactory::newInstance(char code)
{
    if (_factory) {
	++_instance_counter;
        return _factory(code); }
    return nullptr;
}
~~~

~~~ { .cpp }
MTChain* MTChainFactory::newChain(char code)
{
    if (_factory) {
        return newInstance(code); }
    return nullptr;
}
~~~

TODO  :exclamation:
~~~ { .cpp }
MTChain* MTChainFactory::createAAChainWithSequence(char code, std::string const & p_seq)
{
    if (_factory) {
	auto _ch = newInstance(code);
	// ...
        return std::move(_ch); }
    return nullptr;
}
~~~

