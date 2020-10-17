//
//  Conductor.swift
//  Banju
//
//  Created by 김성환 on 2020/08/18.
//

import AudioKit

class Conductor {
    
    // Globally accessible
    static let sharedInstance = Conductor()

    var sampler1 = AKSampler(masterVolume: 1.0)

    init() {
        print("Conductor.init()")
    
        // Session settings
        AKAudioFile.cleanTempDirectory()
        AKSettings.bufferLength = .medium
        AKSettings.enableLogging = false
        
        // Allow audio to play while the iOS device is muted.
        AKSettings.playbackWhileMuted = true
     
        do {
            try AKSettings.setSession(category: .playAndRecord, with: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
        } catch {
            AKLog("Could not set session category.")
        }
 
        // Signal Chain

       
        // Set Output & Start AudioKit
        AKManager.output = sampler1
        do {
            try AKManager.start()
        } catch {
            print("AudioKit.start() failed")
        }
        
        // Set a few sampler parameters
        sampler1.releaseDuration = 0.5
    }

    func playNote(note: MIDINoteNumber, velocity: MIDIVelocity) {
        sampler1.play(noteNumber: note, velocity: velocity)
    }

    func stopNote(note: MIDINoteNumber) {
        sampler1.stop(noteNumber: note)
    }

    func setVolume(volume: Double) {
        var _volume = volume
        if(_volume > 1) {
            _volume = 1
        }
        if(_volume < 0) {
            _volume = 0
        }
        sampler1.masterVolume = _volume
    }

    func useSound(_ sound: String) {
        let soundsFolder = Bundle.main.bundleURL.appendingPathComponent("UprightPianoKW-SFZ-20190703").path
        sampler1.unloadAllSamples()
        sampler1.betterLoadUsingSfzFile(folderPath: soundsFolder, sfzFileName: sound + ".sfz")
    }
    
    func allNotesOff() {
        for note in 0 ... 127 {
            sampler1.stop(noteNumber: MIDINoteNumber(note))
        }
    }
}

extension AKSampler
{
    open func betterLoadUsingSfzFile(folderPath: String, sfzFileName: String) {
        var lokey: Int32 = 0
        var hikey: Int32 = 127
        var pitch: Int32 = 60
        var lovel: Int32 = 0
        var hivel: Int32 = 127
        var sample: String = ""
        var loopmode: String = ""
        var loopstart: Float32 = 0
        var loopend: Float32 = 0

        let baseURL = URL(fileURLWithPath: folderPath)
        let sfzURL = baseURL.appendingPathComponent(sfzFileName)
        do {
            let data = try String(contentsOf: sfzURL, encoding: .ascii)
            let lines = data.components(separatedBy: .newlines)
            for line in lines {
                let trimmed = String(line.trimmingCharacters(in: .whitespacesAndNewlines))
                if trimmed == "" || trimmed.hasPrefix("//") {
                    // ignore blank lines and comment lines
                    continue
                }
                for part in trimmed.components(separatedBy: .whitespaces) {
                    if part.hasPrefix("<global>") {
                        lokey = 0
                        hikey = 127
                        pitch = 60
                        lovel = 0
                        hivel = 127
                        sample = ""
                        loopstart = 0
                        loopend = 0
                    }
                    // group and region don't really tell us anything in the Kawai files
                    //if part.hasPrefix("<group>") {
                    //}
                    //else if part.hasPrefix("<region>") {
                    //}
                    else if part.hasPrefix("key=") {
                        pitch = Int32(part.components(separatedBy: "=")[1])!
                        lokey = pitch
                        hikey = pitch
                    } else if part.hasPrefix("lokey") {
                        lokey = Int32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("hikey") {
                        hikey = Int32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("pitch_keycenter") {
                        pitch = Int32(part.components(separatedBy: "=")[1])!
                    }
                    else if part.hasPrefix("lovel") {
                        lovel = Int32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("hivel") {
                        hivel = Int32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("loop_mode") {
                        loopmode = part.components(separatedBy: "=")[1]
                    } else if part.hasPrefix("loop_start") {
                        loopstart = Float32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("loop_end") {
                        loopend = Float32(part.components(separatedBy: "=")[1])!
                    } else if part.hasPrefix("sample") {
                        sample = trimmed.components(separatedBy: "sample=")[1].replacingOccurrences(of: "\\", with: "/")
                    }
                }

                if sample != "" {
                    let noteFreq = Float(AKPolyphonicNode.tuningTable.frequency(forNoteNumber: MIDINoteNumber(pitch)))
                    print("load \(pitch) \(noteFreq) Hz range \(lokey)-\(hikey) vel \(lovel)-\(hivel) \(sample)")

                    let sd = AKSampleDescriptor(noteNumber: pitch,
                                                noteFrequency: noteFreq,
                                                minimumNoteNumber: lokey,
                                                maximumNoteNumber: hikey,
                                                minimumVelocity : lovel,
                                                maximumVelocity: hivel,
                                                isLooping: loopmode != "" && loopmode != "no_loop",
                                                loopStartPoint: loopstart,
                                                loopEndPoint: loopend,
                                                startPoint: 0.0,
                                                endPoint: 0.0)
                    let sampleFileURL = baseURL.appendingPathComponent(sample)
                    if sample.hasSuffix(".wv") {
                        loadCompressedSampleFile(from: AKSampleFileDescriptor(sampleDescriptor: sd, path: sampleFileURL.path))
                    } else {
                        if sample.hasSuffix(".aif") || sample.hasSuffix(".wav") {
                            let compressedFileURL = baseURL.appendingPathComponent(String(sample.dropLast(4) + ".wv"))
                            let fileMgr = FileManager.default
                            if fileMgr.fileExists(atPath: compressedFileURL.path) {
                                loadCompressedSampleFile(from: AKSampleFileDescriptor(sampleDescriptor: sd, path: compressedFileURL.path))
                            } else {
                                let sampleFile = try AKAudioFile(forReading: sampleFileURL)
                                loadAKAudioFile(from: sd, file: sampleFile)
                            }
                        }
                    }
                    sample = ""
                }
            }
        } catch {
            print(error)
        }

        buildKeyMap()
    }
}
