//
//  ShareViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-23.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()  <TweetViewControllerDelegate>
@end

@implementation ShareViewController
@synthesize text_field_person, text_field_invention;


-(void)viewDidLoad {
    [self setImg:_img];
    [self setPerson:_person];
    [self setInvention:_invention];
    [self setFrench:_french];
    keyboard_up = false;
    [text_field_person setText:[self person]];
    [text_field_invention setText:[self invention]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillRise:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidRise:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDescend:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDescend:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [super viewDidLoad];
    if ([self french]) {
        UIButton *btn;
        UIImageView *imgview;
        UITextField * field;
        NSArray *items = [[self view] subviews];
        int itemlen = (int)[items count];
        for (int i = 0; i < itemlen; i++) {
            id item = [items objectAtIndex:i];
            int item_tag = (int)[item tag];
            switch(item_tag) {
                case 1:
                    //textfeild
                    field = (UITextField *)item;
                    [field setPlaceholder:@"VOTRE NOM"];
                    break;
                case 2:
                    //textfield
                    field = (UITextField *)item;
                    [field setPlaceholder:@"NOMMEZ VOTRE INVENTION"];
                    break;
                case 3:
                    //logo
                    imgview = (UIImageView *)item;
                    [imgview setImage:[UIImage imageNamed:@"fr-logo.png"]];
                    break;
                case 4:
                    //banner
                    imgview = (UIImageView *)item;
                    [imgview setImage:[UIImage imageNamed:@"fr-share_banner.png"]];
                    break;
                case 5:
                    //share button
                    btn = (UIButton *)item;
                    [btn setImage:[UIImage imageNamed:@"fr-share_share.png"] forState:UIControlStateNormal];
                    break;
                case 6:
                    //back button
                    btn = (UIButton *)item;
                    [btn setImage:[UIImage imageNamed:@"fr-share_back.png"] forState:UIControlStateNormal];
                    break;
                case 7:
                    //new drawing button
                    btn = (UIButton *)item;
                    [btn setImage:[UIImage imageNamed:@"fr-share_newdrawing.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }
}

-(IBAction)initiateNewDrawing:(UIButton*)sender {
    __weak ShareViewController *weak_share = self;
    NSString *alert_title, *alert_msg, *yes_txt, *no_txt;
    if ([self french]) {
        alert_title = @"Nouveau Dessin";
        alert_msg = @"Etes-vous sûr?";
        yes_txt = @"Oui";
        no_txt = @"Non";
    } else {
        alert_title = @"New Drawing";
        alert_msg = @"Are you sure you want to start a new drawing?";
        yes_txt = @"Yes";
        no_txt = @"No";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alert_title
                                                                   message:alert_msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:yes_txt style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          //begin segue
                                                          [weak_share performSegueWithIdentifier:@"NewDrawingSegue" sender:sender];
                                                      }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:no_txt style:UIAlertActionStyleDefault
                                                     handler:nil];
    [[alert view] setOpaque:TRUE];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)setHighlighted:(UIButton *)sender {
    [sender setAlpha:BUTTON_OPACITY];
}

-(IBAction)setNormal:(UIButton *)sender {
    [sender setAlpha:1.0];
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewDrawingSegue"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
    else if ([segue.identifier isEqualToString:@"BackSegue"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [self setPerson:[text_field_person text]];
        [self setInvention:[text_field_invention text]];
    }
    else if ([segue.identifier isEqualToString:@"TweetSegue"]) {
        NSString *person = [[text_field_person text] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *invention = [[text_field_invention text] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([person length] == 0) {
            if ([self french]) {
                person = @"Quelqu'un";
            }
            else {
                person = @"Someone";
            }
        }
        if ([invention length] == 0) {
            if ([self french]) {
                invention = @"quelque chose";
            }
            else {
                invention = @"something";
            }
        }
        TweetViewController *viewcontroller = (TweetViewController *)[segue destinationViewController];
        NSString *tweet_txt = @"";
        if ([self french]) {
            tweet_txt = [NSString stringWithFormat:@"%@ a créé %@", person, invention];
        }
        else {
            tweet_txt = [NSString stringWithFormat:@"%@ invented %@", person, invention];
        }
        [viewcontroller setText:tweet_txt];
        [viewcontroller setImg:[self img]];
        [viewcontroller setFrench:[self french]];
        [viewcontroller setDelegate:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)str {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [str length] - range.length;
    int limit = DEFAULT_LIMIT;
    if ([textField tag] == [text_field_person tag]) {
        limit -= [[text_field_invention text] length];
    }
    else {
        limit -= [[text_field_person text] length];
    }
    if (newLength > limit) {
        return NO;
    }
    else {
        return YES;
    }
}

-(IBAction)tweetInvention:(UIButton*)sender {
    [self performSegueWithIdentifier:@"TweetSegue" sender:nil];
}

-(void)keyboardWillRise:(NSNotification *) notif {
    //shift view up
    if (!keyboard_up) {
        [self shiftView:TRUE];
    }
}

-(void)keyboardWillDescend:(NSNotification *) notif {
    //shift view down
    if (keyboard_up) {
        [self shiftView:FALSE];
    }
}

-(void)keyboardDidRise:(NSNotification *) notif {
    //shift view up
    keyboard_up = true;
}

-(void)keyboardDidDescend:(NSNotification *) notif {
    //shift view down
    keyboard_up = false;
}


-(void)shiftView:(BOOL)dir {
    int value = -1 * MOVE_OFFSET;
    //TRUE shifts up FALSE shifts down
    if (!dir) {
        value = MOVE_OFFSET;
    }
    UIView *view = [[self view] viewWithTag:1];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:MOVE_TIME];
    
    CGRect rect = [view frame];
    rect.origin.y += value;
    [[self view] setFrame:rect];
    
    [UIView commitAnimations];
}


@end
