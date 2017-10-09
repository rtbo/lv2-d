module lv2.core;

import lv2.bind.core;

import std.meta : staticIndexOf;
import std.traits : FieldNameTuple, Fields;

enum LV2_CORE_URI = "http://lv2plug.in/ns/lv2core";

enum LV2_CORE__AllpassPlugin      = "http://lv2plug.in/ns/lv2core#AllpassPlugin";
enum LV2_CORE__AmplifierPlugin    = "http://lv2plug.in/ns/lv2core#AmplifierPlugin";
enum LV2_CORE__AnalyserPlugin     = "http://lv2plug.in/ns/lv2core#AnalyserPlugin";
enum LV2_CORE__AudioPort          = "http://lv2plug.in/ns/lv2core#AudioPort";
enum LV2_CORE__BandpassPlugin     = "http://lv2plug.in/ns/lv2core#BandpassPlugin";
enum LV2_CORE__CVPort             = "http://lv2plug.in/ns/lv2core#CVPort";
enum LV2_CORE__ChorusPlugin       = "http://lv2plug.in/ns/lv2core#ChorusPlugin";
enum LV2_CORE__CombPlugin         = "http://lv2plug.in/ns/lv2core#CombPlugin";
enum LV2_CORE__CompressorPlugin   = "http://lv2plug.in/ns/lv2core#CompressorPlugin";
enum LV2_CORE__ConstantPlugin     = "http://lv2plug.in/ns/lv2core#ConstantPlugin";
enum LV2_CORE__ControlPort        = "http://lv2plug.in/ns/lv2core#ControlPort";
enum LV2_CORE__ConverterPlugin    = "http://lv2plug.in/ns/lv2core#ConverterPlugin";
enum LV2_CORE__DelayPlugin        = "http://lv2plug.in/ns/lv2core#DelayPlugin";
enum LV2_CORE__DistortionPlugin   = "http://lv2plug.in/ns/lv2core#DistortionPlugin";
enum LV2_CORE__DynamicsPlugin     = "http://lv2plug.in/ns/lv2core#DynamicsPlugin";
enum LV2_CORE__EQPlugin           = "http://lv2plug.in/ns/lv2core#EQPlugin";
enum LV2_CORE__EnvelopePlugin     = "http://lv2plug.in/ns/lv2core#EnvelopePlugin";
enum LV2_CORE__ExpanderPlugin     = "http://lv2plug.in/ns/lv2core#ExpanderPlugin";
enum LV2_CORE__ExtensionData      = "http://lv2plug.in/ns/lv2core#ExtensionData";
enum LV2_CORE__Feature            = "http://lv2plug.in/ns/lv2core#Feature";
enum LV2_CORE__FilterPlugin       = "http://lv2plug.in/ns/lv2core#FilterPlugin";
enum LV2_CORE__FlangerPlugin      = "http://lv2plug.in/ns/lv2core#FlangerPlugin";
enum LV2_CORE__FunctionPlugin     = "http://lv2plug.in/ns/lv2core#FunctionPlugin";
enum LV2_CORE__GatePlugin         = "http://lv2plug.in/ns/lv2core#GatePlugin";
enum LV2_CORE__GeneratorPlugin    = "http://lv2plug.in/ns/lv2core#GeneratorPlugin";
enum LV2_CORE__HighpassPlugin     = "http://lv2plug.in/ns/lv2core#HighpassPlugin";
enum LV2_CORE__InputPort          = "http://lv2plug.in/ns/lv2core#InputPort";
enum LV2_CORE__InstrumentPlugin   = "http://lv2plug.in/ns/lv2core#InstrumentPlugin";
enum LV2_CORE__LimiterPlugin      = "http://lv2plug.in/ns/lv2core#LimiterPlugin";
enum LV2_CORE__LowpassPlugin      = "http://lv2plug.in/ns/lv2core#LowpassPlugin";
enum LV2_CORE__MixerPlugin        = "http://lv2plug.in/ns/lv2core#MixerPlugin";
enum LV2_CORE__ModulatorPlugin    = "http://lv2plug.in/ns/lv2core#ModulatorPlugin";
enum LV2_CORE__MultiEQPlugin      = "http://lv2plug.in/ns/lv2core#MultiEQPlugin";
enum LV2_CORE__OscillatorPlugin   = "http://lv2plug.in/ns/lv2core#OscillatorPlugin";
enum LV2_CORE__OutputPort         = "http://lv2plug.in/ns/lv2core#OutputPort";
enum LV2_CORE__ParaEQPlugin       = "http://lv2plug.in/ns/lv2core#ParaEQPlugin";
enum LV2_CORE__PhaserPlugin       = "http://lv2plug.in/ns/lv2core#PhaserPlugin";
enum LV2_CORE__PitchPlugin        = "http://lv2plug.in/ns/lv2core#PitchPlugin";
enum LV2_CORE__Plugin             = "http://lv2plug.in/ns/lv2core#Plugin";
enum LV2_CORE__PluginBase         = "http://lv2plug.in/ns/lv2core#PluginBase";
enum LV2_CORE__Point              = "http://lv2plug.in/ns/lv2core#Point";
enum LV2_CORE__Port               = "http://lv2plug.in/ns/lv2core#Port";
enum LV2_CORE__PortProperty       = "http://lv2plug.in/ns/lv2core#PortProperty";
enum LV2_CORE__Resource           = "http://lv2plug.in/ns/lv2core#Resource";
enum LV2_CORE__ReverbPlugin       = "http://lv2plug.in/ns/lv2core#ReverbPlugin";
enum LV2_CORE__ScalePoint         = "http://lv2plug.in/ns/lv2core#ScalePoint";
enum LV2_CORE__SimulatorPlugin    = "http://lv2plug.in/ns/lv2core#SimulatorPlugin";
enum LV2_CORE__SpatialPlugin      = "http://lv2plug.in/ns/lv2core#SpatialPlugin";
enum LV2_CORE__Specification      = "http://lv2plug.in/ns/lv2core#Specification";
enum LV2_CORE__SpectralPlugin     = "http://lv2plug.in/ns/lv2core#SpectralPlugin";
enum LV2_CORE__UtilityPlugin      = "http://lv2plug.in/ns/lv2core#UtilityPlugin";
enum LV2_CORE__WaveshaperPlugin   = "http://lv2plug.in/ns/lv2core#WaveshaperPlugin";
enum LV2_CORE__appliesTo          = "http://lv2plug.in/ns/lv2core#appliesTo";
enum LV2_CORE__binary             = "http://lv2plug.in/ns/lv2core#binary";
enum LV2_CORE__connectionOptional = "http://lv2plug.in/ns/lv2core#connectionOptional";
enum LV2_CORE__control            = "http://lv2plug.in/ns/lv2core#control";
enum LV2_CORE__default            = "http://lv2plug.in/ns/lv2core#default";
enum LV2_CORE__designation        = "http://lv2plug.in/ns/lv2core#designation";
enum LV2_CORE__documentation      = "http://lv2plug.in/ns/lv2core#documentation";
enum LV2_CORE__enumeration        = "http://lv2plug.in/ns/lv2core#enumeration";
enum LV2_CORE__extensionData      = "http://lv2plug.in/ns/lv2core#extensionData";
enum LV2_CORE__freeWheeling       = "http://lv2plug.in/ns/lv2core#freeWheeling";
enum LV2_CORE__hardRTCapable      = "http://lv2plug.in/ns/lv2core#hardRTCapable";
enum LV2_CORE__inPlaceBroken      = "http://lv2plug.in/ns/lv2core#inPlaceBroken";
enum LV2_CORE__index              = "http://lv2plug.in/ns/lv2core#index";
enum LV2_CORE__integer            = "http://lv2plug.in/ns/lv2core#integer";
enum LV2_CORE__isLive             = "http://lv2plug.in/ns/lv2core#isLive";
enum LV2_CORE__latency            = "http://lv2plug.in/ns/lv2core#latency";
enum LV2_CORE__maximum            = "http://lv2plug.in/ns/lv2core#maximum";
enum LV2_CORE__microVersion       = "http://lv2plug.in/ns/lv2core#microVersion";
enum LV2_CORE__minimum            = "http://lv2plug.in/ns/lv2core#minimum";
enum LV2_CORE__minorVersion       = "http://lv2plug.in/ns/lv2core#minorVersion";
enum LV2_CORE__name               = "http://lv2plug.in/ns/lv2core#name";
enum LV2_CORE__optionalFeature    = "http://lv2plug.in/ns/lv2core#optionalFeature";
enum LV2_CORE__port               = "http://lv2plug.in/ns/lv2core#port";
enum LV2_CORE__portProperty       = "http://lv2plug.in/ns/lv2core#portProperty";
enum LV2_CORE__project            = "http://lv2plug.in/ns/lv2core#project";
enum LV2_CORE__prototype          = "http://lv2plug.in/ns/lv2core#prototype";
enum LV2_CORE__reportsLatency     = "http://lv2plug.in/ns/lv2core#reportsLatency";
enum LV2_CORE__requiredFeature    = "http://lv2plug.in/ns/lv2core#requiredFeature";
enum LV2_CORE__sampleRate         = "http://lv2plug.in/ns/lv2core#sampleRate";
enum LV2_CORE__scalePoint         = "http://lv2plug.in/ns/lv2core#scalePoint";
enum LV2_CORE__symbol             = "http://lv2plug.in/ns/lv2core#symbol";
enum LV2_CORE__toggled            = "http://lv2plug.in/ns/lv2core#toggled";


abstract class PluginBase
{
    void cleanup() {}
    void activate() {}
    void deactivate() {}

    nothrow @nogc
    abstract void connectPort(uint port, void *dataLocation);

    nothrow @nogc
    abstract void run(size_t sampleCount);
}

abstract class Plugin(P) : PluginBase
{
    alias Ports = P;
    alias PortNames = FieldNameTuple!Ports;

    /// check at compile-time that name is a port
    enum bool hasPort(string name) = staticIndexOf!(name, PortNames) != -1;


    final override void connectPort(uint port, void *dataLocation)
    {
        foreach (size_t i, field; PortNames) {
            if (port == i) {
                mixin("_ports." ~ field ~ ".loc = cast(Fields!Ports[i].Loc)dataLocation;");
            }
        }
    }

    nothrow @nogc
    @property auto opDispatch(string name)()
    {
        static assert (hasPort!name, name~" is not a field of "~Ports.stringof);

        foreach (field; PortNames) {
            static if (name == field) {
                return mixin("_ports."~field~".data(_sampleCount)");
            }
        }
    }

    nothrow @nogc
    @property auto opDispatch(string name, T)(in T data)
    {
        static assert (hasPort!name, name~" is not a field of "~Ports.stringof);

        foreach (field; PortNames) {
            static if (name == field) {
                mixin("_ports."~field~".setData(data);");
            }
        }
    }

    private Ports _ports;
    private size_t _sampleCount;
}

// some plugin traits

//! Statically checks that Plug is a LV2 plugin type
enum bool isPlugin(Plug) =
    is(Plug : PluginBase) && (
        is(typeof((string uri, double sampleRate, string bundlePath) {
            Plug p = Plug.instantiate(uri, sampleRate, bundlePath);
        }))
        ||
        is(typeof((string uri, double sampleRate,
                string bundlePath, FeatureRange features) {
            Plug p = Plug.instantiate(uri, sampleRate, bundlePath, features);
        }))
    );

//! Checks if plugin must be instantiated with features
enum bool needFeatures(Plug) =
    isPlugin!Plug &&
    is(typeof((string uri, double sampleRate,
            string bundlePath, FeatureRange features) {
        Plug p = Plug.instantiate(uri, sampleRate, bundlePath, features);
    }));


//! True if the plugin gives extension data
enum bool hasExtensionData(Plug) =
    isPlugin!Plug &&
    is(typeof((string uri) {
        void *ed = Plug.extensiondata(uri);
    }));


// Features implementation

alias Feature = LV2_Feature;

enum bool isFeature(F) =
    is(typeof((void* data) {
        string uri = F.uri;
        F f = F.from_data(data);
    }));


struct FeatureWrap
{
    private const(Feature)* feature;

    string uri() const {
        import std.string : fromStringz;
        return fromStringz(feature.URI).idup;
    }

    void *data() {
        return cast(void*)feature.data;
    }

    F opCast(F)() const
    if (isFeature!F)
    {
        assert(uri() == F.uri);
        return F.from_data(cast(void*)feature.data);
    }
}

struct FeatureRange
{
    private const(const(Feature)*)* features;

    @property FeatureWrap front() {
        return FeatureWrap(*features);
    }

    @property bool empty() {
        return *features is null;
    }

    void popFront() {
        ++features;
    }

    @property FeatureRange save() {
        return FeatureRange(features);
    }
}


enum PortDir {
    input, output
}

struct InputControl
{
    alias Loc = const(float)*;
    alias Data = float;
    enum direction = PortDir.input;

    Loc loc;
    Data data(in size_t) @nogc nothrow
    {
        return *loc;
    }
}

struct OutputControl
{
    alias Loc = float*;
    alias Data = float;
    enum direction = PortDir.output;

    Loc loc;
    Data data(in size_t) @nogc nothrow
    {
        return *loc;
    }
    void setData(in Data data) @nogc nothrow
    {
        *loc = data;
    }
}

struct InputAudio
{
    alias Loc = const(float)*;
    alias Data = const(float)[];
    enum direction = PortDir.input;

    Loc loc;
    Data data(in size_t sampleCount) @nogc nothrow
    {
        return loc[0 .. sampleCount];
    }
}

struct OutputAudio
{
    alias Loc = float*;
    alias Data = float[];
    enum direction = PortDir.output;

    Loc loc;
    Data data(in size_t sampleCount) @nogc nothrow
    {
        return loc[0 .. sampleCount];
    }
}


mixin template lv2_descriptor(Specs...)
{
    import lv2.bind.core;

    extern(C) pragma(mangle, "lv2_descriptor")
    const(LV2_Descriptor)* lv2_descriptor(uint index) nothrow @nogc
    {
        import std.meta : AliasSeq;

        template DescSpec(string s, T) {
            alias uri = s;
            alias Plug = T;
        }

        template parseDescSpecs(Specs...)
        {
            static if (Specs.length == 0) {
                alias parseDescSpecs = AliasSeq!();
            }
            else {
                alias parseDescSpecs = AliasSeq!(
                    DescSpec!(Specs[0..2]),
                    parseDescSpecs!(Specs[2..$])
                );
            }
        }

        alias descSpecs = parseDescSpecs!Specs;

        foreach(size_t i, desc; descSpecs) {
            if (index == i) {
                alias uri = desc.uri;
                alias Plug = desc.Plug;
                static immutable LV2_Descriptor d = {
                    uri:            uri,
                    instantiate:    &instantiate  !Plug,
                    connectPort:    &connectPort  !Plug,
                    activate:       &activate     !Plug,
                    run:            &run          !Plug,
                    deactivate:     &deactivate   !Plug,
                    cleanup:        &cleanup      !Plug,
                    extensionData:  &extensionData!Plug,
                };
                return &d;
            }
        }

        return null;
    }
}


// Instantiation class

extern (C) nothrow
LV2_Handle instantiate(Plug) (const LV2_Descriptor *descriptor,
                              double sampleRate,
                              const (char)* bundlePath,
                              const(const(LV2_Feature)*)* features)
if (is(Plug : PluginBase))
{
    import core.memory : GC;
    import core.runtime : Runtime;
    import core.thread : thread_attachThis;
    import std.string : fromStringz;

    static assert(is(typeof(Plug.instantiate)),
                  Plug.stringof ~ " must provide a instantiate static method");


    try {
        Runtime.initialize();
        thread_attachThis();

        static if (needFeatures!Plug)
        {
            auto instance = cast(LV2_Handle)
                    Plug.instantiate(fromStringz(descriptor.uri).idup,
                                     sampleRate,
                                     fromStringz(bundlePath).idup,
                                     FeatureRange(features));
        }
        else
        {
            auto instance = cast(LV2_Handle)
                    Plug.instantiate(fromStringz(descriptor.uri).idup,
                                     sampleRate,
                                     fromStringz(bundlePath).idup);
        }

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
            auto plug = cast(Plug)instance;
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


// Audio class

extern(C) nothrow @nogc
void connectPort(Plug)(LV2_Handle instance,
                        uint port,
                        void *dataLocation)
{
    static assert(isPlugin!Plug);
    auto plug = cast(Plug)instance;
    plug.connectPort(port, dataLocation);
}


extern (C) nothrow @nogc
void run(Plug)(LV2_Handle instance, uint sampleCount)
{
    static assert(isPlugin!Plug);
    auto plug = cast(Plug)instance;
    //static if (is(typeof(Plug.Ports))) {
        Plugin!(Plug.Ports) p = plug;
        p._sampleCount = sampleCount;
    //}
    plug.run(sampleCount);
}


// Discovery class

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
