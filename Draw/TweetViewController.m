//
//  TweetViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-03-08.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "TweetViewController.h"

@implementation TweetViewController 

-(void)viewDidLoad {
    [self setText:_text];
    [self setImg:_img];
    [self setFrench:_french];
    [super viewDidLoad];
    UIImageView *imgview;
    UITextField * field;
    NSArray *items = [[self view] subviews];
    int itemlen = (int)[items count];
    for (int i = 0; i < itemlen; i++) {
        id item = [items objectAtIndex:i];
        int item_tag = (int)[item tag];
        switch(item_tag) {
            case 1:
                //imageview
                imgview = (UIImageView *)item;
                [imgview setImage:[self img]];
                break;
            case 2:
                //textfield
                field = (UITextField *)item;
                [field setText:[self text]];
                break;
            case 3:
                //cancel button
                cancel = (UIButton *)item;
                if ([self french]) {
                    [cancel setTitle:@"Annuler" forState:UIControlStateNormal];
                }
                break;
            case 4:
                //post button
                postit = (UIButton *)item;
                if ([self french]) {
                    [postit setTitle:@"Publier" forState:UIControlStateNormal];
                }
                break;
            case 5:
                indicator = (UIActivityIndicatorView *)item;
                break;
            case 6:
                overlay = (UIView *)item;
                break;
            default:
                break;
        }
    }
}

- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverController
{
    return NO;
}


-(IBAction)cancelTweet:(UIButton *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)disableInterface {
    [cancel setUserInteractionEnabled:false];
    [postit setUserInteractionEnabled:false];
}

-(void)enableInterface {
    [cancel setUserInteractionEnabled:true];
    [postit setUserInteractionEnabled:true];
}


-(IBAction)postTweet:(UIButton *)sender {
    [self disableInterface];
    [overlay setHidden:false];
    [indicator startAnimating];
    
    __weak TweetViewController *weak_self = self;
    alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                       message:nil
                                                preferredStyle:UIAlertControllerStyleAlert];
    Twitter *twitter = [Twitter sharedInstance];
    [twitter logInWithCompletion: ^(TWTRSession *session, NSError *error) {
        if (session) {
            //session exists
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:session.userID];
            NSString *imageShowEndpoint = @"https://upload.twitter.com/1.1/media/upload.json";
            NSData *image_data = UIImageJPEGRepresentation ([self img], 1.0);
            NSString *image_str = [image_data base64EncodedStringWithOptions:0];
            NSDictionary *params = @{@"media":image_str};
            NSError *clientError;
            NSURLRequest *request = [client URLRequestWithMethod:@"POST"
                                                          URL:imageShowEndpoint
                                                   parameters:params
                                                        error:&clientError];
            if (request) {
                //Send and recieve request
                [client sendTwitterRequest:request
                             completion:^(NSURLResponse *response,
                                          NSData *data,
                                          NSError *connectionError) {
                                 if (data) {
                                     NSError *jsonError;
                                     NSDictionary *json = [NSJSONSerialization
                                               JSONObjectWithData:data
                                               options:0
                                               error:&jsonError];
                                     if (jsonError) {
                                         //JSON parsing error
                                         [indicator stopAnimating];
                                         [overlay setHidden:true];
                                         NSLog(@" JSON Error: %@", jsonError);
                                         [alert setMessage:@"code: 07"];
                                         [self presentViewController:alert animated:TRUE completion:nil];
                                         dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                         dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                             [self dismissViewControllerAnimated:TRUE completion:nil];
                                         });
                                     }
                                     else {
                                         NSString *media_id = [json objectForKey:@"media_id_string"];
                                         NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/statuses/update.json";
                                         NSDictionary *params = @{@"id" : [session userID],
                                                                  @"status": [self text],
                                                                  @"media_ids" : media_id};
                                         NSError *clientError;
                                         NSURLRequest *request = [client URLRequestWithMethod:@"POST"
                                                                                       URL:statusesShowEndpoint
                                                                                parameters:params
                                                                                     error:&clientError];
                                         if (request) {
                                             [client sendTwitterRequest:request
                                                          completion:^(NSURLResponse *response,
                                                                       NSData *data,
                                                                       NSError *connectionError) {
                                                  if (data) {
                                                      // handle the response data e.g.
                                                      NSError *jsonError;
                                                      [NSJSONSerialization JSONObjectWithData:data
                                                                                      options:0
                                                                                        error:&jsonError];
                                                      if (jsonError) {
                                                          //JSON parsing error
                                                          [indicator stopAnimating];
                                                          [overlay setHidden:true];
                                                          NSLog(@"JSON Error: %@", jsonError);
                                                          [alert setMessage:@"code: 06"];
                                                          [self presentViewController:alert animated:TRUE completion:nil];
                                                          dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                                          dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                                              [self dismissViewControllerAnimated:TRUE completion:nil];
                                                          });
                                                      }
                                                      else {
                                                          [indicator stopAnimating];
                                                          [overlay setHidden:true];
                                                          //Tweet was sent successfully
                                                          if ([self french]){
                                                              [alert setTitle:@"Succès!"];
                                                              [alert setMessage:@"Votre création a été soumise avec succès!"];
                                                          } else {
                                                              [alert setTitle:@"Success!"];
                                                              [alert setMessage:@"Your invention was tweeted successfully!"];
                                                          }
                                                          [self presentViewController:alert animated:TRUE completion:nil];
                                                          dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                                          dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                                              [self dismissViewControllerAnimated:TRUE completion:^(void) {
                                                                  [weak_self performSegueWithIdentifier:@"NewDrawingSegue" sender:nil];
                                                              }];
                                                          });
                                                      }
                                                  }
                                                  else {
                                                      //No data recieved from second request, an error
                                                      [indicator stopAnimating];
                                                      [overlay setHidden:true];
                                                      NSLog(@"Connection Error: %@", connectionError);
                                                      //
                                                      [alert setMessage:@"code: 05"];
                                                      [self presentViewController:alert animated:TRUE completion:nil];
                                                      dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                                      dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                                          [self dismissViewControllerAnimated:TRUE completion:nil];
                                                      });
                                                  }
                                              }];
                                         }
                                         else {
                                             //second request, the text one, was made or formed properly, unlikely
                                             [indicator stopAnimating];
                                             [overlay setHidden:true];
                                             NSLog(@"Request Error: %@", clientError);
                                             [alert setMessage:@"code: 04"];
                                             [self presentViewController:alert animated:TRUE completion:nil];
                                             dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                             dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                                 [self dismissViewControllerAnimated:TRUE completion:nil];
                                             });
                                         }
                                     }
                                 }
                                 else {
                                     //Recieved no data from inital request, I'd say thats an error
                                     [indicator stopAnimating];
                                     [overlay setHidden:true];
                                     NSLog(@"Connection Error: %@", connectionError);
                                     [alert setMessage:@"code: 03"];
                                     [self presentViewController:alert animated:TRUE completion:nil];
                                     dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                                     dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                                         [self dismissViewControllerAnimated:TRUE completion:nil];
                                     });
                                 }
                 }];
            }
            else {
                //error caused because the image request wasn't made or formed properly for some reason
                [indicator stopAnimating];
                [overlay setHidden:true];
                NSLog(@"Request Error: %@", clientError);
                [alert setMessage:@"code: 02"];
                [self presentViewController:alert animated:TRUE completion:nil];
                dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:TRUE completion:nil];
                });
            }
        }
        else {
            //error authenticating session, could be lots of things
            [indicator stopAnimating];
            [overlay setHidden:true];
            NSLog(@"Authentication Error: %@", error);
            [alert setMessage:@"code: 01"];
            [self presentViewController:alert animated:TRUE completion:nil];
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DELAY * NSEC_PER_SEC));
            dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:TRUE completion:nil];
            });
        }
    }];
    [self enableInterface];
}

@end
