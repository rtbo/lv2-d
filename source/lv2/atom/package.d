module lv2.atom;

import lv2.urid : URID;

pure nothrow @nogc:

enum LV2_ATOM_URI = "http://lv2plug.in/ns/ext/atom";

enum LV2_ATOM__Atom          = "http://lv2plug.in/ns/ext/atom#Atom";
enum LV2_ATOM__AtomPort      = "http://lv2plug.in/ns/ext/atom#AtomPort";
enum LV2_ATOM__Blank         = "http://lv2plug.in/ns/ext/atom#Blank";
enum LV2_ATOM__Bool          = "http://lv2plug.in/ns/ext/atom#Bool";
enum LV2_ATOM__Chunk         = "http://lv2plug.in/ns/ext/atom#Chunk";
enum LV2_ATOM__Double        = "http://lv2plug.in/ns/ext/atom#Double";
enum LV2_ATOM__Event         = "http://lv2plug.in/ns/ext/atom#Event";
enum LV2_ATOM__Float         = "http://lv2plug.in/ns/ext/atom#Float";
enum LV2_ATOM__Int           = "http://lv2plug.in/ns/ext/atom#Int";
enum LV2_ATOM__Literal       = "http://lv2plug.in/ns/ext/atom#Literal";
enum LV2_ATOM__Long          = "http://lv2plug.in/ns/ext/atom#Long";
enum LV2_ATOM__Number        = "http://lv2plug.in/ns/ext/atom#Number";
enum LV2_ATOM__Object        = "http://lv2plug.in/ns/ext/atom#Object";
enum LV2_ATOM__Path          = "http://lv2plug.in/ns/ext/atom#Path";
enum LV2_ATOM__Property      = "http://lv2plug.in/ns/ext/atom#Property";
enum LV2_ATOM__Resource      = "http://lv2plug.in/ns/ext/atom#Resource";
enum LV2_ATOM__Sequence      = "http://lv2plug.in/ns/ext/atom#Sequence";
enum LV2_ATOM__Sound         = "http://lv2plug.in/ns/ext/atom#Sound";
enum LV2_ATOM__String        = "http://lv2plug.in/ns/ext/atom#String";
enum LV2_ATOM__Tuple         = "http://lv2plug.in/ns/ext/atom#Tuple";
enum LV2_ATOM__URI           = "http://lv2plug.in/ns/ext/atom#URI";
enum LV2_ATOM__URID          = "http://lv2plug.in/ns/ext/atom#URID";
enum LV2_ATOM__Vector        = "http://lv2plug.in/ns/ext/atom#Vector";
enum LV2_ATOM__atomTransfer  = "http://lv2plug.in/ns/ext/atom#atomTransfer";
enum LV2_ATOM__beatTime      = "http://lv2plug.in/ns/ext/atom#beatTime";
enum LV2_ATOM__bufferType    = "http://lv2plug.in/ns/ext/atom#bufferType";
enum LV2_ATOM__childType     = "http://lv2plug.in/ns/ext/atom#childType";
enum LV2_ATOM__eventTransfer = "http://lv2plug.in/ns/ext/atom#eventTransfer";
enum LV2_ATOM__frameTime     = "http://lv2plug.in/ns/ext/atom#frameTime";
enum LV2_ATOM__supports      = "http://lv2plug.in/ns/ext/atom#supports";
enum LV2_ATOM__timeUnit      = "http://lv2plug.in/ns/ext/atom#timeUnit";

enum LV2_ATOM_REFERENCE_TYPE = 0;


inout(ubyte)[] contents (AtomT)(inout(AtomT)* atom) @property
in {
    assert(atom !is null);
}
body {
    return (cast(inout(ubyte)*)atom) [
        AtomT.sizeof .. AtomT.sizeof + atom.size()
    ];
}


private mixin template atomCode(string i)
{
    enum uri = i;
    @property size_t size() const pure nothrow @nogc {
        return atom.size;
    }
    @property URID type() const pure nothrow @nogc {
        return atom.type;
    }
}

struct Atom
{
    uint size;
    URID type;
}

struct AtomInt
{
    mixin atomCode!(LV2_ATOM__Int);

    Atom atom;
    int  data;
}

struct AtomLong
{
    mixin atomCode!(LV2_ATOM__Long);

    Atom atom;
    private long data;
}

struct AtomFloat
{
    mixin atomCode!(LV2_ATOM__Float);

    Atom atom;
    float    data;
}

struct AtomDouble
{
    mixin atomCode!(LV2_ATOM__Double);

    Atom atom;
    double data;
}

alias AtomBool = AtomInt;

struct AtomURID
{
    mixin atomCode!(LV2_ATOM__URID);

    Atom atom;
    URID data;
}

struct AtomString
{
    mixin atomCode!(LV2_ATOM__String);

    Atom atom;
    /* Contents (a null-terminated UTF-8 string) follow here. */
}

struct AtomLiteralBody
{
    URID datatype;
    URID lang;
    /* Contents (a null-terminated UTF-8 string) follow here. */
}

struct AtomLiteral
{
    mixin atomCode!(LV2_ATOM__Literal);

    Atom atom;
    AtomLiteralBody data;
}

struct AtomTuple
{
    mixin atomCode!(LV2_ATOM__Tuple);

    Atom atom;
    /* Contents (a series of complete atoms) follow here. */
}

struct AtomVectorBody
{
    uint child_size;
    uint child_type;
    /* Contents (a series of packed atom bodies) follow here. */
}

struct AtomVector
{
    mixin atomCode!(LV2_ATOM__Vector);

    Atom           atom;
    AtomVectorBody data;
}

struct AtomPropertyBody
{
    uint key;
    uint context;
    Atom value;
    /* Value atom data follows here. */
}

struct AtomProperty
{
    mixin atomCode!(LV2_ATOM__Property);

    Atom atom;
    AtomPropertyBody data;
}

struct AtomObjectBody
{
    URID id;
    URID otype;
    /* Contents (a series of property bodies) follow here. */
}

struct AtomObject
{
    mixin atomCode!(LV2_ATOM__Object);

    Atom atom;
    AtomObjectBody data;
}

struct AtomEvent
{
    union Time {
        long frames;
        double beats;
    }
    Time time;
    Atom atom;
    /* Body atom contents follow here. */
}

inout(ubyte)[] contents (inout(AtomEvent)* ev) @property
in {
    assert(ev !is null);
}
body {
    return (cast(inout(ubyte)*)ev) [
        AtomEvent.sizeof .. AtomEvent.sizeof + ev.atom.size
    ];
}


/**
   The body of an atom:Sequence (a sequence of events).

   The unit field is either a URID that described an appropriate time stamp
   type, or may be 0 where a default stamp type is known.  For
   LV2_Descriptor::run(), the default stamp type is audio frames.

   The contents of a sequence is a series of AtomEvent, each aligned
   to 64-bits, e.g.:
   <pre>
   | Event 1 (size 6)                              | Event 2
   |       |       |       |       |       |       |       |       |
   | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
   |FRAMES |SUBFRMS|TYPE   |SIZE   |DATADATADATAPAD|FRAMES |SUBFRMS|...
   </pre>
*/
struct AtomSequenceBody
{
    uint unit;
    uint pad;
    /* Contents (a series of events) follow here. */
}

struct AtomSequence
{
    mixin atomCode!(LV2_ATOM__Sequence);

    Atom atom;  /**< Atom header. */
    AtomSequenceBody data;  /**< Body. */
}

struct InputSequence
{
    import lv2.core : PortDir;

    alias Loc = const(AtomSequence)*;
    alias Data = const(AtomSequence)*;
    enum direction = PortDir.input;

    Loc loc;
    Data data(in size_t) @nogc nothrow
    {
        return loc;
    }
}
