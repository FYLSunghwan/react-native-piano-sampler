import { NativeModules } from 'react-native';

type PianoSamplerType = {
  multiply(a: number, b: number): Promise<number>;
};

const { PianoSampler } = NativeModules;

export default PianoSampler as PianoSamplerType;
