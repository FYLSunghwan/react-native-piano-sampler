@objc(PianoSampler)
class PianoSampler: NSObject {

    @objc(playNote:velocity:)
    func playNote(_ midiNum: NSInteger, velocity: NSInteger) {
        print("Swift>playNote")
    }
  
    @objc(stopNote:)
    func stopNote(_ midiNum: NSInteger) {
        print("Swift>stopNote")
    }
    
    @objc
    func prepare() {
        print("Swift>prepare")
    }

    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
