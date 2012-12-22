
#import <objc/Object.h>

@interface TSObject {
	Class isa;
}


+(Class)class;
+(Class)superclass;
+alloc;

-self;
-(Class)class;
-(Class)superclass;
-(id)init;
-(void)dealloc;

-(id)retain;
-(void)release;
-(id)autorelease;
-(int)retainCount;

-(IMP)methodForSelector:(SEL)aSelector;

@end

