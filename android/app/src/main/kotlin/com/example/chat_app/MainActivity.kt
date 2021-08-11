package com.example.chat_app

import android.Manifest
import android.app.AlertDialog
import android.support.v4.*
import android.content.*
import android.content.pm.PackageManager
import android.net.wifi.WifiManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.reflect.*
import android.provider.Settings
import android.net.Uri
import android.os.Build
import androidx.annotation.RequiresApi
import android.R.style

class MainActivity: FlutterActivity() {
	
	private val CHANNEL = "first.flaviu.dev/multicastLock"
	private lateinit var multicastLock : WifiManager.MulticastLock
	private lateinit var wifi: WifiManager
	
	@RequiresApi(Build.VERSION_CODES.M)
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
			else if(call.method == "getWifiFunctionsReflection") {
				Log.d("Permision", ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_SETTINGS).toString())
//				if(ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_SETTINGS) == PackageManager.PERMISSION_DENIED) {
				if(!Settings.System.canWrite(activity)) {
//					if (ActivityCompat.shouldShowRequestPermissionRationale(
//							activity,
//							Manifest.permission.WRITE_SETTINGS
//						)
//					)
					AlertDialog.Builder(this, style.Theme_DeviceDefault_Light_Dialog_Alert)
						.setTitle("Permission needed")
						.setMessage("This permission is needed to configure hotspot settings")
						.setPositiveButton("Ok") { dialog: DialogInterface, which: Int ->
							Log.d("request", "Urmeaza Compat Request")
							val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
							intent.data = Uri.parse("package:" + context.packageName)
							this.context.startActivity(intent)
//								ActivityCompat.requestPermissions(
//									this,
//									Array(1) { Manifest.permission.WRITE_SETTINGS },
//									1
//								)
						}
						.setNegativeButton("Cancel") { dialog: DialogInterface, which: Int ->
							dialog.dismiss()
						}
						.create().show()
//					 else {
//						Log.d("request", "Urmeaza Compat Request")
//						val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
//						intent.data = Uri.parse("package:" + context.packageName)
//						this.context.startActivity(intent)
//						ActivityCompat.requestPermissions(
//							activity,
//							Array(1) { Manifest.permission.WRITE_SETTINGS },
//							1
//						)
//					 }
				}

//				this.wifi = this.context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
//				val apConfig: WifiConfiguration = WifiConfiguration()
//				apConfig.SSID = "testFunction"
//				apConfig.preSharedKey = "password1234"
//				apConfig.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK)
//
//				val classOfWifiManager: KClass<out WifiManager> = this.wifi::class
//				val classOfWifiConfiguration: KClass<out WifiConfiguration> = WifiConfiguration::class
//				val className = classOfWifiConfiguration.java
//				var functionsOfWifiManager = classOfWifiManager.java.methods
//				var functionSetWifiApConfiguration = classOfWifiManager.java.getMethod("setWifiApConfiguration", className)
//				var statusConfig = functionSetWifiApConfiguration.invoke(this.wifi, apConfig)
				result.success("statusConfig")
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
