#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  
  if(argc < 2)
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  }
  if(atoi(argv[1]) < 10)
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  }
  if(argc > 9)
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  }

  int loops = atoi(argv[1]);
  int tickets[argc - 2];
  int pids[argc - 2];

  int i;
  for(i = 2; i < argc; i++)
  {
    tickets[i-2] = atoi(argv[i]);
  }

  for(i = 0; i < argc-2; i++)
  {
    pids[i] = fork();

    if(pids[i] == 0)
    {
      settickets(tickets[i]);
      for(;;)
      {
          continue;
      }
    }  
  }
  for(i = 0; i < loops; i++)
  {
    ps();
    sleep(3);
  }
  for(i = 0; i < argc-2; i++)
  {
    kill(pids[i]);
    wait();
  }
  exit();
  return 0;
}
