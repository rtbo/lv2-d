module lv2.atom.util;

import lv2.atom;

pure nothrow @nogc:

size_t atomPadSize(const size_t size)
{
    return (size + 7) & ( ~ size_t(7) );
}

size_t atomTotalSize(const Atom* atom)
{
    return Atom.sizeof + atom.size;
}

size_t atomIsNull(const Atom* atom)
{
    return !atom || (atom.type == 0 && atom.size == 0);
}

bool atomEquals(const Atom* a, const Atom* b)
{
    import core.stdc.string : memcmp;
    return (a is b) || ((a.type == b.type) &&
                        (a.size == b.size) &&
                        !memcmp(a+1, b+1, a.size));
}

const(AtomEvent)*
atomSequenceBegin(const(AtomSequenceBody)* data)
{
    return cast(const(AtomEvent)*)(data + 1);
}

const(AtomEvent)*
atomSequenceEnd(const(AtomSequenceBody)* data, const size_t size)
{
    return cast(const(AtomEvent)*) (
        cast(const ubyte*)data + atomPadSize(size)
    );
}

bool
atomSequenceIsEnd(const(AtomSequenceBody)* data,
                  const size_t size, const(AtomEvent)* ev)
{
    return cast(const ubyte*)ev >= (cast(const ubyte*)data + size);
}

const(AtomEvent)* atomSequenceNext(const(AtomEvent)* ev)
{
    return cast(const(AtomEvent)*)(
        cast(const ubyte*)ev + AtomEvent.sizeof + atomPadSize(ev.atom.size)
    );
}

AtomEventRange events(const(AtomSequence)* seq)
{
    return AtomEventRange(&seq.data, seq.size());
}

struct AtomEventRange
{
    private const(AtomSequenceBody)* data;
    private size_t size;
    private const(AtomEvent)* ev;

    this(const(AtomSequenceBody)* data, const size_t size) pure nothrow @nogc
    {
        this.data = data;
        this.size = size;
        this.ev = atomSequenceBegin(data);
    }

    @property auto front() nothrow @nogc
    {
        return ev;
    }

    @property bool empty() nothrow @nogc
    {
        return atomSequenceIsEnd(data, size, ev);
    }

    @property void popFront() nothrow @nogc
    {
        ev = atomSequenceNext(ev);
    }

    @property auto save() nothrow @nogc
    {
        AtomEventRange range = void;
        range.data = this.data;
        range.size = this.size;
        range.ev = this.ev;
        return range;
    }
}

/+
/**
   Clear all events from `sequence`.

   This simply resets the size field, the other fields are left untouched.
*/
static inline void
lv2_atom_sequence_clear(LV2_Atom_Sequence* seq)
{
	seq->atom.size = sizeof(LV2_Atom_Sequence_Body);
}

/**
   Append an event at the end of `sequence`.

   @param seq Sequence to append to.
   @param capacity Total capacity of the sequence atom
   (e.g. as set by the host for sequence output ports).
   @param event Event to write.

   @return A pointer to the newly written event in `seq`,
   or NULL on failure (insufficient space).
*/
static inline LV2_Atom_Event*
lv2_atom_sequence_append_event(LV2_Atom_Sequence*    seq,
                               uint32_t              capacity,
                               const LV2_Atom_Event* event)
{
	const uint32_t total_size = (uint32_t)sizeof(*event) + event->body.size;
	if (capacity - seq->atom.size < total_size) {
		return NULL;
	}

	LV2_Atom_Event* e = lv2_atom_sequence_end(&seq->body, seq->atom.size);
	memcpy(e, event, total_size);

	seq->atom.size += lv2_atom_pad_size(total_size);

	return e;
}

/**
   @}
   @name Tuple Iterator
   @{
*/

/** Get an iterator pointing to the first element in `tup`. */
static inline LV2_Atom*
lv2_atom_tuple_begin(const LV2_Atom_Tuple* tup)
{
	return (LV2_Atom*)(LV2_ATOM_BODY(tup));
}

/** Return true iff `i` has reached the end of `body`. */
static inline bool
lv2_atom_tuple_is_end(const void* body, uint32_t size, const LV2_Atom* i)
{
	return (const uint8_t*)i >= ((const uint8_t*)body + size);
}

/** Return an iterator to the element following `i`. */
static inline LV2_Atom*
lv2_atom_tuple_next(const LV2_Atom* i)
{
	return (LV2_Atom*)(
		(const uint8_t*)i + sizeof(LV2_Atom) + lv2_atom_pad_size(i->size));
}

/**
   A macro for iterating over all properties of a Tuple.
   @param tuple The tuple to iterate over
   @param iter The name of the iterator

   This macro is used similarly to a for loop (which it expands to), e.g.:
   @code
   LV2_ATOM_TUPLE_FOREACH(tuple, elem) {
       // Do something with elem (an LV2_Atom*) here...
   }
   @endcode
*/
#define LV2_ATOM_TUPLE_FOREACH(tuple, iter) \
	for (LV2_Atom* (iter) = lv2_atom_tuple_begin(tuple); \
	     !lv2_atom_tuple_is_end(LV2_ATOM_BODY(tuple), (tuple)->atom.size, (iter)); \
	     (iter) = lv2_atom_tuple_next(iter))

/** Like LV2_ATOM_TUPLE_FOREACH but for a headerless tuple body. */
#define LV2_ATOM_TUPLE_BODY_FOREACH(body, size, iter) \
	for (LV2_Atom* (iter) = (LV2_Atom*)body; \
	     !lv2_atom_tuple_is_end(body, size, (iter)); \
	     (iter) = lv2_atom_tuple_next(iter))

/**
   @}
   @name Object Iterator
   @{
*/

/** Return a pointer to the first property in `body`. */
static inline LV2_Atom_Property_Body*
lv2_atom_object_begin(const LV2_Atom_Object_Body* body)
{
	return (LV2_Atom_Property_Body*)(body + 1);
}

/** Return true iff `i` has reached the end of `obj`. */
static inline bool
lv2_atom_object_is_end(const LV2_Atom_Object_Body*   body,
                       uint32_t                      size,
                       const LV2_Atom_Property_Body* i)
{
	return (const uint8_t*)i >= ((const uint8_t*)body + size);
}

/** Return an iterator to the property following `i`. */
static inline LV2_Atom_Property_Body*
lv2_atom_object_next(const LV2_Atom_Property_Body* i)
{
	const LV2_Atom* const value = (const LV2_Atom*)(
		(const uint8_t*)i + 2 * sizeof(uint32_t));
	return (LV2_Atom_Property_Body*)(
		(const uint8_t*)i + lv2_atom_pad_size(
			(uint32_t)sizeof(LV2_Atom_Property_Body) + value->size));
}

/**
   A macro for iterating over all properties of an Object.
   @param obj The object to iterate over
   @param iter The name of the iterator

   This macro is used similarly to a for loop (which it expands to), e.g.:
   @code
   LV2_ATOM_OBJECT_FOREACH(object, i) {
       // Do something with prop (an LV2_Atom_Property_Body*) here...
   }
   @endcode
*/
#define LV2_ATOM_OBJECT_FOREACH(obj, iter) \
	for (LV2_Atom_Property_Body* (iter) = lv2_atom_object_begin(&(obj)->body); \
	     !lv2_atom_object_is_end(&(obj)->body, (obj)->atom.size, (iter)); \
	     (iter) = lv2_atom_object_next(iter))

/** Like LV2_ATOM_OBJECT_FOREACH but for a headerless object body. */
#define LV2_ATOM_OBJECT_BODY_FOREACH(body, size, iter) \
	for (LV2_Atom_Property_Body* (iter) = lv2_atom_object_begin(body); \
	     !lv2_atom_object_is_end(body, size, (iter)); \
	     (iter) = lv2_atom_object_next(iter))

/**
   @}
   @name Object Query
   @{
*/

/** A single entry in an Object query. */
typedef struct {
	uint32_t         key;    /**< Key to query (input set by user) */
	const LV2_Atom** value;  /**< Found value (output set by query function) */
} LV2_Atom_Object_Query;

static const LV2_Atom_Object_Query LV2_ATOM_OBJECT_QUERY_END = { 0, NULL };

/**
   Get an object's values for various keys.

   The value pointer of each item in `query` will be set to the location of
   the corresponding value in `object`.  Every value pointer in `query` MUST
   be initialised to NULL.  This function reads `object` in a single linear
   sweep.  By allocating `query` on the stack, objects can be "queried"
   quickly without allocating any memory.  This function is realtime safe.

   This function can only do "flat" queries, it is not smart enough to match
   variables in nested objects.

   For example:
   @code
   const LV2_Atom* name = NULL;
   const LV2_Atom* age  = NULL;
   LV2_Atom_Object_Query q[] = {
       { urids.eg_name, &name },
       { urids.eg_age,  &age },
       LV2_ATOM_OBJECT_QUERY_END
   };
   lv2_atom_object_query(obj, q);
   // name and age are now set to the appropriate values in obj, or NULL.
   @endcode
*/
static inline int
lv2_atom_object_query(const LV2_Atom_Object* object,
                      LV2_Atom_Object_Query* query)
{
	int matches   = 0;
	int n_queries = 0;

	/* Count number of query keys so we can short-circuit when done */
	for (LV2_Atom_Object_Query* q = query; q->key; ++q) {
		++n_queries;
	}

	LV2_ATOM_OBJECT_FOREACH(object, prop) {
		for (LV2_Atom_Object_Query* q = query; q->key; ++q) {
			if (q->key == prop->key && !*q->value) {
				*q->value = &prop->value;
				if (++matches == n_queries) {
					return matches;
				}
				break;
			}
		}
	}
	return matches;
}

/**
   Body only version of lv2_atom_object_get().
*/
static inline int
lv2_atom_object_body_get(uint32_t size, const LV2_Atom_Object_Body* body, ...)
{
	int matches   = 0;
	int n_queries = 0;

	/* Count number of keys so we can short-circuit when done */
	va_list args;
	va_start(args, body);
	for (n_queries = 0; va_arg(args, uint32_t); ++n_queries) {
		if (!va_arg(args, const LV2_Atom**)) {
			return -1;
		}
	}
	va_end(args);

	LV2_ATOM_OBJECT_BODY_FOREACH(body, size, prop) {
		va_start(args, body);
		for (int i = 0; i < n_queries; ++i) {
			uint32_t         qkey = va_arg(args, uint32_t);
			const LV2_Atom** qval = va_arg(args, const LV2_Atom**);
			if (qkey == prop->key && !*qval) {
				*qval = &prop->value;
				if (++matches == n_queries) {
					return matches;
				}
				break;
			}
		}
		va_end(args);
	}
	return matches;
}

/**
   Variable argument version of lv2_atom_object_query().

   This is nicer-looking in code, but a bit more error-prone since it is not
   type safe and the argument list must be terminated.

   The arguments should be a series of uint32_t key and const LV2_Atom** value
   pairs, terminated by a zero key.  The value pointers MUST be initialized to
   NULL.  For example:

   @code
   const LV2_Atom* name = NULL;
   const LV2_Atom* age  = NULL;
   lv2_atom_object_get(obj,
                       uris.name_key, &name,
                       uris.age_key,  &age,
                       0);
   @endcode
*/
static inline int
lv2_atom_object_get(const LV2_Atom_Object* object, ...)
{
	int matches   = 0;
	int n_queries = 0;

	/* Count number of keys so we can short-circuit when done */
	va_list args;
	va_start(args, object);
	for (n_queries = 0; va_arg(args, uint32_t); ++n_queries) {
		if (!va_arg(args, const LV2_Atom**)) {
			return -1;
		}
	}
	va_end(args);

	LV2_ATOM_OBJECT_FOREACH(object, prop) {
		va_start(args, object);
		for (int i = 0; i < n_queries; ++i) {
			uint32_t         qkey = va_arg(args, uint32_t);
			const LV2_Atom** qval = va_arg(args, const LV2_Atom**);
			if (qkey == prop->key && !*qval) {
				*qval = &prop->value;
				if (++matches == n_queries) {
					return matches;
				}
				break;
			}
		}
		va_end(args);
	}
	return matches;
}

/**
   Variable argument version of lv2_atom_object_query() with types.

   This is like lv2_atom_object_get(), but each entry has an additional
   parameter to specify the required type.  Only atoms with a matching type
   will be selected.

   The arguments should be a series of uint32_t key, const LV2_Atom**, uint32_t
   type triples, terminated by a zero key.  The value pointers MUST be
   initialized to NULL.  For example:

   @code
   const LV2_Atom_String* name = NULL;
   const LV2_Atom_Int*    age  = NULL;
   lv2_atom_object_get(obj,
                       uris.name_key, &name, uris.atom_String,
                       uris.age_key,  &age, uris.atom_Int
                       0);
   @endcode
*/
static inline int
lv2_atom_object_get_typed(const LV2_Atom_Object* object, ...)
{
	int matches   = 0;
	int n_queries = 0;

	/* Count number of keys so we can short-circuit when done */
	va_list args;
	va_start(args, object);
	for (n_queries = 0; va_arg(args, uint32_t); ++n_queries) {
		if (!va_arg(args, const LV2_Atom**) ||
		    !va_arg(args, uint32_t)) {
			return -1;
		}
	}
	va_end(args);

	LV2_ATOM_OBJECT_FOREACH(object, prop) {
		va_start(args, object);
		for (int i = 0; i < n_queries; ++i) {
			const uint32_t   qkey  = va_arg(args, uint32_t);
			const LV2_Atom** qval  = va_arg(args, const LV2_Atom**);
			const uint32_t   qtype = va_arg(args, uint32_t);
			if (!*qval && qkey == prop->key && qtype == prop->value.type) {
				*qval = &prop->value;
				if (++matches == n_queries) {
					return matches;
				}
				break;
			}
		}
		va_end(args);
	}
	return matches;
}
+/