module lv2.midi;

pure nothrow @nogc:

enum LV2_MIDI_URI = "http://lv2plug.in/ns/ext/midi";

enum LV2_MIDI__ActiveSense      = "http://lv2plug.in/ns/ext/midi#ActiveSense";
enum LV2_MIDI__Aftertouch       = "http://lv2plug.in/ns/ext/midi#Aftertouch";
enum LV2_MIDI__Bender           = "http://lv2plug.in/ns/ext/midi#Bender";
enum LV2_MIDI__ChannelPressure  = "http://lv2plug.in/ns/ext/midi#ChannelPressure";
enum LV2_MIDI__Chunk            = "http://lv2plug.in/ns/ext/midi#Chunk";
enum LV2_MIDI__Clock            = "http://lv2plug.in/ns/ext/midi#Clock";
enum LV2_MIDI__Continue         = "http://lv2plug.in/ns/ext/midi#Continue";
enum LV2_MIDI__Controller       = "http://lv2plug.in/ns/ext/midi#Controller";
enum LV2_MIDI__MidiEvent        = "http://lv2plug.in/ns/ext/midi#MidiEvent";
enum LV2_MIDI__NoteOff          = "http://lv2plug.in/ns/ext/midi#NoteOff";
enum LV2_MIDI__NoteOn           = "http://lv2plug.in/ns/ext/midi#NoteOn";
enum LV2_MIDI__ProgramChange    = "http://lv2plug.in/ns/ext/midi#ProgramChange";
enum LV2_MIDI__QuarterFrame     = "http://lv2plug.in/ns/ext/midi#QuarterFrame";
enum LV2_MIDI__Reset            = "http://lv2plug.in/ns/ext/midi#Reset";
enum LV2_MIDI__SongPosition     = "http://lv2plug.in/ns/ext/midi#SongPosition";
enum LV2_MIDI__SongSelect       = "http://lv2plug.in/ns/ext/midi#SongSelect";
enum LV2_MIDI__Start            = "http://lv2plug.in/ns/ext/midi#Start";
enum LV2_MIDI__Stop             = "http://lv2plug.in/ns/ext/midi#Stop";
enum LV2_MIDI__SystemCommon     = "http://lv2plug.in/ns/ext/midi#SystemCommon";
enum LV2_MIDI__SystemExclusive  = "http://lv2plug.in/ns/ext/midi#SystemExclusive";
enum LV2_MIDI__SystemMessage    = "http://lv2plug.in/ns/ext/midi#SystemMessage";
enum LV2_MIDI__SystemRealtime   = "http://lv2plug.in/ns/ext/midi#SystemRealtime";
enum LV2_MIDI__Tick             = "http://lv2plug.in/ns/ext/midi#Tick";
enum LV2_MIDI__TuneRequest      = "http://lv2plug.in/ns/ext/midi#TuneRequest";
enum LV2_MIDI__VoiceMessage     = "http://lv2plug.in/ns/ext/midi#VoiceMessage";
enum LV2_MIDI__benderValue      = "http://lv2plug.in/ns/ext/midi#benderValue";
enum LV2_MIDI__binding          = "http://lv2plug.in/ns/ext/midi#binding";
enum LV2_MIDI__byteNumber       = "http://lv2plug.in/ns/ext/midi#byteNumber";
enum LV2_MIDI__channel          = "http://lv2plug.in/ns/ext/midi#channel";
enum LV2_MIDI__chunk            = "http://lv2plug.in/ns/ext/midi#chunk";
enum LV2_MIDI__controllerNumber = "http://lv2plug.in/ns/ext/midi#controllerNumber";
enum LV2_MIDI__controllerValue  = "http://lv2plug.in/ns/ext/midi#controllerValue";
enum LV2_MIDI__noteNumber       = "http://lv2plug.in/ns/ext/midi#noteNumber";
enum LV2_MIDI__pressure         = "http://lv2plug.in/ns/ext/midi#pressure";
enum LV2_MIDI__programNumber    = "http://lv2plug.in/ns/ext/midi#programNumber";
enum LV2_MIDI__property         = "http://lv2plug.in/ns/ext/midi#property";
enum LV2_MIDI__songNumber       = "http://lv2plug.in/ns/ext/midi#songNumber";
enum LV2_MIDI__songPosition     = "http://lv2plug.in/ns/ext/midi#songPosition";
enum LV2_MIDI__status           = "http://lv2plug.in/ns/ext/midi#status";
enum LV2_MIDI__statusMask       = "http://lv2plug.in/ns/ext/midi#statusMask";
enum LV2_MIDI__velocity         = "http://lv2plug.in/ns/ext/midi#velocity";

enum MidiMsg {
    invalid         = 0,
    noteOff         = 0x80,
    noteOn          = 0x90,
    notePressure    = 0xA0,
    controller      = 0xB0,
    pgmChange       = 0xC0,
    channelPressure = 0xD0,
    bender          = 0xE0,
    systemExclusive = 0xF0,
    mtcQuarter      = 0xF1,
    songPos         = 0xF2,
    songSelect      = 0xF3,
    tuneRequest     = 0xF6,
    clock           = 0xF8,
    start           = 0xFA,
    continue_       = 0xFB,
    stop            = 0xFC,
    activeSense     = 0xFE,
    reset           = 0xFF,
}

/**
   Standard MIDI Controller Numbers.
*/
enum MidiController {
    msbBank            = 0x00,
    msbModwheel        = 0x01,
    msbBreath          = 0x02,
    msbFoot            = 0x04,
    msbPortamentoTime  = 0x05,
    msbDataEntry       = 0x06,
    msbMainVolume      = 0x07,
    msbBalance         = 0x08,
    msbPan             = 0x0A,
    msbExpression      = 0x0B,
    msbEffect1         = 0x0C,
    msbEffect2         = 0x0D,
    msbGeneralPurpose1 = 0x10,
    msbGeneralPurpose2 = 0x11,
    msbGeneralPurpose3 = 0x12,
    msbGeneralPurpose4 = 0x13,
    lsbBank            = 0x20,
    lsbModwheel        = 0x21,
    lsbBreath          = 0x22,
    lsbFoot            = 0x24,
    lsbPortamentoTime  = 0x25,
    lsbDataEntry       = 0x26,
    lsbMainVolume      = 0x27,
    lsbBalance         = 0x28,
    lsbPan             = 0x2A,
    lsbExpression      = 0x2B,
    lsbEffect1         = 0x2C,
    lsbEffect2         = 0x2D,
    lsbGeneralPurpose1 = 0x30,
    lsbGeneralPurpose2 = 0x31,
    lsbGeneralPurpose3 = 0x32,
    lsbGeneralPurpose4 = 0x33,
    sustain            = 0x40,
    portamento         = 0x41,
    sostenuto          = 0x42,
    softPedal          = 0x43,
    legatoFootswitch   = 0x44,
    hold2              = 0x45,
    sc1SoundVariation  = 0x46,
    sc2Timbre          = 0x47,
    sc3ReleaseTime     = 0x48,
    sc4AttackTime      = 0x49,
    sc5Brightness      = 0x4A,
    sc6                = 0x4B,
    sc7                = 0x4C,
    sc8                = 0x4D,
    sc9                = 0x4E,
    sc10               = 0x4F,
    generalPurpose5    = 0x50,
    generalPurpose6    = 0x51,
    generalPurpose7    = 0x52,
    generalPurpose8    = 0x53,
    portamentoControl  = 0x54,
    e1ReverbDepth      = 0x5B,
    e2TremoloDepth     = 0x5C,
    e3ChorusDepth      = 0x5D,
    e4DetuneDepth      = 0x5E,
    e5PhaserDepth      = 0x5F,
    dataIncrement      = 0x60,
    dataDecrement      = 0x61,
    nrpnLsb            = 0x62,
    nrpnMsb            = 0x63,
    rpnLsb             = 0x64,
    rpnMsb             = 0x65,
    allSoundsOff       = 0x78,
    resetControllers   = 0x79,
    localControlSwitch = 0x7A,
    allNotesOff        = 0x7B,
    omniOff            = 0x7C,
    omniOn             = 0x7D,
    mono1              = 0x7E,
    mono2              = 0x7F
}

bool midiIsVoiceMessage(const ubyte msg) {
    return msg >= 0x80 && msg < 0xF0;
}

/**
   Return true iff `msg` is a MIDI system message (which has no channel).
*/
bool midiIsSystemMessage(const ubyte msg) {
    switch (msg) {
    case 0xF4: case 0xF5: case 0xF7: case 0xF9: case 0xFD:
        return false;
    default:
        return (msg & 0xF0) == 0xF0;
    }
}

/**
   Return the type of a MIDI message.
   @param msg Pointer to the start (status byte) of a MIDI message.
*/
MidiMsg midiMessageType(const ubyte msg) {
    if (midiIsVoiceMessage(msg)) {
        return cast(MidiMsg)(msg & 0xF0);
    } else if (midiIsSystemMessage(msg)) {
        return cast(MidiMsg)msg;
    } else {
        return MidiMsg.invalid;
    }
}
