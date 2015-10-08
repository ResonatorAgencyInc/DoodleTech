//
//  TestColorViewController.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//

#import "TestColorViewController.h"


@interface TestColorViewController () {
    UIButton *selected_button;
    BOOL isSmallSize;
    BOOL build;
}
@end
@implementation TestColorViewController

-(void)viewDidLoad {
    [self setOpacity:_opacity];
    [self setGradient:_gradient];
    [self setColour:_colour];
    [self setSelected_tag:_selected_tag];
    [self setColour_arr:_colour_arr];
    [self setFrench:_french];
    build = FALSE;
    [super viewDidLoad];
    if ([self french]){
        UILabel * lbl = (UILabel *)[[self view] viewWithTag:30];
        [lbl setText:@"COULEUR"];
        lbl = (UILabel *)[[self view] viewWithTag:31];
        [lbl setText:@"DÉFAUT"];
        lbl = (UILabel *)[[self view] viewWithTag:32];
        [lbl setText:@"CUSTOM"];
    }
    //initialize buttons
    @autoreleasepool {
        UIButton *button;
        for (int i = 0; i < 9; i++) {
            button = (UIButton *)[self.view viewWithTag:(i + 1)];
            [[button layer] setCornerRadius:8.0f];
        }
    }
    selected_button = (UIButton *)[self.view viewWithTag:19];
    [[selected_button layer] setCornerRadius:8.0f];
    [selected_button setBackgroundColor:[self colour]];
    @autoreleasepool {
        UIButton *button;
        if ([self colour_arr]) {
            for (int i = 0; i < 9; i++) {
                button = (UIButton *)[self.view viewWithTag:(i + 10)];
                [[button layer] setCornerRadius:8.0f];
                [button setBackgroundColor:[[self colour_arr] objectAtIndex:i]];
            }
        }
        else {
            for (int i = 0; i < 9; i++) {
                button = (UIButton *)[self.view viewWithTag:(i + 10)];
                [[button layer] setCornerRadius:8.0f];
                [button setBackgroundColor:[self colour]];
            }
        }
        [self setColour_arr:nil];
    }
    
    
    
    
    // View that displays color picker (needs to be square)
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(20.0, 60.0, 280.0, 280.0)];
    // Set the delegate to receive events
    [_colorPicker setDelegate:self];
    [[self view] addSubview:_colorPicker];
    _colorPicker.cropToCircle = TRUE;
    
    //setup brightness slider and add subview
    _brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(20, 365.0, 200, 40.0)];
    [_brightnessSlider setColorPicker:_colorPicker];
    [[self view] addSubview:_brightnessSlider];
    
    // View that controls opacity
    //_opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(20, 390.0, 200, 30.0)];
    //[_opacitySlider setColorPicker:_colorPicker];
    //[[self view] addSubview:_opacitySlider];
    build = TRUE;
    _colorPicker.selectionColor = [self colour];
}



-(IBAction)selectedTag:(UIButton*)sender {
    uint tag = (uint)sender.tag;
    if ((tag > 0) && (tag < 19)) {
        [self setSelected_tag:tag];
        [self.delegate changeTag:[self selected_tag]];
        UIButton *button = (UIButton*)[self.view viewWithTag:[self selected_tag]];
        _colorPicker.selectionColor = button.backgroundColor;
    }
}


- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    if (build) {
        // Update important UI
        _brightnessSlider.value = [cp brightness];
        //_opacitySlider.value = [cp opacity] ;
        [selected_button setBackgroundColor:[cp selectionColor]];
        if (([self selected_tag] > 9) && ([self selected_tag] < 19)) {
            UIButton *button = (UIButton*)[self.view viewWithTag:[self selected_tag]];
            [button setBackgroundColor:[cp selectionColor]];
        }
        [self.delegate changedColour:[cp selectionColor] changedOpacity:1.0f changedGradient:[cp brightness]];
    }
}

#pragma mark - User action

- (void)testResize:(id)sender {
    if (isSmallSize) {
        _colorPicker.frame = CGRectMake(20.0, 10.0, 280.0, 280.0);
        isSmallSize = NO;
    } else {
        _colorPicker.frame = CGRectMake(40.0, 10.0, 240.0, 240.0);
        isSmallSize = YES;
    }
}

- (void)testLoup:(id)sender {
    if (_colorPicker.showLoupe) {
        _colorPicker.showLoupe = NO;
    } else {
        _colorPicker.showLoupe = YES;
    }
}

#pragma mark - Push the stack

- (void)pushNext:(id)sender {
    TestColorViewController *colorController = [[TestColorViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:colorController animated:YES];
}

@end
