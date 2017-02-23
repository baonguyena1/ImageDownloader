//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifdef __OBJC__
@import UIKit;
@import Foundation;
#endif

#if DEBUG

#define Log(fmt, ...)      NSLog((@"%s [Line %d|%@]:\t" fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, YESORNO(NSThread.isMainThread), ##__VA_ARGS__);

#else

#define Log(...)

#endif
