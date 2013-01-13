#import <tinystep/TSLinkedList.h>
#import <tinystep/TSArrayList.h>
#import <tinystep/TSString.h>
#include <stdio.h>

#define ASSERT(x) if(!(x)) { return 1; }

int testList(id<TSList> list)
{

	int i;
	id objarray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		objarray[i] = [[TSString alloc] initWithCString:buf];
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

	return 0;
}

int testSortList(id<TSList> list)
{
	[list clear];
	ASSERT([list size] == 0)
	int i;
	id objarray[10];
	for(i=0;i<10;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		[list add: [[TSString alloc] initWithCString:buf]];
	}

	TSStringComparator* strComp = [TSStringComparator new];
	TSListShuffle(list);
	TSListSort(list, strComp);

	for(i=0;i<10;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		TSString* correctString = [[TSString alloc] initWithCString:buf];
		ASSERT([strComp compareObj:correctString to:[list getAt:i]] == 0)
	}

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


	return 0;
}