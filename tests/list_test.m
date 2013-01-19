#import <tinystep/TSLinkedList.h>
#import <tinystep/TSArrayList.h>
#import <tinystep/TSString.h>
#import <tinystep/TSAutoreleasePool.h>
#include <stdio.h>

#define ASSERT(x) if(!(x)) { return 1; }

int testList(id<TSList> list)
{
	long startobjs = TSGetNumLiveObjects();
	TSAutoreleasePool* pool = [[TSAutoreleasePool alloc] init];
	


	int i;
	id objarray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		objarray[i] = [[[TSString alloc] initWithCString:buf] autorelease];
	}

	[list add:objarray[0]];
	ASSERT([list size] == 1)
	ASSERT([list getAt:0] == objarray[0])

	[list add:objarray[1]];
	ASSERT([list size] == 2)
	ASSERT([list getAt:0] == objarray[0])
	ASSERT([list getAt:1] == objarray[1])

	[list set:1 obj:objarray[2]];
	ASSERT([list size] == 2)
	ASSERT([list getAt:0] == objarray[0])
	ASSERT([list getAt:1] == objarray[2])

	[list add:objarray[1] index:1];
	ASSERT([list size] == 3)
	ASSERT([list getAt:0] == objarray[0])
	ASSERT([list getAt:1] == objarray[1])
	ASSERT([list getAt:2] == objarray[2])

	[list remove:1];
	ASSERT([list size] == 2)
	ASSERT([list getAt:0] == objarray[0])
	ASSERT([list getAt:1] == objarray[2])

	[list clear];

	[pool release];

	long endobjs = TSGetNumLiveObjects();
	long numleaked = endobjs-startobjs;
	printf("num leaked objects %d\n", numleaked);
	ASSERT(numleaked == 0);

	return 0;
}

int testSortList(id<TSList> list)
{
	long startobjs = TSGetNumLiveObjects();
	TSAutoreleasePool* pool = [[TSAutoreleasePool alloc] init];

	[list clear];
	ASSERT([list size] == 0)
	int i;
	for(i=0;i<10;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		TSString* str = [[TSString alloc] initWithCString:buf];
		[list add: str];
		[str release];
	}

	TSStringComparator* strComp = [TSStringComparator new];
	TSListShuffle(list);
	TSListSort(list, strComp);

	for(i=0;i<10;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		TSString* correctString = [[TSString alloc] initWithCString:buf];
		ASSERT([strComp compareObj:correctString to:[list getAt:i]] == 0)
		[correctString release];
	}

	[strComp release];

	[list clear];

	[pool release];

	long endobjs = TSGetNumLiveObjects();
	long numleaked = endobjs-startobjs;
	printf("num leaked objects %d\n", numleaked);
	ASSERT(numleaked == 0);

	return 0;

}

int main(int argv, const char** argc)
{
	TSArrayList* al = [TSArrayList new];
	ASSERT(testList(al) == 0);
	ASSERT(testSortList(al) == 0)
	[al release];

	TSLinkedList* ll = [[TSLinkedList alloc] init];
	ASSERT(testList(ll) == 0);
	ASSERT(testSortList(ll) == 0)
	[ll release];

	printf("Num live objs %d\n", TSGetNumLiveObjects());

	return 0;
}