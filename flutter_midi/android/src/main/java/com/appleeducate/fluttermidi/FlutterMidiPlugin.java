package com.appleeducate.fluttermidi;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import org.billthefarmer.mididriver.MidiDriver;

public class FlutterMidiPlugin implements MethodCallHandler {

    private static final String CHANNEL = "fr.nicopico.piano/flutter_midi";
    private static final String METHOD_PREPARE = "prepare_midi";
    private static final String METHOD_START_NOTE = "play_midi_note";
    private static final String METHOD_STOP_NOTE = "stop_midi_note";

    private static final byte MIDI_COMMAND_NOTE_ON = (byte) 0x90;
    private static final byte MIDI_COMMAND_NOTE_OFF = (byte) 0x80;
    private static final byte MIDI_VELOCITY_MAX = (byte) 0x7F;
    private static final byte MIDI_VELOCITY_MIN = (byte) 0x00;

    private final MidiDriver midiDriver;

    private FlutterMidiPlugin() {
        this.midiDriver = new MidiDriver();
    }

    @SuppressWarnings("unused")
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new FlutterMidiPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case METHOD_PREPARE:
                midiDriver.start();
                result.success(null);
                break;

            case METHOD_START_NOTE:
                try {
                    midiDriver.write(new byte[]{
                            MIDI_COMMAND_NOTE_ON,
                            getMidiNote(call),
                            MIDI_VELOCITY_MAX
                    });
                    result.success(null);
                }
                catch (InvalidNoteException e) {
                    result.error("MISSING_ARGUMENT", "The note argument is mandatory", null);
                }
                break;

            case METHOD_STOP_NOTE:
                try {
                    midiDriver.write(new byte[]{
                            MIDI_COMMAND_NOTE_OFF,
                            getMidiNote(call),
                            MIDI_VELOCITY_MIN
                    });
                    result.success(null);
                }
                catch (InvalidNoteException e) {
                    result.error("MISSING_ARGUMENT", "The note argument is mandatory", null);
                }
                break;


            default:
                result.notImplemented();
                break;
        }
    }

    private static byte getMidiNote(MethodCall call) throws InvalidNoteException {
        Integer note = call.argument("note");
        if (note != null) {
            return Byte.parseByte(String.valueOf(note));
        } else {
            throw new InvalidNoteException();
        }
    }

    private static class InvalidNoteException extends Exception {
    }
}
