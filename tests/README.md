# How to run tests in Linux

```
cd ..
mulle-bootstrap clean
mulle-bootstrap build -c Debug
mulle-bootstrap install `pwd`

cd build
cmake -DCMAKE_INSTALL_PREFIX="`pwd`/.." -DCMAKE_BUILD_TYPE=Debug ..
make install
cd ../tests
./run-all-tests.sh
```

