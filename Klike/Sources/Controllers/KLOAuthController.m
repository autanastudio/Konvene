//
//  KLVenmoAuthController.m
//  Klike
//
//  Created by Alexey on 6/4/15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLOAuthController.h"

//static NSString *klStripeclientId = @"ca_6Au3tS2epXnPSktYG5RmgoK183qtmdrZ";
//static NSString *klStripeRedirectUri= @"https://dev-konveneapp.com";
static NSString *klStripeclientId = @"ca_6Au3SibYSyLfEGkcVswU3I13vbFTuWte";
static NSString *klStripeRedirectUri= @"https://konveneapp.com";

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(
                                         CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)
                                                                                 )
                                         );
}

@end

@interface KLOAuthController () {
    NSTimer *timer;
    BOOL spinnerActive;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *activiyIndicator;
@property (nonatomic,strong) NSString* baseURL;
@property (nonatomic,strong) NSString* redirect;
@property (nonatomic,strong) NSString* clientID;
@property (nonatomic,strong) NSString* authPath;
@property (nonatomic,strong) NSString* scope;
@property (nonatomic,strong) NSString* state;

@end

@implementation KLOAuthController

+ (KLOAuthController *)oAuthcontrollerForStripe
{
    KLOAuthController *oAuthController = [[KLOAuthController alloc] initWithBaseURL:@"https://connect.stripe.com/"
                                                                 authenticationPath:@"oauth/authorize"
                                                                           clientID:klStripeclientId
                                                                              scope:@"read_write"
                                                                        redirectURL:klStripeRedirectUri];
    return oAuthController;
}

- (id)initWithBaseURL:(NSString *)baseURL
   authenticationPath:(NSString *)authPath
             clientID:(NSString *)clientID
                scope:(NSString *)scope
          redirectURL:(NSString *)redirectURL
{
    
    self.baseURL = baseURL;
    self.authPath = authPath;
    self.clientID = clientID;
    self.scope = scope;
    self.redirect = redirectURL;
    
    spinnerActive = NO;
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)authorize {
    // Generate a random string for state parameter
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:8];
    for (int i=0; i<8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    self.state = randomString;
    
    // Create the url ald load it to the web view
    NSString* url = [NSString stringWithFormat:@"%@%@?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=%@",self.baseURL,self.authPath,self.clientID,[self.redirect urlEncodeUsingEncoding:NSUTF8StringEncoding],self.scope,self.state];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView setDelegate:self];
    [self.webView setScalesPageToFit:YES];
    self.webView.layer.cornerRadius = 5;
    
    self.activiyIndicator = [[UIActivityIndicatorView alloc] init];
    self.activiyIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activiyIndicator];
    [self.activiyIndicator autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.activiyIndicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.activiyIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self authorize];
}

/*
 * On error, send error message to delegate and dismiss view controller
 */
- (void)failWithErrorCode:(NSInteger)code
              description:(NSString *)description
       recoverySuggestion:(NSString *)suggestion
{
    [self dismissViewControllerAnimated:YES completion:^() {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:description forKey:NSLocalizedDescriptionKey];
        [details setValue:suggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
        NSError *e = [NSError errorWithDomain:@"oauth" code:code userInfo:details];
//        [self.delegate oAuthViewController:self didFailWithError:e];
    }];
}

#pragma mark - UIWebViewDelegate methods

/**
 Grab the code/token from a redirect url.
 If we get the code, request a token.
 If we get the token, create a credential with it.
 */
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    // If we're loading the redirect URL, scan it for parameters (code / token)
    if ([[[request URL] absoluteString] rangeOfString:self.redirect].location != NSNotFound
        && [[[request URL] host] isEqualToString:[[NSURL URLWithString:self.redirect] host]]) {
        
        NSLog(@"loading url: %@", [[request URL] absoluteString]);
        
        NSString    *code,
        *state,
        *errorCode,
        *errorMsg;
        
        NSString * queryString = request.URL.query;
        NSArray * pairs = [queryString componentsSeparatedByString:@"&"];
        NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
        for (NSString * pair in pairs) {
            NSArray * bits = [pair componentsSeparatedByString:@"="];
            NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [kvPairs setObject:value forKey:key];
        }
        
        state = [kvPairs objectForKey:@"state"];
        code = [kvPairs objectForKey:@"code"];
        errorMsg = [kvPairs objectForKey:@"state"];
        errorCode = [kvPairs objectForKey:@"state"];
        
        if (self.state && ![self.state isEqualToString:state]) {
            [self failWithErrorCode:100
                        description:@"Invalid state received from the server."
                 recoverySuggestion:@"Try again later. If the problem continues, please contact support."];
            return NO;
        }
        
        if (code) {
            __weak typeof(self) weakSelf = self;
            [[KLAccountManager sharedManager] authWithStripeConnect:code
                                                   withCompletition:^(id object, NSError *error) {
                                                       [weakSelf.delegate oAuthViewController:weakSelf
                                                                           didSucceedWithUser:object];
                                                   }];
        } else if (errorCode) {
            if (!errorMsg) {
                if ([errorCode isEqualToString:@"access_denied"]) {
                    errorMsg = @"Request denied by user or server.";
                }
            }
            [self failWithErrorCode:101 description:errorMsg recoverySuggestion:@""];
        } else {
            [self failWithErrorCode:100 description:@"Could not resolve server response (no code or token received)." recoverySuggestion:@"Make sure that you get a token from the server."];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    timer = [NSTimer scheduledTimerWithTimeInterval:120.0
                                             target:self
                                           selector:@selector(timeout)
                                           userInfo:nil
                                            repeats:NO];
    [self displaySpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [timer invalidate];
    [self hideSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [timer invalidate];
    [self hideSpinner];
}


#pragma mark - Spinner and timeout management

- (void)displaySpinner
{
    if (!spinnerActive) {
        self.activiyIndicator.hidden = NO;
        [self.activiyIndicator startAnimating];
    }
    spinnerActive = YES;
}

- (void)hideSpinner
{
    spinnerActive = NO;
    self.activiyIndicator.hidden = YES;
    [self.activiyIndicator stopAnimating];
}

/**
 Handle timeout
 */
- (void)timeout
{
    [self failWithErrorCode:100
                description:@"Request timed out."
         recoverySuggestion:@"Check the network connection and try again later."];
    [self onClose:nil];
}

- (IBAction)onClose:(id)sender
{
    [self.webView stopLoading];
    [self failWithErrorCode:100 description:@"Login cancelled." recoverySuggestion:@""];
}

@end
