/*
 * Interface for the No Hot Spot Non-Blocking Skip List
 * operations.
 *
 * Author: Ian Dick, 2013.
 */

#ifndef NOHOTSPOT_OPS_H_
#define NOHOTSPOT_OPS_H_

#include "skiplist.h"

typedef enum sl_optype sl_optype_t;
enum sl_optype
{
	CONTAINS,
	DELETE,
	INSERT,
	LOOKUP,
	LOOKUP_RANGE,
};

unsigned long sl_do_operation(set_t *set, sl_optype_t optype, sl_key_t key, val_t val);

/* these are macros instead of functions to improve performance */
#define sl_contains(a, b) sl_do_operation((a), CONTAINS, (b), NULL);
#define sl_delete(a, b) sl_do_operation((a), DELETE, (b), NULL);
#define sl_insert(a, b, c) sl_do_operation((a), INSERT, (b), (c));
#define sl_lookup(a, b) sl_do_operation((a), LOOKUP, (b), NULL);
#define sl_lookup_range(a, b, c) sl_do_operation((a), LOOKUP_RANGE, (b), (c));

#endif /* NOHOTSPOT_OPS_H_ */
