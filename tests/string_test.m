#import <tinystep/TinyStep.h>


TSString* makeAString()
{
	TSString* str = [[TSString alloc] initWithCString:"hello world"];
	return [str autorelease];
}


int main(int argv, const char** argc)
{
   TSAutoreleasePool* pool = [[TSAutoreleasePool alloc] init];
   int i;
   for(i=0;i<10;i++){
   		
   		TSString* str = makeAString();
   		printf("\n%s", [str cString]);
   		
   }

   [pool dealloc];

   return 0;
} 
