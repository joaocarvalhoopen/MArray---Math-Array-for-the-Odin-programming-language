all:
	odin build . -out:marray_main.exe 

test:
	odin test ./marray_tests -out:marray_tests.exe 

run:
	./marray_main.exe

test_run:
	./marray_test.exe

clean:
	rm marray_main.exe
	rm marray_tests.exe
	rm marray.bin
	rm marray_test.bin


