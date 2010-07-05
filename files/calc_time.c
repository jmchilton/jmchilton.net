#include <sys/time.h>
#define MILLION 1000000.0

struct timeval start_time;
struct timeval end_time;
long start_calc()
{
  gettimeofday( &start_time, (void *) 0 );
  return 0;
}
double end_calc()
{
  gettimeofday( &end_time, (void *) 0) ;
  return ((double)end_time.tv_sec + (double)end_time.tv_usec / MILLION)
   - ((double)start_time.tv_sec + (double)start_time.tv_usec / MILLION);
}
