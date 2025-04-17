#include "param.h"

#ifndef _PSTAT_H_
#define _PSTAT_H_

typedef struct {
  int inuse;        // whether this slot of the process table is in use (1 or 0)
  int tickets;      // the number of tickets this process has
  int pid;          // the PID of each process
  int ticks;        // the number of ticks each process has accumulated
  char name[16];    // process name
  char state;       // 'E', 'R', 'A', 'S', 'Z' (embryo, running, runnable, sleeping, zombie)
} pstat_t;

typedef pstat_t pstatTable[NPROC];

void getpinfo(pstatTable *);

#endif // _PSTAT_H_
