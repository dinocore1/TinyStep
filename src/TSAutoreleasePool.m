

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
	TSThread *t = TSCurrentThread(); \
	TSAutoreleasePool *pool; \
	pool = t->_autorelease_thread_vars.current_pool; \
	if(pool == nil){ \
		pool = t->_autorelease_thread_vars.current_pool = [[TSAutoreleasePool alloc] init]; \
	} 


@implementation TSAutoreleasePool

+(id) currentPool
{
	GETCURRENTPOOL
	return pool;
}

-(id)init
{
	_addImp = (void (*)(id, SEL, id)) [self methodForSelector: @selector(addObject:)];

	_released = TSDefaultMalloc( sizeof(array_list_struct) + (sizeof(id) * BEGINNING_POOL_SIZE)  );
      /* Currently no NEXT array in the list, so NEXT == NULL. */
	_released->next = NULL;
	_released->size = BEGINNING_POOL_SIZE;
	_released->count = 0;
	_released_count = 0;

	_released_head = _released;
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

@end