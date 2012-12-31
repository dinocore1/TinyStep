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

int main(int argv, const char** argc)
{
	TSLinkedList* ll = [[TSLinkedList alloc] init];
	ASSERT(testList(ll) == 0);
	[ll release];

	TSArrayList* al = [TSArrayList new];
	ASSERT(testList(al) == 0);
	[al release];

	return 0;
}