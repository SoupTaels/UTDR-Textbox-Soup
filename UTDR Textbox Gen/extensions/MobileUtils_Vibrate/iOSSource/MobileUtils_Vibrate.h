
#import <UIKit/UIKit.h>
#import <CoreHaptics/CoreHaptics.h>

@interface MobileUtils_Vibrate: NSObject
{
    NSMutableDictionary *ListenerMap;
    
}

@property(nonatomic, strong) UIImpactFeedbackGenerator *mUIImpactFeedbackGenerator;
@property(nonatomic, strong) UISelectionFeedbackGenerator *mUISelectionFeedbackGenerator;
@property(nonatomic, strong) UINotificationFeedbackGenerator *mUINotificationFeedbackGenerator;

@property(nonatomic, strong) CHHapticEngine *hapticEngine;

@end
