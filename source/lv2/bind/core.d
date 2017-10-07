module lv2.bind.core;

extern(C):

alias LV2_Handle = void*;

struct LV2_Feature {
    const char *URI;
    void *data;
}

struct LV2_Descriptor {
    const char *uri;

    extern (C) LV2_Handle function (const LV2_Descriptor *descriptor,
                                    double sampleRate,
                                    const (char)* bundlePath,
                                    const (const(LV2_Feature)*)* features)
            instantiate;


    extern (C) void function (LV2_Handle instance,
                              uint port,
                              void *dataLocation)
            connectPort;

    extern (C) void function (LV2_Handle instance)
            activate;

    extern (C) void function (LV2_Handle instance, uint sampleCount)
            run;

    extern (C) void function (LV2_Handle instance)
            deactivate;

    extern (C) void function (LV2_Handle instance)
            cleanup;

    extern (C) const (void) * function (const(char)* uri)
            extensionData;
}

const (LV2_Descriptor) * lv2_descriptor (uint index);
