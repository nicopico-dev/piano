//
//  AudioUnitMIDISynth.swift
//  MIDISynth
//
//  Created by Gene De Lisa on 2/6/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//
import Foundation
import AudioToolbox
import CoreAudio

private let SOUND_FONT_FILE_NAME = "sound_font"
private let SOUND_FONT_FILE_EXT = "SF2"

private let MIDI_COMMAND_NOTE_ON = UInt32(0x90)
private let MIDI_COMMAND_NOTE_OFF = UInt32(0x80)
private let MIDI_COMMAND_PROGRAM_CHANGE = UInt32(0x0C)
private let MIDI_VELOCITY_MAX = UInt32(0x7F)
private let MIDI_VELOCITY_MIN = UInt32(0x00)

class AudioUnitMIDISynth {
    
    private var midiSynthUnit: AudioUnit?
    
    func prepare() throws {
        loadMidiSynth()
        loadSoundFont()
        loadPatch(0)
    }
    
    func startPlayingNote(midiNote: UInt32) {
        checkError(MusicDeviceMIDIEvent(
            self.midiSynthUnit!,
            MIDI_COMMAND_NOTE_ON,
            midiNote,
            MIDI_VELOCITY_MAX,
            0
        ))
    }
    
    func stopPlayingNote(midiNote: UInt32) {
        checkError(MusicDeviceMIDIEvent(
            self.midiSynthUnit!,
            MIDI_COMMAND_NOTE_OFF,
            midiNote,
            MIDI_VELOCITY_MIN,
            0
        ))
    }
    
    private func loadMidiSynth() {
        // See https://blog.codeship.com/building-a-midi-music-app-for-ios-in-swift/
        // Create the graph
        var processingGraph: AUGraph? = nil
        checkError(NewAUGraph(&processingGraph))
        
        // Create audio nodes
        let ioNode = createAUNode(
            graph: processingGraph!,
            audioUnitType: kAudioUnitType_Output,
            audioUnitSubType: kAudioUnitSubType_RemoteIO
        )
        let synthNode = createAUNode(
            graph: processingGraph!,
            audioUnitType: kAudioUnitType_MusicDevice,
            audioUnitSubType: kAudioUnitSubType_MIDISynth
        )
        
        // Create the midi synth unit
        checkError(AUGraphOpen(processingGraph!))
        checkError(AUGraphNodeInfo(processingGraph!, synthNode, nil, &midiSynthUnit))
        
        // Connect the synthNode to the ioNode, and start the graph
        let synthOutputElement:AudioUnitElement = 0
        let ioUnitInputElement:AudioUnitElement = 0
        checkError(AUGraphConnectNodeInput(processingGraph!, synthNode, synthOutputElement, ioNode, ioUnitInputElement))
        checkError(AUGraphInitialize(processingGraph!))
        checkError(AUGraphStart(processingGraph!))
    }
    
    private func createAUNode(graph: AUGraph, audioUnitType: UInt32, audioUnitSubType: UInt32) -> AUNode {
        var componentDescription = AudioComponentDescription(
            componentType: OSType(audioUnitType),
            componentSubType: OSType(audioUnitSubType),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0
        )
        var node = AUNode()
        checkError(AUGraphAddNode(graph, &componentDescription, &node))
        return node
    }
    
    private func loadSoundFont() {
        guard var bankURL = Bundle.main.url(forResource: SOUND_FONT_FILE_NAME, withExtension: SOUND_FONT_FILE_EXT) else {
            print("Could not find sound font file")
            return
        }
        checkError(AudioUnitSetProperty(
            midiSynthUnit!,
            AudioUnitPropertyID(kMusicDeviceProperty_SoundBankURL),
            AudioUnitScope(kAudioUnitScope_Global),
            0,
            &bankURL,
            UInt32(MemoryLayout<URL>.size)
        ))
    }
    
    private func loadPatch(_ patch: UInt32) {
        // Pre-load the patch/voice
        var enabled = UInt32(1)
        checkError(AudioUnitSetProperty(
            midiSynthUnit!,
            AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
            AudioUnitScope(kAudioUnitScope_Global),
            0,
            &enabled,
            UInt32(MemoryLayout<UInt32>.size)
        ))
        checkError(MusicDeviceMIDIEvent(midiSynthUnit!, MIDI_COMMAND_PROGRAM_CHANGE, patch, 0, 0))
        
        // Disable pre-loading to actually load the patch/voice
        var disabled = UInt32(0)
        checkError(AudioUnitSetProperty(
            midiSynthUnit!,
            AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload),
            AudioUnitScope(kAudioUnitScope_Global),
            0,
            &disabled,
            UInt32(MemoryLayout<UInt32>.size)
        ))
        checkError(MusicDeviceMIDIEvent(midiSynthUnit!, MIDI_COMMAND_PROGRAM_CHANGE, patch, 0, 0))
    }
    
    private func checkError(_ status : OSStatus) {
        if (status == noErr) {
            return
        }
        print("Error: \(status)")
        abort()
    }
}