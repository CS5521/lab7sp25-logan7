#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
      printf(1, "parent pid: %d; tickets should be 10\n", getpid());
        ps();
          int pid = fork();
            if (pid == 0)
                  {
                           printf(1, "first child pid: %d; tickets should be 10\n", getpid());
                                ps();
                                     exit();
                                       }
              wait();
                printf(1, "parent pid: %d; setting tickets to 20\n", getpid());
                  settickets(20);
                    ps();
                      pid = fork();
                        if (pid == 0)
                              {
                                       printf(1, "second child pid: %d; tickets should be 20\n", getpid());
                                            ps();
                                                 settickets(30);
                                                      printf(1, "second child pid: %d; tickets should now be 30\n");
                                                           ps();
                                                                pid = fork();
                                                                     if (pid == 0)
                                                                              {
                                                                                          printf(1, "child of second child pid: %d; tickets should be 30\n", getpid());
                                                                                                  ps();
                                                                                                       } else
                                                                                                                {
                                                                                                                            wait();
                                                                                                                                    exit();
                                                                                                                                         }
                                                                                                         }
                          wait();
                            exit();
}


