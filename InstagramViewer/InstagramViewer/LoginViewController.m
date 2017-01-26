//
//  LoginViewController.m
//  InstagramViewer
//
//  Created by Kevin Nguyen on 1/6/17.
//  Copyright © 2017 Kevin Nguyen. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramKit.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)doneTapped:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem.rightBarButtonItem setEnabled: false];

    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        [self authenticationSuccess];
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.navigationItem.rightBarButtonItem setEnabled: true];
}

- (void)authenticationSuccess
{
    NSLog(@"AUTHENTICATION SUCCESSFUL");
    NSLog(@"ACCESS TOKEN: %@", [[InstagramEngine sharedEngine] accessToken]);
    NSString *message = [NSString stringWithFormat:@"Authentication sucessful. Access token: %@", [[InstagramEngine sharedEngine] accessToken]];
    
    // Toast message
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    int duration = 2; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
