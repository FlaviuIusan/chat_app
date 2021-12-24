package com.example.chat_app

import android.Manifest
import android.R.style
import android.app.AlertDialog
import android.content.*
import android.content.pm.PackageManager
import android.net.Uri
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.p2p.WifiP2pGroup
import android.net.wifi.p2p.WifiP2pManager
import android.net.wifi.p2p.nsd.WifiP2pDnsSdServiceInfo
import android.net.wifi.p2p.nsd.WifiP2pDnsSdServiceRequest
import android.os.Build
import android.os.Looper
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import java.util.*
import kotlin.concurrent.thread
import kotlin.reflect.KClass

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
				this.wifi = this.context.applicationContext.getSystemService(WIFI_SERVICE) as WifiManager
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
				Log.d("Permision", ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_SETTINGS).toString())
//				if(ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_SETTINGS) == PackageManager.PERMISSION_DENIED) {
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

				this.wifi = this.context.applicationContext.getSystemService(WIFI_SERVICE) as WifiManager
				val apConfig: WifiConfiguration = WifiConfiguration()
				apConfig.SSID = "testFunction"
				apConfig.preSharedKey = "password1234"
				apConfig.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK)

				val classOfWifiManager: KClass<out WifiManager> = this.wifi::class
				val classOfWifiConfiguration: KClass<out WifiConfiguration> = WifiConfiguration::class
				val className = classOfWifiConfiguration.java
				var functionsOfWifiManager = classOfWifiManager.java.methods
				var functionSetWifiApConfiguration = classOfWifiManager.java.getMethod("setWifiApConfiguration", className)
				var statusConfig = functionSetWifiApConfiguration.invoke(this.wifi, apConfig)
				result.success("statusConfig")
			}
			else if(call.method == "addLocalService") {
				val thisMainActivity = this
				thread {
					val wifiP2pManager = thisMainActivity.context.applicationContext.getSystemService(
						WIFI_P2P_SERVICE
					) as WifiP2pManager
					val wifiP2pChannel =
						wifiP2pManager.initialize(thisMainActivity, Looper.getMainLooper(), null)

					Log.d("Intermediar", "Intermediar1 verifica daca exista group")
					wifiP2pManager.requestGroupInfo(
						wifiP2pChannel,
						object : WifiP2pManager.GroupInfoListener {
							override fun onGroupInfoAvailable(group: WifiP2pGroup?) {
								Log.d(
									"GroupInfoAvailable",
									"AVAILABLE INAINTE CREATE ${group?.networkName} and ${group?.passphrase} and full $group"
								)

								wifiP2pManager.removeGroup(
									wifiP2pChannel,
									object : WifiP2pManager.ActionListener {
										override fun onSuccess() {
											Log.d("RemoveGroup", "Success")
											Log.d("Intermediar", "Intermediar2 a existat group si a fost eliminat")
											if (ActivityCompat.checkSelfPermission(
													thisMainActivity,
													Manifest.permission.ACCESS_FINE_LOCATION
												) != PackageManager.PERMISSION_GRANTED
											) {
											}
											wifiP2pManager.createGroup(
												wifiP2pChannel,
												object : WifiP2pManager.ActionListener {
													override fun onSuccess() {
														Log.d("CreateGroup", "Success")
														Log.d("Intermediar", "Intermediar3 Sa creat grupul")
														if (ActivityCompat.checkSelfPermission(
																thisMainActivity,
																Manifest.permission.ACCESS_FINE_LOCATION
															) != PackageManager.PERMISSION_GRANTED
														) {
														}
														val created = object {
															var haveInfo = false
														}
														try {
															Thread.currentThread().join(350)
														} catch (e: InterruptedException) {}
														wifiP2pManager.requestGroupInfo(
															wifiP2pChannel,
															object :
																WifiP2pManager.GroupInfoListener {
																override fun onGroupInfoAvailable(
																	group: WifiP2pGroup?
																) {
																	Log.d("INFOOOOO", "INFOOOOOOOOOOOO")
																	if (group != null) {
																		created.haveInfo = true
																		Log.d("haveInfo", "HAVE INFO: ${created.haveInfo}")
																		Log.d(
																			"GroupInfoAvailable",
																			"AVAILABLE DUPA CREATE ${group.networkName} and ${group.passphrase} and full $group"
																		)
																		val infoLocalService =
																			mapOf(
																				"info" to "infoValue",
																				"networkName" to group.networkName,
																				"networkPassphrase" to group.passphrase,
																				"networkInterface" to group.`interface`,
																			)
																		val wifiP2pLocalService =
																			WifiP2pDnsSdServiceInfo.newInstance(
																				"ChatApp",
																				"_rcp._udp_tcp",
																				infoLocalService
																			)
																		if (ContextCompat.checkSelfPermission(
																				activity,
																				Manifest.permission.ACCESS_FINE_LOCATION
																			) != PackageManager.PERMISSION_GRANTED
																		) {
																			//Error no permission granted
																		}
																		wifiP2pManager.addLocalService(
																			wifiP2pChannel,
																			wifiP2pLocalService,
																			object :
																				WifiP2pManager.ActionListener {
																				override fun onSuccess() {
																					Log.d(
																						"addLocalService",
																						"Success"
																					)
																					result.success(
																						"created"
																					)
																				}

																				override fun onFailure(
																					arg0: Int
																				) {
																					Log.d(
																						"addLocalService",
																						"Error: $arg0"
																					)
																					result.success(
																						"error"
																					)
																				}
																			}
																		)
																	}

																}
															})

													}

													override fun onFailure(reason: Int) {
														Log.d("CreateGroup", "Error: $reason")
														result.success("error")
													}

												})
										}

										override fun onFailure(reason: Int) {
											Log.d("RemoveGroup", "Error: $reason")
											Log.d("Intermediar", "Intermediar2 No group to remove, continue")
											if (ActivityCompat.checkSelfPermission(
													thisMainActivity,
													Manifest.permission.ACCESS_FINE_LOCATION
												) != PackageManager.PERMISSION_GRANTED
											) {
											}
											wifiP2pManager.createGroup(
												wifiP2pChannel,
												object : WifiP2pManager.ActionListener {
													override fun onSuccess() {
														Log.d("CreateGroup", "Success")
														Log.d("Intermediar", "Intermediar3 Sa creat grupul")
														if (ActivityCompat.checkSelfPermission(
																thisMainActivity,
																Manifest.permission.ACCESS_FINE_LOCATION
															) != PackageManager.PERMISSION_GRANTED
														) {
														}
														val created = object {
															var haveInfo = false
														}
														try {
															Thread.currentThread().join(350)
														} catch (e: InterruptedException) {}
														wifiP2pManager.requestGroupInfo(
															wifiP2pChannel,
															object :
																WifiP2pManager.GroupInfoListener {
																override fun onGroupInfoAvailable(
																	group: WifiP2pGroup?
																) {
																	Log.d("INFOOOOO", "INFOOOOOOOOOOOO")
																	if (group != null) {
																		created.haveInfo = true
																		Log.d("haveInfo", "HAVE INFO: ${created.haveInfo}")
																		Log.d(
																			"GroupInfoAvailable",
																			"AVAILABLE DUPA CREATE ${group.networkName} and ${group.passphrase} and full $group"
																		)
																		val infoLocalService =
																			mapOf(
																				"info" to "infoValue",
																				"networkName" to group.networkName,
																				"networkPassphrase" to group.passphrase,
																				"networkInterface" to group.`interface`,
																			)
																		val wifiP2pLocalService =
																			WifiP2pDnsSdServiceInfo.newInstance(
																				"ChatApp",
																				"_rcp._udp_tcp",
																				infoLocalService
																			)
																		if (ContextCompat.checkSelfPermission(
																				activity,
																				Manifest.permission.ACCESS_FINE_LOCATION
																			) != PackageManager.PERMISSION_GRANTED
																		) {
																			//Error no permission granted
																		}
																		wifiP2pManager.addLocalService(
																			wifiP2pChannel,
																			wifiP2pLocalService,
																			object :
																				WifiP2pManager.ActionListener {
																				override fun onSuccess() {
																					Log.d(
																						"addLocalService",
																						"Success"
																					)
																					result.success(
																						"created"
																					)
																				}

																				override fun onFailure(
																					arg0: Int
																				) {
																					Log.d(
																						"addLocalService",
																						"Error: $arg0"
																					)
																					result.success(
																						"error"
																					)
																				}
																			}
																		)
																	}

																}
															})

													}

													override fun onFailure(reason: Int) {
														Log.d("CreateGroup", "Error: $reason")
														result.success("error")
													}

												})
										}
									})

							}
						})
				}


			}
			else if(call.method == "addServiceRequest"){
				val shouldReturn = call.argument<String>("return")
					thread {
						val wifiP2pManager = this.context.applicationContext.getSystemService(
							WIFI_P2P_SERVICE
						) as WifiP2pManager
						val wifiP2pChannel = wifiP2pManager.initialize(this, this.mainLooper, null)
						val fullDomain = "ChatApp._rcp._udp_tcp"
						val txtListener =
							WifiP2pManager.DnsSdTxtRecordListener { fullDomain, record, device ->
								Log.d("addServiceRequest", "DnsSdTxtRecord available -$record")
								record["info"]?.also {
									if (shouldReturn?.compareTo("no") != 0){
										result.success(
											JsonObject(
												mapOf(
													"network_name" to JsonPrimitive(
														record["networkName"]
													),
													"networkPassphrase" to JsonPrimitive(
														record["networkPassphrase"]
													),
													"networkInterface" to JsonPrimitive(
														record["networkInterface"]
													)
												)
											).toString()
								 		)
								    }
								}
							}
						val serviceListener =
							WifiP2pManager.DnsSdServiceResponseListener { instanceName, registrationType, resourceType ->
								Log.d(
									"addServiceRequest",
									"onChatAppServiceAvailable $instanceName"
								)
							}

						wifiP2pManager.setDnsSdResponseListeners(
							wifiP2pChannel,
							serviceListener,
							txtListener
						)

						val serviceRequest =
							WifiP2pDnsSdServiceRequest.newInstance("ChatApp", "_rcp._udp_tcp")
						wifiP2pManager.addServiceRequest(
							wifiP2pChannel,
							serviceRequest,
							object : WifiP2pManager.ActionListener {
								override fun onSuccess() {
									Log.d(
										"addServiceRequest",
										"Local Service ChatApp Searching Service Request"
									)
								}

								override fun onFailure(code: Int) {
									// Command failed.  Check for P2P_UNSUPPORTED, ERROR, or BUSY
								}
							}
						)

						wifiP2pManager.discoverServices(
							wifiP2pChannel,
							object : WifiP2pManager.ActionListener {
								override fun onSuccess() {
									Log.d(
										"addServiceRequest",
										"Local Service ChatApp Searching Discover Services"
									)
								}

								override fun onFailure(code: Int) {
									// Command failed. Check for P2P_UNSUPPORTED, ERROR, or BUSY
									when (code) {
										WifiP2pManager.P2P_UNSUPPORTED -> {
											Log.d(
												"addServiceRequest",
												"P2P isn't supported on this device."
											)
										}
									}
								}
							}
						)
					}
			}
			else if(call.method == "connectToPeer"){
				thread {
					val wifiManager = this.context.applicationContext.getSystemService(
						WIFI_SERVICE
					) as WifiManager
					val wifiConfig: WifiConfiguration = WifiConfiguration()
					wifiConfig.SSID = String.format("\"%s\"", "DIRECT-Gn-Lenovo S1La40_f74d");
					wifiConfig.preSharedKey = String.format("\"%s\"", "gsciNfYd");
					Log.d(
						"WIFIIIIICONF",
						"CONFIG: $wifiConfig"
					)
					val networkId = wifiManager.addNetwork(wifiConfig)
					val succeed = wifiManager.enableNetwork(networkId, true)
					Log.d(
						"connectToPeer",
						"succeed VALUE: $succeed"
					)
				}
			}
			else if(call.method == "getMacAddress") {
				val thisMainActivity = this
				Log.d(
					"getMacAddress",
					"RAAAAAAAA"
				)
				object : Thread() {
					override fun run() {
						val wifiP2pManager = thisMainActivity.context.applicationContext.getSystemService(
							WIFI_P2P_SERVICE
						) as WifiP2pManager
						val wifiP2pChannel = wifiP2pManager.initialize(thisMainActivity, thisMainActivity.mainLooper, null)
						if (ActivityCompat.checkSelfPermission(
								thisMainActivity,
								Manifest.permission.ACCESS_FINE_LOCATION
							) != PackageManager.PERMISSION_GRANTED
						) {

						}
						wifiP2pManager.createGroup(
							wifiP2pChannel,
							object : WifiP2pManager.ActionListener {
								override fun onSuccess() {
									if (ActivityCompat.checkSelfPermission(
											thisMainActivity,
											Manifest.permission.ACCESS_FINE_LOCATION
										) != PackageManager.PERMISSION_GRANTED
									) {

									}
									try {
										sleep(300)
									} catch (e: InterruptedException) {}
									wifiP2pManager.requestGroupInfo(
										wifiP2pChannel,
										object : WifiP2pManager.GroupInfoListener {
											override fun onGroupInfoAvailable(group: WifiP2pGroup?) {
												val macAddress = group?.owner?.deviceAddress
												Log.d(
													"getMacAddress",
													"MAC Address: $macAddress"
												)

												wifiP2pManager.removeGroup(
													wifiP2pChannel,
													object : WifiP2pManager.ActionListener {
														override fun onSuccess() {
															result.success(macAddress)
														}

														override fun onFailure(reason: Int) {

														}

													})
											}

										})
								}

								override fun onFailure(reason: Int) {

								}

							})
					}
				}.start()
			}
			else {
				result.notImplemented()
			}
    	}
	}
	
	
	private fun lock(): String {
		try{
			this.wifi = this.context.applicationContext.getSystemService(WIFI_SERVICE) as WifiManager
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
