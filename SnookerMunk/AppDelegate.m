#import "AppDelegate.h"
#import "GameScene.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setupCocos2dWithOptions:@{
		CCSetupShowDebugStats: @(YES),
		CCSetupScreenOrientation: CCScreenOrientationPortrait,

	}];
	
	return YES;
}

-(CCScene *)startScene
{
	// This method should return the very first scene to be run when your app starts.
	return [GameScene scene];
}

@end
