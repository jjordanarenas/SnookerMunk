#import "Ball.h"

@implementation Ball

// Define ball width
#define BALL_WIDTH 7

- (Ball *) initBallWithColor:(BallColors)color {
    self = [super init];
    if (!self) return(nil);
    
    NSString *fileName;
    NSString *collisionType;
    switch (color) {
        case white:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballWhite.png";
            _points = 0;
            _ballColor = white;
            collisionType = @"white";
            break;
        case red:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballRed.png";
            _points = 1;
            _ballColor = red;
            collisionType = @"red";
            break;
        case yellow:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballYellow.png";
            _points = 2;
            _ballColor = yellow;
            collisionType = @"yellow";
            break;
        case green:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballGreen.png";
            _points = 3;
            _ballColor = green;
            collisionType = @"green";
            break;
        case brown:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballBrown.png";
            _points = 4;
            _ballColor = brown;
            collisionType = @"brown";
            break;
        case blue:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballBlue.png";
            _points = 5;
            _ballColor = blue;
            collisionType = @"blue";
            break;
        case pink:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballPink.png";
            _points = 6;
            _ballColor = pink;
            collisionType = @"pink";
            break;
        case black:
            // Assign image name, points and color
            fileName = @"SnookerMunkAtlas/ballBlack.png";
            _points = 7;
            _ballColor = black;
            collisionType = @"black";
            break;       
        default:
            break;
    }
    // Initialize sprite with the file name
    self = (Ball *)[[CCSprite alloc] initWithImageNamed:fileName];
    
    // Initialize the ball's physics body
    CCPhysicsBody *ballBody = [CCPhysicsBody bodyWithCircleOfRadius:BALL_WIDTH andCenter:CGPointMake(self.contentSize.width/2.0f, self.contentSize.height/2.0f)];
    // Set collision type
    ballBody.collisionType = collisionType;
    // Configure physics properties
    ballBody.friction = 0.8;
    ballBody.density = 0.8;
    ballBody.elasticity = 0.5;
    // Set to sleep
    ballBody.sleeping = TRUE;
    // Link sprite with body
    self.physicsBody = ballBody;

    return self;
}

@end
