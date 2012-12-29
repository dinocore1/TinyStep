#import <tinystep/TSLinkedList.h>
#import <tinystep/TSString.h>
#include <stdio.h>

#define ASSERT(x) if(!x) { return 1; }

int main(int argv, const char** argc)
{
	int i;
	id objarray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		objarray[i] = [[TSString alloc] initWithCString:buf];
	}

	TSLinkedList* ll = [[TSLinkedList alloc] init];

	[ll add:objarray[0]];
	ASSERT([ll size] == 1)
	ASSERT([ll getAt:0] == objarray[0]);

	[ll add:objarray[1]];
	ASSERT([ll size] == 2)
	ASSERT([ll getAt:0] == objarray[0]);
	ASSERT([ll getAt:1] == objarray[1]);

	[ll set:1 obj:objarray[2]];
	ASSERT([ll size] == 2)
	ASSERT([ll getAt:0] == objarray[0]);
	ASSERT([ll getAt:1] == objarray[2]);

	[ll add:objarray[1] index:1];
	ASSERT([ll size] == 3)
	ASSERT([ll getAt:0] == objarray[0]);
	ASSERT([ll getAt:1] == objarray[1]);
	ASSERT([ll getAt:2] == objarray[2]);

	[ll remove:1];
	ASSERT([ll size] == 2)
	ASSERT([ll getAt:0] == objarray[0]);
	ASSERT([ll getAt:1] == objarray[2]);

	[ll release];

	return 0;
}