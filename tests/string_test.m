#import <tinystep/TSString.h>

int main(int argv, const char** argc)
{
   TSString* str = [[TSString alloc] initWithCString:"hello world"];
   printf("%s", [str cString]);
} 
