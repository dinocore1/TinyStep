#import <tinystep/TSArrayList.h>
#import <tinystep/TSMemZone.h>

#define DEFAULT_CAPACITY 32

@implementation TSArrayList

-(id) init
{
	return [self initWithCapacity:DEFAULT_CAPACITY];
}

-(id) initWithCapacity:(unsigned int) capacity
{
	self = [super init];
	if(self) {
		_objarray = TSDefaultMalloc( sizeof(id) * capacity );
		_capacity = capacity;
	}

	return self;
}

-(void) dealloc
{
	[self clear];
	if(_objarray != NULL){
		TSDefaultFree(_objarray);
		_objarray = NULL;
		_capacity = 0;
	}
	[super dealloc];
}

-(unsigned int) size
{
	return _size;
}

-(void) clear
{
	int i;
	for(i=0;i<_size;i++){
		[_objarray[i] release];
	}
	_size = 0;
}

#define GROWARRAY \
_capacity *= 2; \
_objarray = TSDefaultRealloc(_objarray, sizeof(id) * _capacity);


-(void) add:(id) obj
{
	if(_size + 1 > _capacity){
		GROWARRAY	
	}
	
	_objarray[_size] = [obj retain];
	_size++;
}

-(void) add:(id) obj index:(unsigned int) index
{
	if(_size + 1 > _capacity){
		GROWARRAY	
	}

	if(_size > 0){
		int i;
		for(i=_size-1;i>=index;i--){
			_objarray[i+1] = _objarray[i];
		}
	}
	_objarray[index] = [obj retain];
	_size++;
}

-(id) remove:(unsigned int) index
{
	id retval = nil;
	if(index >= 0 && index < _size) {
		retval = [_objarray[index] autorelease];

		int i;
		for(i=index+1;i<_size;i++){
			_objarray[i-1] = _objarray[i];
		}
		_size--;
	}

	return retval;
}

-(id) set:(unsigned int) index obj:(id)obj
{
	id retval = nil;
	if(index >= 0 && index < _size) {
		retval = [_objarray[index] autorelease];
		_objarray[index] = [obj retain];
	}

	return retval;
}

-(id) getAt:(unsigned int) index
{
	id retval = nil;
	if(index >= 0 && index < _size) {
		retval = _objarray[index];
	}
	return retval;
}

-(void) iterator:(aliterator*) it
{
	it->index = 0;
}

-(BOOL) next:(aliterator*) it obj:(id*)objptr
{
	BOOL retval = NO;
	if(it->index < _size) {
		*objptr = _objarray[it->index];
		it->index++;
		retval = YES;
	}
	return retval;
}

@end