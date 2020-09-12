package com.reactnativepianosampler

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class PianoSamplerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "PianoSampler"
    }

    @ReactMethod
    fun playNote(midiNum: Int, velocity: Int) {
        print("Kotlin> playNote");
    }

    @ReactMethod
    fun stopNote(midiNum: Int) {
        print("Kotlin> stopNote");
    }

    @ReactMethod
    fun prepare() {
        print("Kotlin> prepare");
    }
}
