
#import <Foundation/Foundation.h>
#import "MobileUtils_Share.h"

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
extern UIViewController *g_controller;
extern UIView *g_glView;
extern int g_DeviceWidth;
extern int g_DeviceHeight;

@implementation MobileUtils_Share
{
}

-(void)MobileUtils_Share_Open:(NSString*) Title_text MIME:(NSString*) MIME Value:(NSString*) value
{
		if([MIME isEqualToString: @"text/plain"] || [MIME isEqualToString: @"text/plain"] || [MIME isEqualToString: @"text/rtf"] || [MIME isEqualToString: @"text/html"] || [MIME isEqualToString: @"text/json"])
        {
				NSArray* sharedObjects=[NSArray arrayWithObjects:value,  nil];
				UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
				activityViewController.popoverPresentationController.sourceView = g_controller.view;
				if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
					activityViewController.popoverPresentationController.sourceView = g_controller.view;
					activityViewController.popoverPresentationController.sourceRect = CGRectMake(g_controller.view.bounds.size.width/2, g_controller.view.bounds.size.height/4, 0, 0);
				}
				[g_controller presentViewController:activityViewController animated:YES completion:nil];
        }
        else
		if([MIME isEqualToString: @"image/jpg"] || [MIME isEqualToString: @"image/png"])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:[self copy:value]];
            NSArray *activityItems = @[image];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                activityViewController.popoverPresentationController.sourceView = g_controller.view;
                activityViewController.popoverPresentationController.sourceRect = CGRectMake(g_controller.view.bounds.size.width/2, g_controller.view.bounds.size.height/4, 0, 0);
            }
            [g_controller presentViewController:activityViewController animated:true completion:nil];
		}
		else
		{
            NSString *path = [self iOS_GetPath];
            NSString *localFilePath = [NSString stringWithFormat:@"%@/%@", path, value];
            
            //NSURL *imagePath = [NSURL URLWithString:localFilePath];
            NSData *animatedGif = [[NSFileManager defaultManager] contentsAtPath:localFilePath];
            
            if([[NSFileManager defaultManager] fileExistsAtPath: localFilePath])
                NSLog(@"EXISTS");

            NSArray *sharingItems = [NSArray arrayWithObjects: animatedGif,Title_text, nil];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                activityViewController.popoverPresentationController.sourceView = g_controller.view;
                activityViewController.popoverPresentationController.sourceRect = CGRectMake(g_controller.view.bounds.size.width/2, g_controller.view.bounds.size.height/4, 0, 0);
            }
            [g_controller presentViewController:activityViewController animated:true completion:nil];
		}
}

-(NSString*) copy:(NSString*) source
{
    NSString *path = [self iOS_GetPath];
    NSString *localFilePath = [NSString stringWithFormat:@"%@/%@", path, source];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *extFilePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], @"temp"];
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:source])
        [[NSFileManager defaultManager] copyItemAtPath:localFilePath toPath:extFilePath error:nil];
	
    NSLog(localFilePath);
    if([[NSFileManager defaultManager] fileExistsAtPath: localFilePath])
        NSLog(@"EXISTS");

    NSLog(extFilePath);
    if([[NSFileManager defaultManager] fileExistsAtPath: extFilePath])
        NSLog(@"EXISTS");
        
    //return extFilePath;
    return localFilePath;
}

-(NSString*) iOS_GetPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return([paths objectAtIndex:0]);
}

@end
