#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"

typedef enum {
    notStarted = 0,
    cueBall,
    redBallInPocket,
    fault
} GameState;

typedef enum {
    player1Turn = 0,
    player2Turn
} PlayerTurn;
@interface GameScene : CCScene <CCPhysicsCollisionDelegate> {
}

+ (GameScene *)scene;
- (id)init;

@end
