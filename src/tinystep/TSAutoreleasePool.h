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



#import <tinystep/TSObject.h>


struct autorelease_array_list;
@interface TSAutoreleasePool : TSObject {
	TSAutoreleasePool* _parent;
	TSAutoreleasePool* _child;
	struct autorelease_array_list* _released;
	struct autorelease_array_list* _released_head;
	unsigned int _released_count;

	/* The method to add an object to this pool used for faster calling*/
  	void (*_addImp)(id, SEL, id);
}

+(id) currentPool;
+(void) addObject: (id)anObj;

-(void) addObject: (id)anObj;

-(void) emptyPool;


@end