
declared in [MTResidueAA](MTResidueAA.hpp.md)

~~~ { .cpp }
std::string MTResidueAA::oneLetterCode() const
{
        if (isModified()) {
                return MTResidueAA::translate3to1Code(_modname);                
        } else {
                return MTResidueAA::translate3to1Code(_name);
        }
}
~~~

