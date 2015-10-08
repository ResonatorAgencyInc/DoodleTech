//
//  TestColorViewController.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 7/14/13.
//

#import <UIKit/UIKit.h>
#import "ColorPickerClasses/RSColorPickerView.h"
#import "ColorPickerClasses/RSColorFunctions.h"
#import "RSBrightnessSlider.h"
#import "RSOpacitySlider.h"

@class RSBrightnessSlider;
@class RSOpacitySlider;
@class TestColorViewController;

@protocol TestColorViewControllerDelegate <NSObject>

- (void) changedColour:(UIColor*)colour changedOpacity:(float)opacity changedGradient:(float)gradient;
- (void) changeTag:(uint)tag;

@end

@interface TestColorViewController : UIViewController <RSColorPickerViewDelegate> 


@property float opacity;
@property float gradient;
@property UIColor *colour;
@property uint selected_tag;
@property NSMutableArray *colour_arr;
@property BOOL french;

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
//@property (nonatomic) RSOpacitySlider *opacitySlider;
@property (nonatomic) UIView *colorPatch;
@property (nonatomic, weak) id<TestColorViewControllerDelegate> delegate;

@end
