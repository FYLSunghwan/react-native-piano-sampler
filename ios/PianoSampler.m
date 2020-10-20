#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PianoSampler, NSObject)

RCT_EXTERN_METHOD(playNote:(NSInteger *)midiNum
                  velocity:(NSInteger *)velocity
)

RCT_EXTERN_METHOD(stopNote:(NSInteger *)midiNum)

RCT_EXTERN_METHOD(setVolume:(double)volume)

RCT_EXTERN_METHOD(prepare)

@end
