#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    white = 0,
    red,
    yellow,
    green,
    brown,
    blue,
    pink,
    black
} BallColors;
@interface Ball : CCSprite {
    
}
// Property for ball color
@property (readwrite, nonatomic) BallColors *ballColor;
// Property for number of points
@property (readonly, nonatomic) unsigned int points;

// Declare init method
- (Ball *) initBallWithColor:(BallColors)color;
@end
