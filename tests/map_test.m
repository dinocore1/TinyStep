#import <tinystep/TSHashMap.h>
#import <tinystep/TSString.h>

#define ASSERT(x) if(!(x)) { return 1; }

int main(int argv, const char** argc)
{
	int i;
	id objarray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "str %d", i);
		objarray[i] = [[TSString alloc] initWithCString:buf];
	}

	TSHashMap* hm = [TSHashMap new];

	[hm put:objarray[0] value:objarray[0]];
	ASSERT([hm get:objarray[0]] == objarray[0])
	ASSERT(hm.size == 1)

	[hm put:objarray[1] value:objarray[1]];
	ASSERT([hm get:objarray[1]] == objarray[1])
	ASSERT(hm.size == 2)

	return 0;
}