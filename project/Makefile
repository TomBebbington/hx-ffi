all: configure build-32 build-64
configure:
	mkdir -p libffi/bin
	cd libffi; ./configure --prefix $(realpath ./libffi/bin)
build-lib: configure
	cd libffi; make; make install; cp -rf bin/lib/libffi*/include bin/include
build-32: build-lib
	haxelib run hxcpp Build.xml
build-64: build-lib
	haxelib run hxcpp Build.xml -DHXCPP_M64
clean:
	rm -r obj