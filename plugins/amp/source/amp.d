module amp;

import lv2.core;
import std.stdio;

enum ampUri = "https://github.com/rtbo/lv2-d/plugins/eg-amp";

float dbToGain(in float db) pure @nogc nothrow @safe
{
    import std.math : pow;
    return db > -90f ? pow(10f, db*0.05f) : 0f;
}

struct AmpPorts
{
    InputControl gain;
    InputAudio   input;
    OutputAudio  output;
}

final class Amp : Plugin!AmpPorts
{
    static Amp instantiate(in string uri, in double sampleRate, in string bundlePath)
    {
        return new Amp;
    }
    override void run(size_t sampleCount)
    {
        const gain = dbToGain(this.gain);
        const input = this.input;
        auto output = this.output;

        foreach (size_t s; 0 .. sampleCount) {
            output[s] = input[s] * gain;
        }
    }
}

static assert(isPlugin!Amp);

mixin lv2_descriptor!(ampUri, Amp);
