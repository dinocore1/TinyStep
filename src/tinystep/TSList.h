
#import <tinystep/TSObject.h>

@protocol TSList

/*
 * returns the number of objects in the list
 */
-(unsigned int) size;

/*
 * removes all objects in the list
 */
-(void) clear;

/*
 * adds a new item at the end of the list
 */
-(void) add:(id) obj;

/*
 * inserts the item at the specified position. Shifts
 * the items currently at that position (if any) and any
 * subsequent items to the right (adds one to their indices).
 */
-(void) add:(id) obj index:(unsigned int) index;

/*
 * removes the item at index and returns
 */
-(id) remove:(unsigned int) index;

/*
 * Replaces the item at the specified position in this
 * list with the specified element
 */
-(id) set:(unsigned int) index obj:(id)obj;

/*
 * Returns the item at the specified position.
 */
-(id) getAt:(unsigned int) index;


@end
