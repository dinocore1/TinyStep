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


#import <tinystep/TSKeyValuePair.h>


@implementation TSKeyValuePair

-(id) initWithKey:(id) key value:(id)value
{
	self = [super init];
	if(self) {
		_key = [key retain];
		_value = [value retain];
	}
	return self;
}

-(id) key
{
	return _key;
}

-(id) value
{
	return _value;
}

-(void) dealloc
{
	[_key release];
	[_value release];
	[super dealloc];
}

@end