# react-native-piano-sampler

[![NPM](https://nodei.co/npm/react-native-piano-sampler.png?compact=true)](https://nodei.co/npm/react-native-piano-sampler/)

React Native Piano Sampler : Reads sf2 with FluidSynth(on Android) or sfz with AudioKit(on iOS)

- [x] iOS/iPadOS Implementation
- [x] Android Implementation  

## Installation

```sh
npm install --save react-native-piano-sampler
```

## Usage

### Prerequisites (iOS/iPadOS)
- First, Download [this(Upright Piano KW)](http://freepats.zenvoid.org/Piano/UprightPianoKW/UprightPianoKW-SFZ-20190703.tar.xz) soundfont. And unarchive as `UprightPianoKW-SFZ-20190703`.
  - The Folder structure must be like this.
  ```bash
    UprightPianoKW-SFZ-20190703
    ├── photo.jpg
    ├── readme.txt  
    ├── samples
    │   ├── A0vH.wav
    │   └── A0vL.wav
    │   ...
    └── UprightPianoKW-20190703.sfz
    ```
- After that, add this folder to your XCode Project.
- Double check that the folder is successfully imported to project.
  - Check the `UprightPianoKW-SFZ-20190703` folder is in your `Project File -> Build Phases -> Copy Bundle Resources`  
- Goto `Project File -> Signing & Capabilities`, then press the `+ Capability` button below the tab menu, and  press Background Modes. Check the `Audio, AirPlay, and Picture in Picture` checkbox.
- Goto the iOS project folder, and do `pod install`

### Prerequisites (Android)
- Download the [soudfont(Full Grand Piano)](https://drive.google.com/file/d/1JHae8NALSvLDuF9nFqtqqipcY9Fo1fuD/view?usp=sharing) and move to `{ProjDirectory}/android/app/src/main/assets`.
- You are good to go :smile:


### Usage in React Native Code

```js
import PianoSampler from "react-native-piano-sampler";

// ...

// Must do before playNote(), and stopNote()
PianoSampler.prepare();

// Play the piano sound from selected midiNum, and velocity until stopNote() is call.
// midiNum is midi Number, and velocity is the intensity.
PianoSampler.playNote(midiNum, velocity);
// Stop the pian sound
PianoSampler.stopNote(midiNum);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
