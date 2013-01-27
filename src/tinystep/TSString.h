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
#import <tinystep/TSComparator.h>

@interface TSString : TSObject {
  void* _buf;
  int _capacity;
}

- (id) initWithCString:(const char*)str;
- (const char*) cString;

@end

@interface TSStringComparator : TSObject<TSComparator> {
}

@end

@interface TSStringBuffer : TSObject {
	void* _buf;
	unsigned int _capacity;
	unsigned int _used;
}

-(void) appendCString:(char*)str;

-(TSString*) toString;

@end

