#import <tinystep/TinyStep.h>

@interface TestRunnable : TSObject<Runnable> {
	int _taskNum;
}

-(id) initWithNum:(int) num;

@end

@implementation TestRunnable

-(id) initWithNum:(int) num
{
	self = [super init];
	if(self){
		_taskNum = num;
	}
	return self;
}

-(id) run
{
	printf("executing task %d\n", _taskNum);
	return nil;
}

@end

int main(int argv, const char** argc)
{

	TSOperationQueue* queue = [TSOperationQueue new];
	[queue start];


	id<Future> f1 = [queue post:[[TestRunnable alloc] initWithNum:0]];
	id<Future> f2 = [queue post:[[TestRunnable alloc] initWithNum:1]];

	while(!f1.isDone || !f2.isDone){
		printf("waiting for tasks to complete\n");
		sleep(1);
	}

	//[queue stop];


	f1 = [queue postWithDelay:[[TestRunnable alloc] initWithNum:5] delay:3.5];
	sleep(1);
	[queue post:[[TestRunnable alloc] initWithNum:2]];
	[queue postWithDelay:[[TestRunnable alloc] initWithNum:4] delay:1];
	[queue post:[[TestRunnable alloc] initWithNum:3]];
	while(!f1.isDone) {
		printf("waiting for tasks to complete\n");
		sleep(1);
	}

	[queue stop];

	return 0;
}