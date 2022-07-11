
#-wall turns on gcc warnings
#-c will only compile a .o file
#-g will use debug mode


# create the object files for game
mpm.o : mpm.c 
	gcc -wall -c mpm.c


so : mpm.c 
	 cc -fPIC -shared -o mpm.so mpm.c

clean : 
	rm -f mpm.o mpm.so