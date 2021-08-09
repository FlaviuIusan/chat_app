package com.example.chat_app

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.net.wifi.WifiManager
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
import android.util.Log

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
			else if(call.method == "getWifiList") {
				this.wifi = this.context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
				// val results = wifi.scanResults
				// val count = results.size
				// //result.success(count)
				// val resultsNames = mutableListOf<String>()
				// val stringNames: String = "Rezultate: "
				// for (result in results) {
				// 	Log.d("WifiList", result.SSID)
				// 	resultsNames.add(result.SSID)
				// }
				// val stringOfNames = resultsNames.joinToString(", ")
				// result.success("$count $stringOfNames")

				val wifiScanReceiver = object : BroadcastReceiver() {

					override fun onReceive(context: Context, intent: Intent) {
					  val success = intent.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
					  if (success) {
						val results = wifi.scanResults
						val count = results.size
						//result.success(count)
						val resultsNames = mutableListOf<String>()
						val stringNames: String = "Rezultate: "
						for (result in results) {
							Log.d("WifiList", result.SSID)
							resultsNames.add(result.SSID)
						}
						val stringOfNames = resultsNames.joinToString(", ")
						context.unregisterReceiver(this)
						result.success("RESULT: $count $stringOfNames")
					  } else {
						val results = wifi.scanResults
						val count = results.size
						//result.success(count)
						val resultsNames = mutableListOf<String>()
						val stringNames: String = "Rezultate: "
						for (result in results) {
							Log.d("WifiList", result.SSID)
							resultsNames.add(result.SSID)
						}
						val stringOfNames = resultsNames.joinToString(", ")
						context.unregisterReceiver(this)
						result.success("RESULT: $count $stringOfNames")
					  }
					}
				}
				
				// try{
				// 	context.unregisterReceiver(wifiScanReceiver)
				// } catch(e: Exception) {
					
				// }

				val intentFilter = IntentFilter()
				intentFilter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
				context.registerReceiver(wifiScanReceiver, intentFilter)
				
				val success = wifi.startScan()
				Log.d("ScanResult", success.toString())
				if (!success) {
					val results = wifi.scanResults
					val count = results.size
					//result.success(count)
					val resultsNames = mutableListOf<String>()
					val stringNames: String = "Rezultate: "
					for (result in results) {
						Log.d("WifiList", result.SSID)
						resultsNames.add(result.SSID)
					}
					val stringOfNames = resultsNames.joinToString(", ")
					context.unregisterReceiver(wifiScanReceiver)
					result.success("RESULT: $count $stringOfNames")
				}
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
