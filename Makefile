TOOLKIT = /home/bgrieger/SUN/FORTRAN/N0066
FC      = gfortran -O2

bin/quack : for/quack.f \
            for/help_data.f \
            tmp/setup_quack.o \
            tmp/ixiy2ipos2.o \
            tmp/recquack.o \
            tmp/rplnorm2.o \
            tmp/recplquack.o \
            tmp/quincquad.o \
            tmp/quinclat.o \
            tmp/latquinc.o
	$(FC) -o bin/quack \
	    for/quack.f \
	    tmp/setup_quack.o \
	    tmp/ixiy2ipos2.o \
	    tmp/recquack.o \
	    tmp/rplnorm2.o \
	    tmp/recplquack.o \
	    tmp/quincquad.o \
	    tmp/quinclat.o \
	    tmp/latquinc.o \
	    $(TOOLKIT)/lib/spicelib.a \
	    $(TOOLKIT)/lib/support.a

tmp/setup_quack.o : for/setup_quack.f for/quack_dim.inc
	cd tmp; $(FC) -c ../for/setup_quack.f

tmp/ixiy2ipos2.o : for/ixiy2ipos2.f for/quack_dim.inc
	cd tmp; $(FC) -c ../for/ixiy2ipos2.f

tmp/recquack.o : for/recquack.f for/quack_dim.inc
	cd tmp; $(FC) -c ../for/recquack.f

tmp/rplnorm2.o : for/rplnorm2.f for/quack_dim.inc
	cd tmp; $(FC) -c ../for/rplnorm2.f

tmp/recplquack.o : for/recplquack.f for/quack_dim.inc
	cd tmp; $(FC) -c ../for/recplquack.f

tmp/quincquad.o : for/quincquad.f
	cd tmp; $(FC) -c ../for/quincquad.f

tmp/quinclat.o : for/quinclat.f for/reverse_quinc_data.f
	cd tmp; $(FC) -c ../for/quinclat.f

tmp/latquinc.o : for/latquinc.f for/forward_quinc_data.f
	cd tmp; $(FC) -c ../for/latquinc.f

clean :
	rm tmp/*.o
