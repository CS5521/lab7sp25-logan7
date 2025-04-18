#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int loops = atoi(argv[1]);
  int tickets[argc - 2];
  int pid;

  int i;
  for(i = 2; i < argc; i++)
  {
    tickets[i-2] = atoi(argv[i]);
  }

  for(i = 0; i < argc-2; i++)
  {
    pid = fork();

    if(pid == 0)
    {
      settickets(tickets[i]);
      while(1);
    }
    else
    {
      for(i = 0; i < loops; i++)
      {
        ps();
        sleep(3);
      }
      for(i = 0; i < argc-2; i++)
      {
        kill(pid);
        wait();
      }
      exit();
    }
  }
  return 0;
}
