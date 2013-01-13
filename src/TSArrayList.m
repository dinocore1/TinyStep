#import <tinystep/TSArrayList.h>
#import <tinystep/TSMemZone.h>
#import <tinystep/TSString.h>

@interface TSArrayListIterator : TSObject<TSListIterator> {
	TSArrayList* _list;
	unsigned int _index;
}

-(id) initWithList:(TSArrayList*)list index:(unsigned int)index;

@end

@implementation TSArrayListIterator

-(id) initWithList:(TSArrayList*)list index:(unsigned int)index
{
	self = [super init];
	if(self){
		_list = [list retain];
		_index = index;
	}
	return self;
}

-(BOOL) hasNext
{
	return _index < [_list size];
}

-(id) next
{
	return [_list getAt:_index++];
}

-(void) remove
{
	[_list remove:_index++];
}

-(BOOL) hasPrevious
{
	return _index - 1 >= 0;
}

-(id) previous
{
	return [_list getAt:--_index];
}

-(void) dealloc
{
	RELEASE(_list);
	[super dealloc];
}

@end

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

-(id<TSListIterator>) iterator
{
	TSArrayListIterator* retval = [[TSArrayListIterator alloc]
									initWithList:self index:0];
	return [retval autorelease];
}

-(TSString*) toString
{
	TSString* retval = nil;
	TSStringBuffer* buf = [TSStringBuffer new];
	[buf appendCString:"[ "];
	id<TSIterator> it = [self iterator];
	while([it hasNext]){
		id obj = [it next];
		[buf appendCString:[[obj toString] cString]];
		[buf appendCString:", "];
	}
	[buf appendCString:"]"];
	retval = [buf toString];
	[buf release];
	return [retval autorelease];
}

@end