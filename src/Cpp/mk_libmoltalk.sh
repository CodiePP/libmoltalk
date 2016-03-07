#!/bin/sh

for HPP in `../../../gitalk/utils/find_hpp.sh ../../Code/Cpp/libmoltalk.md`; do
  ../../../gitalk/utils/make_hpp.sh ${HPP}
  ../../../gitalk/utils/make_cpp.sh ${HPP}
done


cd tests

../../../../gitalk/utils/make_test.sh  ../../../Code/Cpp/tests/utlibmoltalk.md 

cd ..
