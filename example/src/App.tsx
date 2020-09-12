import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import PianoSampler from 'react-native-piano-sampler';

export default function App() {
  PianoSampler.prepare();
  PianoSampler.playNote(60, 127);
  setTimeout(() => {
    PianoSampler.stopNote(60);
  }, 2000);

  return (
    <View style={styles.container}>
      <Text>Application Load Complete</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
