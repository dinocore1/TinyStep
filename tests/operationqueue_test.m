#import <tinystep/TinyStep.h>

@interface TestRunnable : TSObject<Runnable> {

}

@end

@implementation TestRunnable

-(id) run
{
	TSString* str = [[TSString alloc] initWithCString:"hi from task"];
	printf("%s\n", str.cString );
	return nil;
}

@end

int main(int argv, const char** argc)
{

	TSOperationQueue* queue = [TSOperationQueue new];
	[queue start];

	id<Future> f1 = [queue post:[TestRunnable new]];
	id<Future> f2 = [queue post:[TestRunnable new]];

	while(!f1.isDone || !f2.isDone){
		printf("waiting for tasks to complete");
		sleep(1);
	}

	[queue stop];

	return 0;
}