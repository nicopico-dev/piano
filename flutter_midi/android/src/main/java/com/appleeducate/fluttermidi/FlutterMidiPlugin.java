package com.appleeducate.fluttermidi;

import android.util.Log;
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

            case METHOD_START_NOTE: {
                Integer note = call.argument("note");
                if (note != null) {
                    Log.i("PIANO", "Play note " + note);
                    String strNote = String.valueOf(note);
                    byte[] event = {
                            (byte) (0x90 | 0x00),// 0x90 = note On, 0x00 = channel 1
                            Byte.parseByte(strNote), // 0x3C = middle C
                            (byte) 0x7F, // 0x7F = the maximum velocity (127)
                    };
                    midiDriver.write(event);
                    result.success(null);
                }
                break;
            }
            case METHOD_STOP_NOTE: {
                // Construct a note OFF message for the middle C at minimum velocity on channel
                byte[] event = {
                        (byte) (0x80 | 0x00), // 0x80 = note Off, 0x00 = channel 1
                        (byte) 0x3C, // 0x3C = middle C
                        (byte) 0x00, // 0x00 = the minimum velocity (0)
                };
                midiDriver.write(event);
                result.success(null);
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    }
}
