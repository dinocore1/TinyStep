#import <objc/runtime.h>
#import <tinystep/TSConfig.h>

@interface TSObject {
	Class isa;
}


+(Class)class;
+(Class)superclass;
+alloc;
+(id)new;

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

