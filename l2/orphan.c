#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
    pid_t child_pid = fork();

    if(child_pid > 0)
    {
        printf("I'm parent\n");
        printf("My pid is: %ld\n",(long)getpid());
    }
    else if(child_pid == 0)
    {
        printf("I'm child\n");
        printf("My parent id is: %ld\n",(long)getppid());
        printf("\n I'm sleeping for a second\n");
        sleep(1);
        printf("My parent id is: %ld\n",(long)getppid());
        printf("My Parent Id changed I'm an orphan now ;(");
    }
    return 0;
}
