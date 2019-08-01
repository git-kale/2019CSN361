#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
    pid_t child_pid = fork();

    if(child_pid > 0)
    {
        printf("Parent : Whoosh! I'm going to sleep for next 5 seconds\n");
        sleep(1);
        printf("zzz\n");
    }
    else
    {
        printf("Child : I'm exitting here, See ya.\n");
        exit(0);
    }
    return 0;
}

