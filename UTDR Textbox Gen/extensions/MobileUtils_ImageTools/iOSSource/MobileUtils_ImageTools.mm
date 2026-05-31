
#import <Foundation/Foundation.h>
#import "MobileUtils_ImageTools.h"

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
extern UIViewController *g_controller;
extern UIView *g_glView;
extern int g_DeviceWidth;
extern int g_DeviceHeight;
	
	
@implementation MobileUtils_ImageTools
{
}


-(double) MobileUtils_Image_Width:(NSString*) path
{
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	return [image size].width;
}

-(double) MobileUtils_Image_Height:(NSString*) path
{
	UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [image size].height;
}

-(void) MobileUtils_Image_Resize:(NSString*) path width:(double) W height:(double) H
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    //RESIZE
    CGSize size = CGSizeMake(W,H);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //SAVE
    [UIImageJPEGRepresentation(destImage, 1.0) writeToFile:path atomically:YES];
}


-(void) MobileUtils_Image_Crop:(NSString*) path width:(double) W height:(double) H offset_x:(double) offset_x offset_y:(double) offset_y
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    //CROP
    CGRect size_ = CGRectMake(offset_x,offset_y,W,H);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], size_);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
	
    
    //SAVE
    [UIImageJPEGRepresentation(cropped, 1.0) writeToFile:path atomically:YES];
}


@end
