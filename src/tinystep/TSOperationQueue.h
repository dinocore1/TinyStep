#import <tinystep/TSCondition.h>
#import <tinystep/TSLinkedList.h>
#import <tinystep/TSArrayList.h>

@protocol Runnable <TSObject>
-(id)run;
@end

@protocol Future <TSObject>
-(id) get;
-(BOOL) isDone;
@end

@interface TSOperationQueue : TSObject {
	TSLinkedList* _queue;
	TSCondition* _lock;
	int _maxConcurrent;
	TSArrayList* _workerThreads;
	int _status;
}

-(id<Future>) post:(id<Runnable>) task;

-(void) setMaxConcurrent:(int) maxConcurrent;

-(void) start;
-(void) stop;

@end