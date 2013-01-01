

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