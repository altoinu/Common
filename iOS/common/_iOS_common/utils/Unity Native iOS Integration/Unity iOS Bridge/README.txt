1. Export iOS project from Unity
2. Add and set "Unity iOS Bridge" group to
Common/_Unity_common/Unity Native iOS Integration/Unity iOS Bridge/[version]
3. Further instructions in UnityiOSBridgeAppDelegate.h

- To send message to Unity from iOS
	UnitySendMessage(object_name, method_name[, argument1, argument2...]);

- To send message to iOS from Unity
	iOS:
		- Extend UnityiOSBridgeAppDelegate
		- In this extended class, define method
			extern "C" {
				int myAwesomeiOSFunction(int param1, char *param2, ...) {...}
			}
	Unity:
		
		[System.Runtime.InteropServices.DllImport("__Internal")]
		extern static public int myAwesomeiOSFunction(int param1, char *param2,...);
		
		#if UNITY_IPHONE
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			myAwesomeiOSFunction(param1, param2,...);
		}
		#endif