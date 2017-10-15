module synth;

import lv2.core;
import lv2.atom;
import lv2.urid;
import lv2.midi;

enum synthUri = "https://github.com/rtbo/lv2-d/plugins/eg-synth";

struct SynthPorts
{
    InputSequence input;
    OutputAudio   output;
}

double keyFreq(const ubyte key)
{
    import std.math : pow;
    return pow(2.0, (key - 69.0) / 12.0) * 440.0;
}

double keyPulse(const ubyte key, const double sampleRate)
{
    import std.math : PI;
    return 2 * PI * keyFreq(key) / sampleRate;
}


enum attackLen = 0.1f;
enum decayLen = 0.1f;
enum sustainGain = 0.85f;
enum releaseLen = 0.1f;

struct Enveloppe
{
    float attackSlp;
    float attackLvl;
    float decaySlp;
    float sustainLvl;
    float releaseSlp;

    this(const ubyte vel, const double sampleRate) nothrow @nogc
    {
        immutable gain = cast(float)vel / 127f;
        attackSlp = gain / (attackLen * sampleRate);
        attackLvl = gain;
        decaySlp = (gain * (sustainGain - 1f)) / (decayLen * sampleRate);
        sustainLvl = gain * sustainGain;
        releaseSlp = - gain*sustainGain / (releaseLen * sampleRate);
    }
}

enum State
{
    attack, decay, sustain, release,
}

struct Voice
{
    ubyte key;
    double phase;
    double pulse;
    float gain;
    Enveloppe enveloppe;
    State state;

    this(Synth synth, ubyte key, ubyte vel) nothrow @nogc
    {
        this.key = key;
        this.phase = 0;
        this.pulse = synth.pulses[key];
        this.gain = 0;
        this.enveloppe = Enveloppe(vel, synth.sampleRate);
        this.state = State.attack;
    }

    bool run (float[] output) nothrow @nogc
    {
        bool released;
        sampleLoop:
        foreach (ref s ; output) {
            import std.math : sin;
            s += sin(phase) * gain;
            phase += pulse;

            switch (state) {
            case State.attack:
                gain += enveloppe.attackSlp;
                if (gain >= enveloppe.attackLvl) {
                    gain = enveloppe.attackLvl;
                    state = State.decay;
                }
                break;
            case State.decay:
                gain += enveloppe.decaySlp;
                if (gain <= enveloppe.sustainLvl) {
                    gain = enveloppe.sustainLvl;
                    state = State.sustain;
                }
                break;
            case State.sustain:
                break;
            case State.release:
                gain += enveloppe.releaseSlp;
                if (gain <= 0) {
                    gain = 0;
                    released = true;
                    break sampleLoop;
                }
                break;
            default:
                break;
            }
        }
        return released;
    }
}

class Synth : Plugin!SynthPorts
{
    import std.typecons : Nullable;

    private enum numVoices = 32;
    private double sampleRate;
    private URID midiEvent;
    private double[128] pulses;
    private Nullable!Voice[32] voices;

    static Synth instantiate(const string uri, const double sampleRate,
                             const string bundlePath, FeatureRange features)
    {
        auto map = featuresQuery!(Map)(features);
        if (!map.isNull) {
            immutable midiEvent = map.map(LV2_MIDI__MidiEvent);
            return new Synth(sampleRate, midiEvent);
        }
        else {
            return null;
        }
    }

    this(const double sampleRate, const URID midiEvent)
    {
        this.sampleRate = sampleRate;
        this.midiEvent = midiEvent;
        foreach(const ubyte k; 0 .. 128) {
            this.pulses[k] = keyPulse(k, sampleRate);
        }
    }

    override void run (size_t sampleCount)
    {
        import lv2.atom.util : events;

        size_t offset;
        foreach (ev; this.input.events) {
            if (ev.atom.type == midiEvent) {
                immutable size_t frames = ev.time.frames;
                runVoices(this.output[offset .. frames]);
                immutable msg = ev.contents;
                immutable msgType = midiMessageType(msg[0]);
                if (msgType == MidiMsg.noteOn) {
                    noteOn(msg[1], msg[2]);
                }
                else if (msgType == MidiMsg.noteOff) {
                    noteOff(msg[1]);
                }
                offset = frames;
            }
        }
        runVoices(this.output[offset .. sampleCount]);
    }

    void noteOn(const ubyte key, const ubyte vel) nothrow @nogc
    {
        foreach (size_t i; 0 .. numVoices) {
            if (voices[i].isNull) {
                voices[i] = Voice(this, key, vel);
                break;
            }
        }
    }

    void noteOff(const ubyte key) nothrow @nogc
    {
        foreach (size_t i; 0 .. numVoices) {
            if (!voices[i].isNull && voices[i].key == key) {
                voices[i].state = State.release;
                break;
            }
        }
    }

    void runVoices(float[] output) nothrow @nogc
    {
        foreach(ref s; output) {
            s = 0;
        }
        foreach(size_t i; 0 .. numVoices) {
            if (!voices[i].isNull && voices[i].run(output)) {
                voices[i].nullify();
            }
        }
    }
}

mixin lv2_descriptor!(synthUri, Synth);
