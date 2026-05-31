
#import <UIKit/UIKit.h>


@interface MobileUtils_Gallery : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
   
}

@property (nonatomic, retain) NSString* ImagePath;

-(NSString*)iOS_GetPath;

@end
