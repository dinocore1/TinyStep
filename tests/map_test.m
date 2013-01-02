#import <tinystep/TSHashMap.h>
#import <tinystep/TSString.h>

#define ASSERT(x) if(!(x)) { return 1; }

int main(int argv, const char** argc)
{
	int i;
	id keyarry[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "key %d", i);
		keyarry[i] = [[TSString alloc] initWithCString:buf];
	}

	id valuearray[5];
	for(i=0;i<5;i++){
		char buf[10];
		sprintf(buf, "value %d", i);
		valuearray[i] = [[TSString alloc] initWithCString:buf];
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

	return 0;
}