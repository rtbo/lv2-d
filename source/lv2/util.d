module lv2.util;

import std.traits;

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
}
