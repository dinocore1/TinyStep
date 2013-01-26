#import <tinystep/TinyStep.h>

#define ASSERT(x) if(!(x)) { return 1; }

int main(int argv, const char** argc)
{
	TSString* pathname = [[TSString alloc] initWithCString:"badfile"];
	
	TSFile* f = [[TSFile alloc] initWithPath:pathname];
	ASSERT([f exists] == NO)
	[f release];
	[pathname release];



	pathname = [[TSString alloc] initWithCString:"file_test"];
	f = [[TSFile alloc] initWithPath:pathname];
	ASSERT([f exists] == YES)

	ASSERT([f isFile] == YES)
	ASSERT([f isDirectory] == NO)
	[f release];
	[pathname release];

	return 0;
}