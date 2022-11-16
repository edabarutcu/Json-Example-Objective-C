//
//  DetailViewController.h
//  JsonExample
//
//  Created by eda on 14/11/22.
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *mywebView;
@property (strong,nonatomic) NSString *nameContent;

@end
