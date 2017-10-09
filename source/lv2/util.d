module lv2.util;

import std.traits;


/// build a c string from s and frees it in dtor
nothrow @nogc
struct CStr
{
    private const(char)* _s;
    private bool _free;

    this(string s)
    {
        immutable len = s.length;
        if (len == 0) {
            _s = "".ptr;
            return;
        }

        immutable p = s.ptr + len;

        if ((cast(size_t) p & 3) && *p == 0) {
            _s = &s[0];
        }
        else {
            import core.stdc.stdlib : malloc;
            auto newS = cast(char*)malloc(len+1);
            newS[0 .. len] = s[0 .. len];
            newS[len] = 0;
            _s = cast(const(char*))newS;
            _free = true;
        }
    }

    ~this()
    {
        if (_free) {
            import core.stdc.stdlib : free;
            free(cast(void*)_s);
        }
    }

    @property const(char)* get() const
    {
        return _s;
    }

    alias get this;
}


debug
{
    /// cast the passed function to @nogc function
    auto assumeNogc(T)(T f)
    if ( isFunctionPointer!T || isDelegate!T)
    {
        enum attrs = functionAttributes!T | FunctionAttribute.nogc;
        return cast(SetFunctionAttributes!(T, functionLinkage!T, attrs)) f;
    }

    /// allow call of gc-ing and throwing function in a @nogc and nothrow context
    /// only available in debug builds
    @nogc
    T gcCall(T)(scope T delegate() func)
    {
        return assumeNogc(func)();
    }

    /// allow call of gc-ing and throwing function in a @nogc and nothrow context
    /// only available in debug builds
    nothrow @nogc
    T gcThrowCall(T)(scope T delegate() func, bool *thrown=null)
    in {
        assert(!thrown || !(*thrown));
    }
    body {
        try {
            return assumeNogc(func)();
        }
        catch(Exception)
        {
            if (thrown) *thrown = true;
            static if (!is(typeof(func()) == void)) {
                return typeof(func()).init;
            }
        }
    }

    /// allow call of gc-ing and throwing function in a @nogc and nothrow context
    /// only available in debug builds
    nothrow @nogc
    T throwCall(T)(scope T delegate() func, bool *thrown=null)
    in {
        assert(!thrown || !(*thrown));
    }
    body {
        try {
            return func();
        }
        catch(Exception)
        {
            if (thrown) *thrown = true;
            static if (!is(typeof(func()) == void)) {
                return typeof(func()).init;
            }
        }
    }

    void println(T...)(T args) nothrow @nogc
    {
        gcThrowCall({
            import std.stdio : writeln;
            writeln(args);
        });
    }

    void printfln(T...)(string fmt, T args) nothrow @nogc
    {
        gcThrowCall({
            import std.stdio : writefln;
            writefln(fmt, args);
        });
    }
}
