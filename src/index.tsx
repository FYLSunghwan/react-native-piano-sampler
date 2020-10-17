import { NativeModules } from 'react-native';

type PianoSamplerType = {
  playNote(midiNum: number, velocity: number): any;
  stopNote(midiNum: number): any;
  setVolume(vol: number): any;
  prepare(): any;
};

const { PianoSampler } = NativeModules;

export default PianoSampler as PianoSamplerType;
