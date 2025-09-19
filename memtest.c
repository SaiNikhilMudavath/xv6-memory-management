
#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

char buf[8192];
char name[3];
char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };
int stdout = 1;
#define TOTAL_MEMORY (1 << 20) + (1 << 18)

void
mem(void)
{
	int pid;
	int size = 4096;
	//Fill up the physical memory
	for(int j=0;j<200;++j){
		char *memory = (char*) malloc(size); //4kb;
		memory[0] = (char) (65);
	}
	pid = fork();

	if(pid > 0) {
		for(int j=0;j<100;++j){
			char *memory = (char*) malloc(size); //4kb;
			if (memory == 0) goto failed;
			for(int k=0;k<size;++k){
				memory[k] = (char)(65+(k%26));
			}
			for(int k=0;k<size;++k){
				if(memory[k] != (char)(65+(k%26))) goto failed;
			}
		}
		printf(1,"Parent alloc-ed:\n");
		wait();
	}


	else if(pid < 0){ 
		printf(1, "Fork Failed\n");
	}

	else {
		sleep(100);
		for(int j=0;j<308;++j){
			char *memory = (char*) malloc(size); //4kb;
			if (memory == 0) goto failed;
			for(int k=0;k<size;++k){
				memory[k] = (char)(65+(k%26));
			}
			for(int k=0;k<size;++k){
				if(memory[k] != (char)(65+(k%26))) goto failed;
			}
		}
		printf(1,"Child alloc-ed\n");
	}
	if(pid==0)
		printf(1, "Memtest Passed\n");
	exit();
	
failed:
	printf(1, "Memtest Failed\n");
	exit();
}

int
main(int argc, char *argv[])
{
	mem();
	exit();
	return 0;
}