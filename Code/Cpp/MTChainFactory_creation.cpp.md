
declared in [MTChainFactory](MTChainFactory.hpp.md)

~~~ { .cpp }
std::shared_ptr<MTChain> IChainFactory::newInstance(char code)
{
    if (_factory) {
	++_instance_counter;
        return std::shared_ptr<MTChain>(_factory(code)); }
    return nullptr;
}
~~~

~~~ { .cpp }
std::shared_ptr<MTChain> MTChainFactory::newChain(char code)
{
    if (_factory) {
        return std::move(newInstance(code)); }
    return nullptr;
}
~~~

~~~ { .cpp }
std::shared_ptr<MTChain> MTChainFactory::createAAChainWithSequence(char code, std::string const & p_seq)
{
    if (_factory) {
	auto _ch = newInstance(code);
	// ...
        return std::move(_ch); }
    return nullptr;
}
~~~

