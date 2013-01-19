#import <objc/runtime.h>
#import <tinystep/TSConfig.h>

#ifdef BUILD_DEBUG
long 
TSGetNumLiveObjects();
#endif

@class TSString;
@protocol TSObject 
-(id)retain;
-(void)release;
-(id)autorelease;
-(int)retainCount;
@end

@interface TSObject <TSObject> {
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


-(TSString*) className;
-(IMP)methodForSelector:(SEL)aSelector;
-(BOOL)respondsToSelector:(SEL)aSelector;

-(unsigned int) hash;
-(BOOL) isEqual:(id) obj;
-(TSString*) toString;

@end

