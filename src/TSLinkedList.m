
#import <tinystep/TSLinkedList.h>

typedef struct TSLinkedListNode {
	struct TSLinkedListNode* _prev;
	struct TSLinkedListNode* _next;
	id _data;
} TSLinkedListNode;


@implementation TSLinkedList

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

-(void)add:(id) obj
{
	TSLinkedListNode* node = malloc(sizeof(TSLinkedListNode));
	memset(node, 0, sizeof(TSLinkedListNode));
	node->_data = [obj retain];
	node->_prev = _end;
	_end->_next = node;
	_end = node;
	if(_size == 0){
		_start = node;
	}
}

static inline
TSLinkedListNode* find(TSLinkedList* list, unsigned int index)
{
	TSLinkedListNode* retval = list->_start;
	for(int i=0;i<index;i++) {
		retval = retval->_next;
	}
	return retval;
}

-(id) remove:(unsigned int)index
{
	TSLinkedListNode* n = find(self, index);
	id retval = [n->_data autorelease];

	TSLinkedListNode* prev = n->_prev;
	TSLinkedListNode* next = n->_next;

	prev->_next = next;
	next->_prev = prev;

	free(n);

	return retval;
}

@end