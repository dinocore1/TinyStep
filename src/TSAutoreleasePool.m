

#import <tinystep/TSAutoreleasePool.h>


typedef struct autorelease_array_list
{
  struct autorelease_array_list *next;
  unsigned size;
  unsigned count;
  __unsafe_unretained id objects[0];
} array_list_struct;

@implementation TSAutoreleasePool


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
			NSZoneMalloc(NSDefaultMallocZone(),
			sizeof(struct autorelease_array_list) + (new_size * sizeof(id)));
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