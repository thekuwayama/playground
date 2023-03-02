clean:
	rm libhello.a hello.o

libhello.a:
	gcc -c hello.c
	ar rusv libhello.a hello.o

.PHONY: run
run: libhello.a
	@go run main.go
