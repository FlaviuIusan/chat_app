package com.example.chat_app

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.net.wifi.WifiManager

class MainActivity: FlutterActivity() {
	
	private val CHANNEL = "first.flaviu.dev/multicastLock"
	private lateinit var multicastLock : WifiManager.MulticastLock
	private lateinit var wifi: WifiManager
	
	override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
			// Note: this method is invoked on the main thread.
			call, result ->
			if (call.method == "multicastLock") {
				val multicast = this.lock();
				result.success(multicast)
			}
			else if(call.method == "multicastRelease") {
				val multicast = this.release();
				result.success(multicast)
			} 
			else {
				result.notImplemented()
			}
    	}
	}
	
	
	private fun lock(): String {
		try{
			this.wifi = this.context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
			this.multicastLock = wifi.createMulticastLock("MyMulticastLock")
			this.multicastLock.acquire()
		} catch(e: Exception) {
			return e.toString()
		}
		
		return "true"
  	}
	  
	private fun release(): String {
		try{
			this.multicastLock.release()
		} catch(e: Exception) {
			return e.toString()
		}
		
		return "true"
  	}
	
}
