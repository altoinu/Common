Unity project to iOS integration

- Using native view controller on top of Unity view

1. Export Unity Project as iOS, Symlink Unity Libraries option checked
2. In iOS project, Build Settings/Objective-C Automatic Reference Counting -> Yes
3. Build Phases/Compile Sources - add compiler flag "-fno-objc-arc" on Unity .m .mm files
(disables ARC)
4. Right click "Unity iOS Bridge" group/Add Files to "...
Add UnityiOSBridgeAppDelegate.h and UnityiOSBridgeAppDelegate.m
from "Unity iOS Bridge/[ver]" folder in Common library
ex. "...Common/iOS/common/_iOS_common/utils/Unity Native iOS Integration/Unity iOS Bridge/0.2"
5. Add necessary code to main.mm, UnityAppController.h, and UnityAppController.mm
as described in UnityiOSBridgeAppDelegate.h comments
6. Create custom app delegate that extends UnityiOSBridgeAppDelegate,
set this name in main.mm

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