#import <tinystep/TSHashMap.h>
#import <tinystep/TSString.h>
#import <tinystep/TSAutoreleasePool.h>

#define ASSERT(x) if(!(x)) { return 1; }

int main(int argv, const char** argc)
{

	TSAutoreleasePool* pool = [[TSAutoreleasePool alloc] init];
	long startobjs = TSGetNumLiveObjects();
	long endobjs = 0;
	long numleaked = 0;

	int i;
	id keyarry[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "key %d", i);
		keyarry[i] = [[[TSString alloc] initWithCString:buf] autorelease];
	}

	id valuearray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "value %d", i);
		valuearray[i] = [[[TSString alloc] initWithCString:buf] autorelease];
	}

	TSHashMap* hm = [TSHashMap new];

	[hm put:keyarry[0] value:valuearray[0]];
	ASSERT([hm get:keyarry[0]] == valuearray[0])
	ASSERT(hm.size == 1)

	[hm put:keyarry[1] value:valuearray[1]];
	ASSERT([hm get:keyarry[1]] == valuearray[1])
	ASSERT(hm.size == 2)

	[hm remove:keyarry[1]];
	ASSERT(hm.size == 1)
	ASSERT([hm get:keyarry[0]] == valuearray[0])

	[hm release];

	[pool emptyPool];

	endobjs = TSGetNumLiveObjects();
	numleaked = endobjs-startobjs;
	printf("num leaked objects %ld\n", numleaked);
	ASSERT(numleaked == 0);

	return 0;
}