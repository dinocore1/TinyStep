#import <objc/runtime.h>
#import <tinystep/TSConfig.h>

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



-(IMP)methodForSelector:(SEL)aSelector;

-(unsigned int) hash;
-(BOOL) isEqual:(id) obj;

@end

