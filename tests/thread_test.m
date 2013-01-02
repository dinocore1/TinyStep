#import <tinystep/TSThread.h>


@interface FunctionObj : TSObject {

}

@end

@implementation FunctionObj

-(void) threadstart
{
	printf("hello from thread\n");
}

@end

int main(int argv, const char** argc)
{
	//[TSThread currentThread];
	FunctionObj* obj = [FunctionObj new];

	TSThread* thread1 = [[TSThread alloc]
							initWithTarget:obj 
							selector:@selector(threadstart)
							object: nil];

	[thread1 start];

	[thread1 join];

	printf("after join\n");

	return 0;
}