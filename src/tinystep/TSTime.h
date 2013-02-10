

#include <time.h>

#define NSEC_PER_SECOND 1000000000.0

TSEXPORT double
TSTimeSpecToDouble(struct timespec ts);

TSEXPORT struct timespec
TSDoubleToTimeSpec(double seconds);
