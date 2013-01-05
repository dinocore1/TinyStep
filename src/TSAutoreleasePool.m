

#import <tinystep/TSAutoreleasePool.h>
#import <tinystep/TSMemZone.h>
#import <tinystep/TSThread.h>

#define BEGINNING_POOL_SIZE 32

typedef struct autorelease_array_list
{
  struct autorelease_array_list *next;
  unsigned size;
  unsigned count;
  __unsafe_unretained id objects[0];
} array_list_struct;

#define GETCURRENTPOOL \
	TSThread *t = [TSThread currentThread]; \
	TSAutoreleasePool *pool; \
	pool = t->_autorelease_thread_vars.current_pool; \
	if(pool == nil){ \
		pool = [[TSAutoreleasePool alloc] init]; \
	} 


@implementation TSAutoreleasePool

+(id) currentPool
{
	GETCURRENTPOOL
	return pool;
}

-(id)init
{
	self = [super init];
	if(self) {
		_addImp = (void (*)(id, SEL, id)) [self methodForSelector: @selector(addObject:)];

		_released = TSDefaultMalloc( sizeof(array_list_struct) + (sizeof(id) * BEGINNING_POOL_SIZE)  );
	      /* Currently no NEXT array in the list, so NEXT == NULL. */
		_released->next = NULL;
		_released->size = BEGINNING_POOL_SIZE;
		_released->count = 0;
		_released_count = 0;

		_released_head = _released;

		TSThread *t = [TSThread currentThread];
		_parent = t->_autorelease_thread_vars.current_pool;
		if(_parent != nil) {
			_parent->_child = self;
		} 

		t->_autorelease_thread_vars.current_pool = self;
	}

	return self;
}

+(void) addObject:(id)anObj
{
	GETCURRENTPOOL
	//call the addObject method - this should be faster than sending a message
	(*pool->_addImp)(pool, @selector(addObject:), anObj);
}

-(void) addObject: (id)anObj
{

	/* Get a new array for the list, if the current one is full. */
	while (_released->count == _released->size) {
	    if (_released->next) {
	    	/* There is an already-allocated one in the chain; use it. */
	    	_released = _released->next;
		} else {
			/* We are at the end of the chain, and need to allocate a new one. */
			struct autorelease_array_list *new_released;
			unsigned new_size = _released->size * 2;

			new_released = (struct autorelease_array_list*)
			TSDefaultMalloc(sizeof(struct autorelease_array_list) + (new_size * sizeof(id)));
			new_released->next = NULL;
			new_released->size = new_size;
			new_released->count = 0;
			_released->next = new_released;
			_released = new_released;
		}
    }

	/* Put the object at the end of the list. */
	_released->objects[_released->count] = anObj;
	(_released->count)++;

	/* Keep track of the total number of objects autoreleased in this pool */
	_released_count++;
}

-(void) emptyPool
{
	unsigned int i;
	/* 
	 * release the child pools first, starting at the end of the child list
	 * working backward. We could do this with recusion, but if there are 
	 * lots of child pools, we might run into stack overflow
	 */ 
	if(nil != _child) {
		TSAutoreleasePool* pool = _child;

		/* Find other end of linked list ... oldest child.
		*/
		while (nil != pool->_child) {
			pool = pool->_child;
		}
		/* Deallocate the children in the list.
		*/
		while (pool != self) {
			pool = pool->_parent;
			[pool->_child dealloc];
		}
	}

	Class classes[16];
	IMP imps[16];

	for (i = 0; i < 16; i++) {
		classes[i] = 0;
		imps[i] = 0;
	}
	array_list_struct* released = _released_head;
    while (released != 0) {
		id* objects = (id*)(released->objects);

		for(i = 0; i < released->count; i++){
			id anObject;
			Class c;
			unsigned hash;

			anObject = objects[i];
			objects[i] = nil;
			
			c = object_getClass(anObject);
			if (c == 0) {
				//[NSException raise: NSInternalInconsistencyException format: @"nul class for object in autorelease pool"];
			}

			/*
			 * We use a hash table to speed up making calls to release. 
			 */

			hash = (((unsigned)(uintptr_t)c) >> 3) & 0x0f;
			if (classes[hash] != c) {
				/* If anObject was an instance, c is it's class.
				* If anObject was a class, c is its metaclass.
				* Either way, we should get the appropriate pointer.
				* If anObject is a proxy to something,
				* the +instanceMethodForSelector: and -methodForSelector:
				* methods may not exist, but this will return the
				* address of the forwarding method if necessary.
				*/
				imps[hash] = class_getMethodImplementation(c, @selector(release));
				classes[hash] = c;
			}
			(imps[hash])(anObject, @selector(release));
		}
		_released_count -= released->count;
		released->count = 0;
		released = released->next;
	}

	

}

-(void)dealloc
{
	[self emptyPool];

	array_list_struct* a;
	for(a = _released_head; a;){
		void* n = a->next;
		TSDefaultFree(a);
		a = n;
	}
	_released = _released_head = nil;

	TSThread *t = [TSThread currentThread];
	if(t->_autorelease_thread_vars.current_pool == self) {
    	t->_autorelease_thread_vars.current_pool = _parent;
    }
	if(_parent != nil) {
		_parent->_child = nil;
		_parent = nil;
	}

	[super dealloc];
}

-(void)release
{
	[self dealloc];
}

//retains, and autorelease dont do anything
-(id)retain
{
}

-(id)autorelease
{
	return self;
}

@end