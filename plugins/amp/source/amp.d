module amp;

import lv2.bind.core;
import lv2.core;

import std.math : pow;

enum ampUri = "https://github.com/rtbo/lv2-d/plugins/eg-amp";

enum : uint {
    PortGain,
    PortInput,
    PortOutput,
}

float dbToGain(in float db) pure @nogc nothrow @safe
{
    return db > -90f ? pow(10f, db*0.05f) : 0f;
}

final class Amp : Plugin
{
    const(float)* gain;
    const(float)* input;
    float* output;

    static Amp instantiate(in string uri, in double sampleRate, in string bundlePath)
    {
        return new Amp;
    }

    override void connectPort(uint port, void *dataLocation)
    {
        switch(port) {
            case PortGain:
                gain = cast(const(float)*)dataLocation;
                break;
            case PortInput:
                input = cast(const(float)*)dataLocation;
                break;
            case PortOutput:
                output = cast(float*)dataLocation;
                break;
            default:
                break;
        }
    }

    override void run(size_t sampleCount)
    {
        const gain = dbToGain(*this.gain);
        const input = this.input[0 .. sampleCount];
        auto output = this.output[0 .. sampleCount];

        foreach (size_t s; 0 .. sampleCount) {
            output[s] = input[s] * gain;
        }
    }
}

static assert(isPlugin!Amp);

immutable LV2_Descriptor DESCRIPTOR = {
    uri:            ampUri,
    instantiate:    &instantiate!Amp,
    connectPort:    &connectPort!Amp,
    activate:       &activate!Amp,
    run:            &run!Amp,
    deactivate:     &deactivate!Amp,
    cleanup:        &cleanup!Amp,
    extensionData:  &extensionData!Amp,
};

extern(C)
const (LV2_Descriptor)* lv2_descriptor(uint index) {
    if (index == 0) {
        return &DESCRIPTOR;
    }
    else {
        return null;
    }
}
