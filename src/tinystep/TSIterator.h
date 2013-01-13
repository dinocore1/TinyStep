#import <tinystep/TSObject.h>

@protocol TSIterator

-(BOOL) hasNext;
-(id) next;

@optional
-(void) remove;

@end