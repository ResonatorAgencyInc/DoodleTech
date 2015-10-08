//
//  WindowViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-19.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "WindowViewController.h"


@interface WindowViewController () <BackgroundTableViewControllerDelegate, SizeViewControllerDelegate, TestColorViewControllerDelegate> {
    
    UIButton *brush_button;
    UIButton *eraser_button;
    UIView *bottomtoolbar;
    QuadDrawView *canvas;
    float opacity;
    float actual_size;
    float gradient;
    UIColor *paintcolour;
    BOOL isBrushActive;
    NSString *backgroundname;
    NSMutableArray *colour_set;
    uint selected_tag;
    NSString *person;
    NSString *invention;
    BOOL french;
    NSArray *lang_imgs;
}

@end

@implementation WindowViewController
- (IBAction)back:(UIStoryboardSegue *)segue {
    ShareViewController *viewcontroller = segue.sourceViewController;
    person = [viewcontroller person];
    invention = [viewcontroller invention];
}
- (IBAction)newDrawing:(UIStoryboardSegue *)segue {
    [self loadDefaultValues];
    [self changeBackground:backgroundname];
    [canvas clearCanvas];
}


//Initialization Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    lang_imgs = @[@"background_img.jpg", @"background.png", @"drawing_tool.png",@"eraser.png",@"colour.png",@"brush_size.png",@"undo.png",@"redo.png",@"share.png",@"language.png"];
    french = false;
    canvas = (QuadDrawView *)[[self view] viewWithTag:1];
    [canvas customInit];
    [self loadDefaultValues];
    [self changeBackground:backgroundname];
}


-(void)loadDefaultValues{
    person = nil;
    invention = nil;
    if (french) {
        backgroundname = @"fr-background_img.jpg";
    } else {
        backgroundname = @"en-background_img.jpg";
    }
    opacity = 1.0;
    gradient = 0.0;
    actual_size = 6.065; //roughly 8.0
    paintcolour = [UIColor whiteColor];
    isBrushActive = TRUE;
    selected_tag = 10;
    colour_set = nil;
    [canvas setOpacity:opacity];
    [canvas setColour:paintcolour];
    [canvas setToolSize:[self calcSize:actual_size]];
    [canvas setEraserAct:FALSE];
    bottomtoolbar = (UIView*)[[self view] viewWithTag:2];
    NSArray *bottomitems = [[bottomtoolbar viewForLastBaselineLayout] subviews];
    int bottomlen = (int)[bottomitems count];
    for (int i = 0; i < bottomlen; i++) {
        int item_tag = (int)[[bottomitems objectAtIndex:i] tag];
        switch(item_tag) {
            case 3:
                eraser_button = (UIButton *)[bottomitems objectAtIndex:i];
                break;
            case 2:
                brush_button = (UIButton *)[bottomitems objectAtIndex:i];
                break;
            default:
                break;
        }
    }
    if (isBrushActive) {
        [eraser_button setAlpha:BUTTON_OPACITY];
        [brush_button setAlpha:1.0];
    }
    else {
        [brush_button setAlpha:BUTTON_OPACITY];
        [eraser_button setAlpha:1.0];
    }
}

//IBAction or Button Reactive Methods
- (IBAction)undo:(UIButton*)sender {
    [canvas undo];
}

- (IBAction)redo:(UIButton*)sender {
    [canvas redo];
}

- (IBAction)langSwitch:(UIButton*)sender {
    UIButton *btn;
    UIImage *btn_img;
    NSArray *bottomitems = [[bottomtoolbar viewForLastBaselineLayout] subviews];
    int bottomlen = (int)[bottomitems count];
    if (french) {
        //if french switch to english
        for (int i = 0; i < bottomlen; i++) {
            int item_tag = (int)[[bottomitems objectAtIndex:i] tag];
            if (item_tag > 0 && item_tag <= 9){
                btn = (UIButton *)bottomitems[i];
                btn_img = [UIImage imageNamed:[@"en-" stringByAppendingString:lang_imgs[item_tag]]];
                [btn setImage:btn_img forState:UIControlStateNormal];
            }
        }
        if ([backgroundname  isEqual: @"fr-background_img.jpg"]){
            backgroundname = @"en-background_img.jpg";
            [self changeBackground:backgroundname];
        }
        french = false;
    } else {
        //if english switch to french
        for (int i = 0; i < bottomlen; i++) {
            int item_tag = (int)[[bottomitems objectAtIndex:i] tag];
            if (item_tag > 0 && item_tag <= 9){
                btn = (UIButton *)bottomitems[i];
                btn_img = [UIImage imageNamed:[@"fr-" stringByAppendingString:lang_imgs[item_tag]]];
                [btn setImage:btn_img forState:UIControlStateNormal];
            }
        }
        if ([backgroundname  isEqual: @"en-background_img.jpg"]){
            backgroundname = @"fr-background_img.jpg";
            [self changeBackground:backgroundname];
        }
        french = true;
    }
}

- (IBAction)setTool:(UIButton*)sender {
    //if button pressed is brush button
    if ([sender tag] == 2 && !isBrushActive){
        isBrushActive = TRUE;
        [eraser_button setAlpha:BUTTON_OPACITY];
        [brush_button setAlpha:1.0];
        [canvas setEraserAct:FALSE];
        
    }//if button pressed is eraser button
    else if ([sender tag] == 3 && isBrushActive){
        isBrushActive = FALSE;
        [brush_button setAlpha:BUTTON_OPACITY];
        [eraser_button setAlpha:1.0];
        [canvas setEraserAct:TRUE];
    }
}

-(IBAction)setHighlighted:(UIButton *)sender {
    [sender setAlpha:BUTTON_OPACITY];
}

-(IBAction)setNormal:(UIButton *)sender {
    [sender setAlpha:1.0];
}


//Child ViewController Methods
-(void)changeBackground: (NSString*)img {
    backgroundname = img;
    [canvas updateBackground:img];
}


- (void)updateBrushSize:(float)sz {
    actual_size = sz;
    [canvas setToolSize:[self calcSize:sz]];
}

-(void)changeTag:(uint)tag {
    selected_tag = tag;
}

- (void) changedColour:(UIColor*)colour changedOpacity:(float)op changedGradient:(float)grad {
    paintcolour = colour;
    [canvas setColour:paintcolour];
    if ((selected_tag > 9) && (selected_tag < 19)) {
        if (!colour_set) {
            colour_set = [[NSMutableArray alloc] init];
            for (int i = 0; i < 9; i++) {
                [colour_set addObject:[UIColor whiteColor]];
            }
        }
        else {
            [colour_set setObject:colour atIndexedSubscript:(selected_tag - 10)];
        }
    }
    opacity = op;
    gradient = grad;
    [canvas setOpacity:opacity];
}


#pragma mark - Navigation
//Segue Handler Method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BackgroundSegue"]) {
        BackgroundTableViewController *viewcontroller = (BackgroundTableViewController*)[segue destinationViewController];
        [viewcontroller setDelegate:self];
        
    } else if ([segue.identifier isEqualToString:@"SizeSegue"]) {
        SizeViewController *viewcontroller = (SizeViewController*)[segue destinationViewController];
        [viewcontroller setCurrent_size:actual_size];
        [viewcontroller setFrench:french];
        [viewcontroller setDelegate:self];
        
    } else if ([segue.identifier isEqualToString:@"ColourSegue"]){
        TestColorViewController *viewcontroller = (TestColorViewController*)segue.destinationViewController;
        [viewcontroller setOpacity:opacity];
        [viewcontroller setGradient:gradient];
        [viewcontroller setColour:paintcolour];
        [viewcontroller setColour_arr:colour_set];
        [viewcontroller setSelected_tag:selected_tag];
        [viewcontroller setFrench:french];
        viewcontroller.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"ShareSegue"]){
        ShareViewController *viewcontroller = (ShareViewController*)segue.destinationViewController;
        UIImage *imag  = [self mergeImages:[UIImage imageNamed:backgroundname] secondImg:[self getLayerImage:[self.view viewWithTag:1].layer]];
        [viewcontroller setImg:imag];
        [viewcontroller setPerson:person];
        [viewcontroller setInvention:invention];
        [viewcontroller setFrench:french];
    }
}
//Helper Functions
-(float) calcSize:(float)x {
    if (x < 1.0 || x > 21.0) {
        return 1.0;
    }
    else {
        return (0.1854 * (x * x)) + (0.0722 * x) + 0.7424;
    }
}

-(UIImage*)getLayerImage: (CALayer*)layer {
    UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *layerimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return layerimg;
}

-(UIImage *)mergeImages:(UIImage*)imageA secondImg:(UIImage*)imageB {
    UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, NO, 0);
    CGPoint thumbPoint = CGPointMake(0,0);
    [imageA drawAtPoint:thumbPoint];
    
    CGPoint starredPoint = CGPointMake(0, 0);
    [imageB drawAtPoint:starredPoint];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

@end
