#import "GameScene.h"

// Define ball width
#define BALL_WIDTH 7
// Define number of pockets
#define NUM_POCKETS 6
// Define pocket width
#define POCKET_WIDTH 10

// Define edges width
#define EDGE_WIDTH 3
// Define number of edges
#define NUM_EDGES 6
// Define distance between pocket and edge
#define DISTANCE_POCKET_EDGE 15

// Define number of red balls
#define NUM_RED_BALLS 15

// Define number of red balls rows
#define NUM_RED_ROWS 5 

// Define red ball value
#define RED_BALL_POINTS 1

// Define D area radius
#define D_RADIUS 50

@implementation GameScene {
    // Declare global variable for screen size
    CGSize _screenSize;
    
    // Declare the physics space
    CCPhysicsNode *_space;
    
    // Declare global batch node
    CCSpriteBatchNode *_batchNode;
    
    // Array of pockets
    NSMutableArray *_pockets;
    
    // Array of edges
    NSMutableArray *_edges;
    
    // Declare cue ball
    Ball *_cueBall;
    
    // Declare color balls
    Ball *_yellowBall;
    Ball *_greenBall;
    Ball *_brownBall;
    Ball *_blueBall;
    Ball *_pinkBall;
    Ball *_blackBall;

    // Declare array for red balls
    NSMutableArray *_redBalls;
    
    // Declare properties for default balls position
    CGPoint _positionWhite;
    CGPoint _positionRed;
    CGPoint _positionYellow;
    CGPoint _positionGreen;
    CGPoint _positionBrown;
    CGPoint _positionBlue;
    CGPoint _positionPink;
    CGPoint _positionBlack;

    // Declare flag
    BOOL _cueBallTouched;
    
    // Declare vector force
    CCDrawNode *_forceVector;
    
    // Declare game state
    GameState *_gameState;
    
    // Declare player turn
    PlayerTurn *_turn;
    
    // Declare points counter
    int _player1Points;
    int _player2Points;
    
    // Label to show the player1 score
    CCLabelTTF *_scoreLabelP1;
    
    // Label to show the player2 score
    CCLabelTTF *_scoreLabelP2;
}

+ (GameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    // Initialize screen size variable
    _screenSize = [CCDirector sharedDirector].viewSize;
    
    // Initialize the physics node
    _space = [CCPhysicsNode node];
    
    // Add the physics node to the scene
    [self addChild:_space];
    
    // Load texture atlas
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"snookerMunk-hd.plist"];
    
    // Load batch node with texture atlas
    _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"snookerMunk-hd.png"];
    
    // Add the batch node to the scene
    [self addChild:_batchNode];
    
    // Create a background for the table
    CCSprite *background = [CCSprite spriteWithImageNamed:@"SnookerMunkAtlas/snooker_table.png"];
    background.position = CGPointMake(_screenSize.width / 2, _screenSize.height / 2);
    [self addChild:background z:-1];

    // Initialize debug mode
    _space.debugDraw = NO;
 
    // Initialize pockets bodies
    [self initializePockets];
 
    // Initialize edges bodies
    [self initializeEdges];
    
    // Initialize balls
    [self initializeCueBall];
    [self initializeRedBalls];
    [self initializeColorBalls];
    
    // Enable touches management
    self.userInteractionEnabled = TRUE;
    
    // Initialize flag
    _cueBallTouched = FALSE;
    
    // Set collision delegate of space
    _space.collisionDelegate = self;
    
    // Initialize game state
    _gameState = notStarted;
    
    // Set initial turn
    _turn = player1Turn;
    
    // Initialize counters
    _player1Points = 0;
    _player2Points = 0;
    
    // Initialize score label
    _scoreLabelP1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"P1: %i", _player1Points] fontName:@"Arial" fontSize:15];
    _scoreLabelP1.color = [CCColor whiteColor];
    _scoreLabelP1.position = CGPointMake(_screenSize.width / 4, _screenSize.height);
    
    // Left-alligning the label
    _scoreLabelP1.anchorPoint = CGPointMake(0.0, 1.0);

    // Initialize score label
    _scoreLabelP2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"P2: %i", _player2Points] fontName:@"Arial" fontSize:15];
    _scoreLabelP2.color = [CCColor whiteColor];
    _scoreLabelP2.position = CGPointMake(3 * _screenSize.width / 4, _screenSize.height);
    
    // Right-alligning the label
    _scoreLabelP2.anchorPoint = CGPointMake(1.0, 1.0);
    
    // Add the score labels to the scene
    [self addChild:_scoreLabelP1];
    [self addChild:_scoreLabelP2];
    
    return self;
    
}

- (void)initializePockets {
    
    // Initialize the pockets array
    _pockets = [NSMutableArray arrayWithCapacity: NUM_POCKETS];
    
    // Initialize sprite to get content size
    CCSprite *pocket = [[CCSprite alloc] initWithImageNamed:@"SnookerMunkAtlas/pocket.png"];
    
    // Declare physics body
    CCPhysicsBody *pocketBody;
    
    // Initial pocket position
    CGPoint initialPocketPosition = CGPointMake(5 * pocket.contentSize.width / 2, pocket.contentSize.height);
    // Current pocket position
    CGPoint currentPocketPosition;
    
    for (int i = 0; i < 3; i++) {
        // Update current pocket position
        currentPocketPosition = initialPocketPosition;
        currentPocketPosition.y += i * (_screenSize.height / 2 - 2 * POCKET_WIDTH);
        for (int j = 0; j < 2; j++) {
            
            // Initialize pocket
            pocket = [[CCSprite alloc] initWithImageNamed:@"SnookerMunkAtlas/pocket.png"];
            // Set pocket position
            pocket.position = currentPocketPosition;
            // Initialize body as a circle
            pocketBody = [CCPhysicsBody bodyWithCircleOfRadius:BALL_WIDTH/2 andCenter:CGPointMake(pocket.contentSize.width/2.0f, pocket.contentSize.height/2.0f)];
            // Define pocket as a sensor
            pocketBody.sensor = TRUE;
            // Set collision type for the pocket
            pocketBody.collisionType = @"pocket";
            // Set type as static
            pocketBody.type = CCPhysicsBodyTypeStatic;
            // Link sprite with its physics body
            pocket.physicsBody = pocketBody;
            
            // Add pocket to the array
            [_pockets addObject:pocket];
            // Add pocket to the space
            [_space addChild:pocket];
    
            // Update current pocket postion
            currentPocketPosition.x = _screenSize.width - 5 * pocket.contentSize.width / 2;
        }
    }
}

- (void)initializeEdges {
    
    // Initialize the edges array
    _edges = [NSMutableArray arrayWithCapacity: NUM_EDGES];
    
    // Declare physics body
    CCPhysicsBody *edge;
    // Declare node to link body
    CCNode *edgeNode;
    
    // Initial edge position
    CGPoint initialEdgePosition = CGPointMake(5 * POCKET_WIDTH, 2 * POCKET_WIDTH + DISTANCE_POCKET_EDGE);
    // Current edge position
    CGPoint currentEdgePosition;
    
    CGFloat edgeHeight = _screenSize.height/2 - (3 * POCKET_WIDTH + DISTANCE_POCKET_EDGE);
    
    for (int i = 0; i < 2; i++) {
        // Update current pocket position
        currentEdgePosition = initialEdgePosition;
        currentEdgePosition.y += i * (edgeHeight + 2 * POCKET_WIDTH);
        for (int j = 0; j < 2; j++) {
            // Initialize edge
            edge = [CCPhysicsBody bodyWithRect:CGRectMake(currentEdgePosition.x, currentEdgePosition.y, EDGE_WIDTH, edgeHeight) cornerRadius:0.0];
            
            // Set collision type for the edge
            edge.collisionType = @"edge";
            // Set type as static
            edge.type = CCPhysicsBodyTypeStatic;
            // Configure physics properties
            edge.elasticity = 0.5;
            edge.friction = 0.5;
            
            // Initialize the rect node
            edgeNode = [CCNode node];
            // Link physic body to the node
            edgeNode.physicsBody = edge;
            
            // Add edge to the array
            [_edges addObject:edgeNode];
            // Add edge to the space
            [_space addChild:edgeNode];
            
            // Update current pocket position
            currentEdgePosition.x = _screenSize.width - 5 * POCKET_WIDTH;

        }
    }
    
    // Initialize BOTTOM edge
    edge = [CCPhysicsBody bodyWithRect:CGRectMake(5 * POCKET_WIDTH + DISTANCE_POCKET_EDGE, 2 * POCKET_WIDTH, _screenSize.width - (10 * POCKET_WIDTH + 2 * DISTANCE_POCKET_EDGE), EDGE_WIDTH) cornerRadius:0.0];
    
    // Set collision type for the edge
    edge.collisionType = @"edge";
    // Set type as static
    edge.type = CCPhysicsBodyTypeStatic;
    // Configure physics properties
    edge.elasticity = 0.5;
    edge.friction = 0.5;
    
    // Initialize the rect node
    edgeNode = [CCNode node];
    // Link physic body to the node
    edgeNode.physicsBody = edge;
    
    // Add edge to the array
    [_edges addObject:edgeNode];
    // Add edge to the space
    [_space addChild:edgeNode];
    
    
    // Initialize TOP edge
    edge = [CCPhysicsBody bodyWithRect:CGRectMake(5 * POCKET_WIDTH + DISTANCE_POCKET_EDGE, _screenSize.height - 2 * POCKET_WIDTH, _screenSize.width - (10 * POCKET_WIDTH + 2 * DISTANCE_POCKET_EDGE), EDGE_WIDTH) cornerRadius:0.0];
    
    // Set collision type for the edge
    edge.collisionType = @"edge";
    // Set type as static
    edge.type = CCPhysicsBodyTypeStatic;
    // Configure physics properties
    edge.elasticity = 0.5;
    edge.friction = 0.5;
    
    // Initialize the rect node
    edgeNode = [CCNode node];
    // Link physic body to the node
    edgeNode.physicsBody = edge;
    
    // Add edge to the array
    [_edges addObject:edgeNode];
    // Add edge to the space
    [_space addChild:edgeNode];
}

- (void)initializeCueBall {
    
    // Initialize cue ball
    _cueBall = [[Ball alloc] initBallWithColor:white];
    // Set initial position
    _positionWhite = CGPointMake(_screenSize.width / 2, _screenSize.height / 5);
    _cueBall.position = _positionWhite;
    // Add ball to space
    [_space addChild:_cueBall];
}

- (void)initializeRedBalls {
    
    // Initialize array of red balls
    _redBalls = [NSMutableArray arrayWithCapacity: NUM_RED_BALLS];
    
    // Set initial position for the red ball
    _positionRed = CGPointMake(_screenSize.width/2, 3 * _screenSize.height/4);
    CGPoint redBallCurrentPosition;
    Ball *redBall;
    
    for (int i = 0; i < NUM_RED_ROWS; i++) {
        // Update positions
        redBallCurrentPosition = _positionRed;
        redBallCurrentPosition.x -= i * BALL_WIDTH/2;
        redBallCurrentPosition.y += i * BALL_WIDTH;
        
        for (int j = 0; j < i + 1; j++) {
            // Initialize red bal
            redBall = [[Ball alloc] initBallWithColor:red];
            // Set position
            redBall.position = CGPointMake(redBallCurrentPosition.x, redBallCurrentPosition.y);
            // Add ball to space and array
            [_space addChild:redBall];
            [_redBalls addObject:redBall];
            
            // Update position
            redBallCurrentPosition.x += BALL_WIDTH;
            
        }        
    }
}

- (void)initializeColorBalls {
    
    // Initialize yellow ball
    _yellowBall = [[Ball alloc] initBallWithColor:yellow];
    _positionYellow = CGPointMake(2 * _screenSize.width / 3 - BALL_WIDTH, _screenSize.height / 4 + 3 * BALL_WIDTH / 2);
    _yellowBall.position = _positionYellow;
    [_space addChild:_yellowBall];
    
    // Initialize green ball
    _greenBall = [[Ball alloc] initBallWithColor:green];
    _positionGreen = CGPointMake(_screenSize.width / 3 + BALL_WIDTH, _screenSize.height / 4 + 3 * BALL_WIDTH / 2);
    _greenBall.position = _positionGreen;
    [_space addChild:_greenBall];
    
    // Initialize brown ball
    _brownBall = [[Ball alloc] initBallWithColor:brown];
    _positionBrown = CGPointMake(_screenSize.width / 2, _screenSize.height / 4 + 3 * BALL_WIDTH / 2);
    _brownBall.position = _positionBrown;
    [_space addChild:_brownBall];
    
    // Initialize blue ball
    _blueBall = [[Ball alloc] initBallWithColor:blue];
    _positionBlue = CGPointMake(_screenSize.width / 2, _screenSize.height / 2);
    _blueBall.position = _positionBlue;
    [_space addChild:_blueBall];
    
    // Initialize pink ball
    _pinkBall = [[Ball alloc] initBallWithColor:pink];
    _positionPink = CGPointMake(_screenSize.width/2, _positionRed.y - BALL_WIDTH);
    _pinkBall.position = _positionPink;
    [_space addChild:_pinkBall];
    
    // Initialize black ball
    _blackBall = [[Ball alloc] initBallWithColor:black];
    _positionBlack = CGPointMake(_screenSize.width / 2, 9 * _screenSize.height / 10 - BALL_WIDTH);
    _blackBall.position = _positionBlack;
    [_space addChild:_blackBall];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Check if the touch is placed inside the cue ball
    [_cueBall.physicsNode pointQueryAt:touch.locationInWorld within:0.1f block:^(CCPhysicsShape *shape, CGPoint point, CGFloat distance)
     {
         CCLOG(@"CUE BALL TOUCHED");
         _cueBallTouched = TRUE;
     }];
    
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint newTouchLocation = [touch locationInNode:self];
    if (_gameState == notStarted || _gameState == fault) {
        if (CGRectContainsPoint(_cueBall.boundingBox, newTouchLocation)) {
            _cueBall.position = newTouchLocation;
        }
    } else if (_cueBallTouched) {
        // Get the touch location
        CGPoint newTouchLocation = [touch locationInNode:self];
        // Remove existing vector
        if(_forceVector.parent) {
            [_forceVector removeFromParent];
        }
        // Create node
        _forceVector = [CCDrawNode node];
        // Draw a vector from touch position to cue ball
        [_forceVector drawSegmentFrom:_cueBall.position to:newTouchLocation radius:2.0 color:[CCColor whiteColor]];
        [_space addChild:_forceVector];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
 
    if (_gameState == notStarted || _gameState == fault) {
        // Get the difference between the touched location and the pad center
        CGPoint point = CGPointMake(touchLocation.x - _positionBrown.x, touchLocation.y - _positionBrown.y);
        // Convert point to radians
        CGFloat radians = ccpToAngle(point);
        // Calculate degrees
        CGFloat degrees = CC_RADIANS_TO_DEGREES(radians);
        
        // Calculate direction
        if (degrees <= 0 && degrees >= -180 && ccpDistance(touchLocation, _positionBrown) < D_RADIUS) {
            _cueBall.position = touchLocation;
            _gameState = cueBall;
        } else {
            _cueBall.position = _positionWhite;
        }
        
    } else if (_cueBallTouched) {
        // Calculate the vector
        CGPoint vector = CGPointMake(_cueBall.position.x - touchLocation.x, _cueBall.position.y - touchLocation.y);
        // Apply physic impulse to the cue ball
        [_cueBall.physicsBody applyImpulse:ccp(vector.x, vector.y)];
        
        // Remove existing vector
        if(_forceVector.parent) {
            [_forceVector removeFromParent];
        }
    }
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair white:(CCNode *)ballWhite pocket:(CCNode *)pocket{
    // Set velocities to 0
    _cueBall.physicsBody.velocity = CGPointZero;
    _cueBall.physicsBody.angularVelocity = 0.0;
    // Set body to sleep
    _cueBall.physicsBody.sleeping = TRUE;
    // Set the original position
    _cueBall.position = _positionWhite;

    //Change turn
    if(_turn == player1Turn) {
        _turn = player2Turn;
    } else {
        _turn = player1Turn;
    }
    // State fault
    _gameState = fault;

    return TRUE;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair red:(CCNode *)ballRed pocket:(CCNode *)pocket{
    // If there haven't been a fault
    if ((int)_gameState != fault) {
        // Add points to the corresponding player
        if(_turn == player1Turn) {
            _player1Points += RED_BALL_POINTS;
        } else {
            _player2Points += RED_BALL_POINTS;
        }
        // Update the game state
        _gameState = redBallInPocket;
        
        // Remove the red ball from the array and the space
        [_redBalls removeObject:ballRed];
        [_space removeChild:ballRed];
    }
    
    // Update scores
    [self updateScores];
    
    return TRUE;
}

-(void) updateScores{
    // Update scores
    [_scoreLabelP1 setString:[NSString stringWithFormat:@"P1: %i", _player1Points]];
    [_scoreLabelP2 setString:[NSString stringWithFormat:@"P2: %i", _player2Points]];
}


-(void) update: (CCTime) delta {

}

@end
