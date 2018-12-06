import Flutter
import UIKit
import AVFoundation

private let CHANNEL = "fr.nicopico.piano/flutter_midi"
private let METHOD_PREPARE = "prepare_midi"
private let METHOD_START_NOTE = "play_midi_note"
private let METHOD_STOP_NOTE = "stop_midi_note"

public class SwiftFlutterMidiPlugin : NSObject, FlutterPlugin {
    
    private let au = AudioUnitMIDISynth();
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.addMethodCallDelegate(
            SwiftFlutterMidiPlugin(),
            channel: FlutterMethodChannel(
                name: CHANNEL,
                binaryMessenger: registrar.messenger()
            )
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case METHOD_PREPARE:
            do {
                try au.prepare()
                result(nil)
            } catch {
                result(FlutterError(
                    code: "INITIALIZATION_ERROR",
                    message: "Unable to initialize Midi Synthetizer",
                    details: error
                ))
            }
            
        case METHOD_START_NOTE:
            guard let note: UInt32 = call.argument("note") else {
                result(FlutterError(
                    code: "MISSING_ARGUMENT",
                    message: "The note argument is mandatory",
                    details: nil
                ))
                break
            }
            au.startPlayingNote(midiNote: note)
            result(nil)
            
        case METHOD_STOP_NOTE:
            guard let note: UInt32 = call.argument("note") else {
                result(FlutterError(
                    code: "MISSING_ARGUMENT",
                    message: "The note argument is mandatory",
                    details: nil
                ))
                break
            }
            au.stopPlayingNote(midiNote: note)
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension FlutterMethodCall {
    func argument<T>(_ name: String) -> T? {
        let args = self.arguments as! [String : Any]
        return args[name] as? T
    }
}
