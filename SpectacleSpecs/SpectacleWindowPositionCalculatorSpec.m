#import "SpectacleWindowPositionCalculator.h"

SpecBegin(SpectacleWindowPositionCalculator)
    describe(@"SpectacleWindowPositionCalculator", ^{
        CGRect visibleFrameScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
        CGRect windowRect = CGRectMake(0.0f, 441.0f, 720.0f, 436.0f);

        it(@"should calculate a centered window's CGRect", ^{
            CGRect expectedWindowRect = CGRectMake(360.0f, 222.0f, 720.0f, 436.0f);
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionCenter];

            expect(result.windowRect).to.equal(expectedWindowRect);
        });

        it(@"should calculate a fullscreen window's CGRect", ^{
            SpectacleCalculationResult *result = [SpectacleWindowPositionCalculator calculateWindowRect: windowRect
                                                                                   visibleFrameOfScreen: visibleFrameScreen
                                                                                                 action: SpectacleWindowActionFullscreen];

            expect(result.windowRect).to.equal(visibleFrameScreen);
        });
    });
SpecEnd