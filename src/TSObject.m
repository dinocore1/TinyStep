
#import <tinystep/TSObject.h>
#import <objc/runtime.h>
#import <stdlib.h>
#import <string.h>

#ifdef ALIGN
#undef ALIGN
#endif
#if defined(__GNUC__) && __GNUC__ < 4
#define __builtin_offsetof(s, f) (uintptr_t)(&(((s*)0)->f))
#endif
#define alignof(type) __builtin_offsetof(struct { const char c; type member; }, member)
#define	ALIGN alignof(double)

/*
 *	Define a structure to hold information that is held locally
 *	(before the start) in each object.
 */
typedef struct obj_layout_unpadded {
    unsigned int	retained;
} unp;
#define	UNP sizeof(unp)

/*
 *	Now do the REAL version - using the other version to determine
 *	what padding (if any) is required to get the alignment of the
 *	structure correct.
 */
struct obj_layout {
    char	padding[ALIGN - ((UNP % ALIGN) ? (UNP % ALIGN) : ALIGN)];
    unsigned int	retained;
} obj_layout;
typedef	struct obj_layout *obj;

static inline
id TSAllocateObject(Class aClass, size_t extrabytes) {
	int size = class_getInstanceSize(aClass) + extrabytes + sizeof(obj_layout);
	id newobj = malloc(size);
	if(newobj) {
		memset(newobj, 0, size);
		newobj = (id)&((obj)newobj)[1];
		object_setClass(newobj, aClass);
	}
	return newobj;
}

static inline
void TSDeallocObject(id anObject) {
	object_setClass(anObject, (Class)(void*)0xdeadface);
	obj o = &((obj)anObject)[-1];
	free(o);
}

static inline
void TSIncrementRefCount(id anObject) {
	((obj)anObject)[-1].retained++;
}

static inline
BOOL TSDecrementRefCountWasZero(id anObject) {
	if (((obj)anObject)[-1].retained == 0){
		return YES;
	} else {
		((obj)anObject)[-1].retained--;
		return NO;
	}
}

static inline
unsigned int TSRefCount(id anObject) {
	return ((obj)anObject)[-1].retained;
}

static id autorelease_class = nil;
static SEL autorelease_sel;
static IMP autorelease_imp;

@implementation TSObject

+(void) initialize
{
	if(self == [TSObject class]) {
		autorelease_class = [NSAutoreleasePool class];
		autorelease_sel = @selector(addObject:);
		autorelease_imp = [autorelease_class methodForSelector: autorelease_sel];

	}
}

+(Class)class
{
  return self;
}

+(Class)superclass 
{
   return class_getSuperclass(self);
}

+alloc
{
	return TSAllocateObject([self class], 0);
}

-self 
{
   return self;
}


-(Class)class 
{
	return object_getClass(self);
}


-(Class)superclass 
{
	return class_getSuperclass(object_getClass(self));
}

-(void)dealloc
{
	TSDeallocObject(self);
}

-(id)init
{
  return self;
}

-(id)retain
{
	TSIncrementRefCount(self);
	return self;
}

-(void)release
{
	if (TSDecrementRefCountWasZero(self)) {
		[self dealloc];
	}
}

-(id)autorelease
{
	(*autorelease_imp)(autorelease_class, autorelease_sel, self);
	return self;
}

-(int)retainCount
{
	return TSRefCount(self);
}

- (IMP) methodForSelector: (SEL)aSelector
{
  /*
   *    If 'self' is an instance, object_getClass() will get the class,
   *    and class_getMethodImplementation() will get the instance method.
   *    If 'self' is a class, object_getClass() will get the meta-class,
   *    and class_getMethodImplementation() will get the class method.
   */
   return class_getMethodImplementation(object_getClass(self), aSelector);
}

@end

