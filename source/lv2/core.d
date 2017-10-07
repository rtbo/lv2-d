module lv2.core;

import lv2.bind.core;

abstract class Plugin
{
    void cleanup() {}
    void activate() {}
    void deactivate() {}

    @nogc nothrow
    abstract void connectPort(uint port, void *dataLocation);

    @nogc nothrow
    abstract void run(size_t sampleCount);
}

//! Statically checks that Plug is a LV2 plugin type
enum bool isPlugin(Plug) =
    is(Plug : Plugin) &&
    is(typeof((string uri, double sampleRate, string bundlePath) {
        Plug p = Plug.instantiate(uri, sampleRate, bundlePath);
    }));


enum bool hasExtensionData(Plug) =
    isPlugin!Plug &&
    is(typeof((string uri) {
        void *ed = Plug.extensiondata(uri);
    }));


extern (C) nothrow
LV2_Handle instantiate(Plug) (const LV2_Descriptor *descriptor,
                              double sampleRate,
                              const (char)* bundlePath,
                              const (const(LV2_Feature)*)* features)
{
    import core.memory : GC;
    import core.runtime : Runtime;
    import core.thread : thread_attachThis;
    import std.string : fromStringz;

    static assert(isPlugin!Plug);

    try {
        Runtime.initialize();

        thread_attachThis();

        auto instance = cast(LV2_Handle) Plug.instantiate(fromStringz(descriptor.uri).idup,
                                                            sampleRate,
                                                            fromStringz(bundlePath).idup);
        GC.addRoot(instance);
        GC.setAttr(instance, GC.BlkAttr.NO_MOVE);

        return instance;
    }
    catch (Exception) {
        return null;
    }
}

extern (C) nothrow
void cleanup(Plug)(LV2_Handle instance)
{
    import core.memory : GC;
    import core.runtime : Runtime;

    static assert(isPlugin!Plug);

    try {
        GC.removeRoot(instance);
        GC.clrAttr(instance, GC.BlkAttr.NO_MOVE);

        {
            auto plug = cast(Plugin)instance;
            plug.cleanup();
        }

        Runtime.terminate();
    }
    catch (Exception) {}
}

extern (C) nothrow
void activate(Plug)(LV2_Handle instance)
{
    static assert(isPlugin!Plug);
    try {
        auto plug = cast(Plug)instance;
        plug.activate();
    }
    catch (Exception) {}
}

extern (C) nothrow
void deactivate(Plug)(LV2_Handle instance)
{
    static assert(isPlugin!Plug);
    try {
        auto plug = cast(Plug)instance;
        plug.deactivate();
    }
    catch (Exception) {}
}




extern(C) @nogc nothrow
void connectPort(Plug)(LV2_Handle instance,
                        uint port,
                        void *dataLocation)
{
    static assert(isPlugin!Plug);
    auto plug = cast(Plug)instance;
    plug.connectPort(port, dataLocation);
}


extern (C) @nogc nothrow
void run(Plug)(LV2_Handle instance, uint sampleCount)
{
    static assert(isPlugin!Plug);
    auto plug = cast(Plug)instance;
    plug.run(sampleCount);
}

extern (C) nothrow
const(void)* extensionData(Plug)(const(char)* uri)
{
    import std.string : fromStringz;

    static assert(isPlugin!Plug);

    static if (hasExtensionData!Plug) {
        try {
            return Plug.extensionData(fromStringz(uri).idup);
        }
        catch (Exception) {
            return null;
        }
    }
    else {
        return null;
    }
}
