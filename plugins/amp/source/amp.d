module amp;

import lv2.core;

enum ampUri = "https://github.com/rtbo/lv2-d/plugins/eg-amp";

enum : uint {
    PortGain,
    PortInput,
    PortOutput,
}

float dbToGain(in float db) pure @nogc nothrow @safe
{
    import std.math : pow;
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

mixin lv2_descriptor!(ampUri, Amp);
