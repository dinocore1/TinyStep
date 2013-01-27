/*
    Copyright 2013 Paul Soucy

    This file is part of TinyStep.

    TinyStep is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TinyStep is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser Public License
    along with TinyStep.  If not, see <http://www.gnu.org/licenses/>.
*/



#import <tinystep/TSHashMap.h>
#import <tinystep/TSMemZone.h>
#import <tinystep/TSArrayList.h>
#import <tinystep/TSKeyValuePair.h>

#define DEFAULT_TABLESIZE 32

@implementation TSHashMap

static unsigned int inline 
betterhash(unsigned int key){
	/* Robert Jenkins' 32 bit Mix Function */
	key += (key << 12);
	key ^= (key >> 22);
	key += (key << 4);
	key ^= (key >> 9);
	key += (key << 10);
	key ^= (key >> 2);
	key += (key << 7);
	key ^= (key >> 12);

	/* Knuth's Multiplicative Method */
	key = (key >> 3) * 2654435761;

	return key;
}

-(id) init
{
	self = [super init];
	if(self) {
		_table = TSDefaultMalloc( sizeof(TSArrayList*) * DEFAULT_TABLESIZE );
		_tableSize = DEFAULT_TABLESIZE;
		int i;
		for(i=0;i<_tableSize;i++){
			_table[i] = [TSArrayList new];
		}
	}
	return self;
}

-(void) dealloc
{
	int i;
	for(i=0;i<_tableSize;i++){
		TSArrayList* list = _table[i];
		[list clear];
		[list release];
	}
	TSDefaultFree(_table);
	[super dealloc];
}

-(unsigned int) size
{
	return _size;
}

-(void) clear
{
	int i;
	for(i=0;i<_tableSize;i++){
		TSArrayList* list = _table[i];
		[list clear];
	}
	_size = 0;
}

-(id) put:(id)key value:(id)value
{
	id retval = nil;
	unsigned int index = betterhash([key hash]) % _tableSize;
	TSArrayList* list = _table[index];

	TSKeyValuePair* kvp = nil;
	id<TSListIterator> it = [list iterator];
	while([it hasNext]){
		kvp = [it next];
		if([kvp.key isEqual:key]){
			retval = kvp.value;
			[it remove];
			_size--;
			break;
		}
	}

	if(list.size > _tableSize){
		//rehash
		int tmpTableSize = _tableSize;
		TSArrayList** tmpTable = _table;
		_tableSize *= 2;
		_table = TSDefaultMalloc( sizeof(TSArrayList*) * _tableSize );
		int i;
		for(i=0;i<_tableSize;i++){
			_table[i] = [TSArrayList new];
		}
		for(i=0;i<tmpTableSize;i++){
			TSArrayList* t = tmpTable[i];
			it = [t iterator];
			while([it hasNext]){
				kvp = [it next];
				[self put:kvp.key value:kvp.value];
			}
			[t release];
		}
		TSDefaultFree(tmpTable);

		return [self put:key value:value];
	}

	kvp = [[TSKeyValuePair alloc] initWithKey:key value:value];
	[list add: kvp];
	[kvp release];
	_size++;
	return retval;
}

-(id) get:(id)key
{
	id retval = nil;
	unsigned int index = betterhash([key hash]) % _tableSize;
	TSArrayList* list = _table[index];

	TSKeyValuePair* kvp = nil;
	id<TSListIterator> it = [list iterator];
	while([it hasNext]){
		kvp = [it next];
		if([kvp.key isEqual:key]){
			retval = kvp.value;
			break;
		}
	}

	return retval;
}

-(id) remove:(id) key
{
	id retval = nil;
	unsigned int index = betterhash([key hash]) % _tableSize;
	TSArrayList* list = _table[index];

	TSKeyValuePair* kvp = nil;
	id<TSListIterator> it = [list iterator];
	while([it hasNext]){
		kvp = [it next];
		if([kvp.key isEqual:key]){
			retval = kvp.value;
			[it remove];
			_size--;
			break;
		}
	}

	return retval;
}

@end