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




@protocol TSMap

/*
 * returns the number of kvp in the map
 */
-(unsigned int) size;

-(void) clear;

/*
 * Associates the specified value with the specified key in this 
 * map. If the map previously contained a mapping for the key, 
 * the old value is replaced by the specified value.
 * @returns the previous value associated with key or nil if there was
 * no maping for key
 */
-(id) put:(id)key value:(id)value;

/*
 * Returns the value to which the specified key is mapped, or nil if 
 * this map contains no mapping for the key. 
 */
-(id) get:(id)key;

/*
 * Removes the mapping for a key from this map if it is present.
 * @returns the previous value associated with key or nil if there was
 * no maping for key
 */
-(id) remove:(id)key;

@end