#import "AppToolPlugin.h"
#if __has_include(<app_tool/app_tool-Swift.h>)
#import <app_tool/app_tool-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_tool-Swift.h"
#endif

@implementation AppToolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppToolPlugin registerWithRegistrar:registrar];
}
@end
