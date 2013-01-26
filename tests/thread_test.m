#import <tinystep/TinyStep.h>


static TSCondition* condition;

@interface FunctionObj : TSObject {

}

@end

@implementation FunctionObj

-(void) threadstart
{
	printf("hello from thread\n");
	[condition lock];
	[condition signal];
	[condition unlock];
}

@end

int main(int argv, const char** argc)
{
	condition = [TSCondition new];
	FunctionObj* obj = [FunctionObj new];

	TSThread* thread1 = [[TSThread alloc]
							initWithTarget:obj 
							selector:@selector(threadstart)
							object: nil];

	[thread1 start];

	[condition lock];
	[condition wait];
	[condition unlock];

	[thread1 join];

	printf("after join\n");

	return 0;
}