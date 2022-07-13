
#-wall turns on gcc warnings
#-c will only compile a .o file
#-g will use debug mode


# create the object files for game


main : main.o mpm.o
	gcc -g -Wall main.o mpm.o -o main

main.o : mpm.c 
	gcc -Wall -g -c main.c

mpm.o : mpm.c 
	gcc -Wall -g -c mpm.c

so : mpm.c 
	 cc -fPIC -shared -o mpm.so mpm.c


debug :

	lldb ./main 

clean : 
	rm -f mpm.o mpm.so main.o