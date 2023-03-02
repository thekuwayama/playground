clean:
	rm -f libhello.a hello.o a.out

hello.o:
	gcc -c hello.c

libhello.a: hello.o
	ar rusv libhello.a hello.o

.PHONY: rungo
rungo: libhello.a
	go run main.go

a.out: libhello.a
	gcc main.c -L. -lhello

.PHONY: runc
runc: a.out
	./a.out
