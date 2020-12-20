//
//  UIView+Ext.h
//
//  Created by dyf on 2017/7/21.
//  Copyright © 2017 dyf. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@interface UIView (Ext)

/**
 *  Returns the view's view controller (may be nil).
 */
@property (nonatomic, readonly) UIViewController *viewController;

@property (nonatomic) CGFloat left;    // Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;     // Shortcut for frame.origin.y.
@property (nonatomic) CGFloat right;   // Shortcut for frame.origin.x + frame.size.width.
@property (nonatomic) CGFloat bottom;  // Shortcut for frame.origin.y + frame.size.height.
@property (nonatomic) CGFloat width;   // Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;  // Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX; // Shortcut for center.x.
@property (nonatomic) CGFloat centerY; // Shortcut for center.y.
@property (nonatomic) CGPoint origin;  // Shortcut for frame.origin.
@property (nonatomic) CGSize  size;    // Shortcut for frame.size.

/**
 *  View frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 *  Create a snapshot image of the complete view hierarchy. This method should be called in main thread.
 *
 *  @return An `UIImage` object.
 */
- (UIImage *)snapshotImage;

/**
 *  Create a snapshot PDF of the complete view hierarchy. This method should be called in main thread.
 *
 *  @return An `NSData` object.
 */
- (NSData *)snapshotPDF;

/**
 *  Shortcut to set the view.layer's shadow
 *
 *  @param color  Shadow color
 *  @param offset Shadow offset
 *  @param radius Shadow radius
 */
- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 *	Remove all subviews. Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 *  Add fillet to rectangular view.
 *
 *  @param view        The view would be changed.
 *  @param corners     The position of the corner (left, left, right, right, available | multiselect),
 *  @param cornerRadii The radius of fillet.
 */
- (void)setRoundedRectWithView:(UIView *)view
               roundingCorners:(UIRectCorner)corners
                   cornerRadii:(CGSize)cornerRadii;

/**
 *  Get the Nib of the current View.
 *
 *  @return Nib
 */
+ (UINib *)loadNib;

/**
 *  Get the corresponding Nib by nibName.
 *
 *  @param nibName nib name.
 *
 *  @return Nib
 */
+ (UINib *)loadNibNamed:(NSString *)nibName;

/**
 *  Get the corresponding Nib by nibName in the bundle.
 *
 *  @param nibName nib name.
 *  @param bundle  The bundle contains Nib.
 *
 *  @return Nib
 */
+ (UINib *)loadNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle;

/**
 *  Get the current class instance based on the Nib of the same name as the current class.
 *
 *  @return The current class instance.
 */
+ (instancetype)loadInstanceFromNib;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName
                                      owner:(id)owner
                                     bundle:(NSBundle *)bundle;

@end
