
#import <tinystep/TSLinkedList.h>
#import <tinystep/TSMemZone.h>
#import <string.h>

typedef struct TSLinkedListNode {
	struct TSLinkedListNode* _prev;
	struct TSLinkedListNode* _next;
	__unsafe_unretained id _data;
} TSLinkedListNode;


@implementation TSLinkedList

static inline
TSLinkedListNode* find(TSLinkedList* list, unsigned int index)
{
	int i;
	TSLinkedListNode* retval = list->_start;
	for(i=0;i<index;i++) {
		retval = retval->_next;
	}
	return retval;
}

-(id) init
{
	self = [super init];
	if(self) {
		
	}
	return self;
}

-(unsigned int) size
{
	return _size;
}

-(void) clear
{
	TSLinkedListNode* node = _start;
	TSLinkedListNode* temp = NULL;
	while(node != NULL) {
		temp = node;
		node = node->_next;
		[temp->_data release];
		TSDefaultFree(temp);
	}
	_start = NULL;
	_end = NULL;
	_size = 0;
}

-(void)add:(id) obj
{
	TSLinkedListNode* node = TSDefaultMalloc(sizeof(TSLinkedListNode));
	memset(node, 0, sizeof(TSLinkedListNode));
	node->_data = [obj retain];
	node->_prev = _end;

	if(_end != NULL) {
		_end->_next = node;
	}
	_end = node;
	if(_size == 0){
		_start = node;
	}

	_size++;
}

-(void) add:(id) obj index:(unsigned int) index
{
	TSLinkedListNode* newnode = TSDefaultMalloc(sizeof(TSLinkedListNode));
	memset(newnode, 0, sizeof(TSLinkedListNode));
	newnode->_data = [obj retain];

	TSLinkedListNode* n = find(self, index);

	newnode->_next = n;
	if(n != NULL){
		n->_prev->_next = newnode;
		newnode->_prev = n->_prev;
		n->_prev = newnode;
	}
	
	if(index == 0) {
		_start = newnode;
	}

	if(index == _size) {
		_end = newnode;
	}

	_size++;
}

-(id) remove:(unsigned int)index
{
	id retval = nil;
	if(index >=0 && index < _size) {
		TSLinkedListNode* n = find(self, index);
		retval = [n->_data autorelease];

		TSLinkedListNode* prev = n->_prev;
		TSLinkedListNode* next = n->_next;

		prev->_next = next;
		next->_prev = prev;

		TSDefaultFree(n);

		_size--;
	}

	return retval;

}

-(id) set:(unsigned int) index obj:(id) obj
{
	id retval = nil;
	TSLinkedListNode* n = find(self, index);
	if(n != NULL) {
		retval = [n->_data autorelease];
		n->_data = [obj retain];
	} else {
		TSLinkedListNode* newnode = TSDefaultMalloc(sizeof(TSLinkedListNode));
		memset(newnode, 0, sizeof(TSLinkedListNode));
		newnode->_data = [obj retain];
	}
	return retval;
}

-(id) getAt:(unsigned int) index
{
	id retval = nil;
	TSLinkedListNode* n = find(self, index);
	if(n != NULL){
		retval = n->_data;
	}
	return retval;
}

-(void)dealloc
{
	[self clear];
	[super dealloc];
}

@end