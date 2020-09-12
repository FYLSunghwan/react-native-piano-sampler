package com.reactnativepianosampler

import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import okio.Okio
import java.io.File

class PianoSamplerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), LifecycleEventListener {

    companion object {

        private const val SF2_FILE_NAME = "Full Grand Piano.sf2"

        // Used to load the 'fluidsynth' library on application startup.
        // Check the CMakeLists.txt that is referenced in app/build.gradle,
        // within it there is the statement 'add_library' which specifies
        // this identifier.
        init {
            System.loadLibrary("fluidsynth")
        }
    }

    private var context:ReactApplicationContext = reactContext

    private val nativeLibJNI = NativeLibJNI()
    private lateinit var sf2file: File

    init {
        context.addLifecycleEventListener(this);
    }

    override fun getName(): String {
        return "PianoSampler"
    }

    @ReactMethod
    fun playNote(midiNum: Int, velocity: Int) {
        nativeLibJNI.noteOn(midiNum, velocity)
    }

    @ReactMethod
    fun stopNote(midiNum: Int) {
        nativeLibJNI.noteOff(midiNum);
    }

    @ReactMethod
    fun prepare() {
        sf2file = File(context.filesDir, SF2_FILE_NAME)
        copySF2IfNecessary() // sf2 file needs to be in internal directory, not assets
        nativeLibJNI.init(sf2file.absolutePath)
    }

    private fun copySF2IfNecessary() {
        if (sf2file.exists() && sf2file.length() > 0) return
        Okio.source(context.assets.open(SF2_FILE_NAME)).use { a ->
            Okio.buffer(Okio.sink(sf2file)).use { b ->
                b.writeAll(a)
            }
        }
    }

  override fun onHostResume() {

  }

  override fun onHostPause() {

  }

  override fun onHostDestroy() {
      nativeLibJNI.destroy()
  }

}
