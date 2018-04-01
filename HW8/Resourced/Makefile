###
### CS475 Fall 17
### Makefile for CUDA L8
### By Wim Bohm, Waruna Ranasinghe, and Louis Rabiet
###

OPTIONS   :=  -O3 --ptxas-options -v --gpu-architecture=sm_61 --compiler-bindir /usr/local/gcc-4.6.3/bin/gcc
EXECS :=  vecadd00 
all:$(EXECS)

clean:
	rm -f $(EXECS) *.o

timer.o : timer.cu timer.h
	nvcc $< -c -o $@ $(OPTIONS)


vecaddKernel00.o : vecaddKernel00.cu
	nvcc $< -c -o $@ $(OPTIONS)

vecadd00 : vecadd.cu vecaddKernel.h vecaddKernel00.o timer.o
	nvcc $< vecaddKernel00.o -o $@ $(LIB) timer.o $(OPTIONS)


