#!/bin/bash

for HPP in `bash ../../../gitalk/utils/find_hpp.sh ../../Code/Cpp/libmoltalk.md`; do
  bash ../../../gitalk/utils/make_hpp.sh ${HPP}
  bash ../../../gitalk/utils/make_cpp.sh ${HPP}
done


cd tests

bash ../../../../gitalk/utils/make_test.sh  ../../../Code/Cpp/tests/utlibmoltalk.md 

cd ..
