//
//  DYFAuthIDAndGestureLockSettingsController.m
//
//  Created by dyf on 2017/8/2.
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

#import "DYFAuthIDAndGestureLockSettingsController.h"
#import "DYFAuthIDAndGestureLockSettingsCell.h"
#import "DYFSecurityHelper.h"
#import "DYFGestureSettingsController.h"
#import "UIViewController+Message.h"

@interface DYFAuthIDAndGestureLockSettingsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, assign) BOOL isOwnedLock;

@end

@implementation DYFAuthIDAndGestureLockSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYFSecurityHelper.faceIDAvailable ? @"手势、面容设置" : @"手势、指纹设置";
//    self.view.backgroundColor = DYFColorFromRGB(242.f, 242.f, 242.f, 1.f);
    
    [self validateAppLockStatus];
    
    [self.view addSubview:self.m_tableView];
    
    self.m_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"tableView": self.m_tableView};
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [NSLayoutConstraint activateConstraints:widthConstraints];
    [NSLayoutConstraint activateConstraints:heightConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.m_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)back {
    UINavigationController *nc = self.navigationController;
    if (nc) {
        if (nc.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [nc popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (BOOL)validateAppLockStatus {
    BOOL isAuthIDOpen  = [DYFSecurityHelper authIDOpen];
    BOOL isGestureOpen = [DYFSecurityHelper gestureCodeOpen];
    return self.isOwnedLock = (isAuthIDOpen || isGestureOpen);
}

- (UITableView *)m_tableView {
    if (!_m_tableView) {
        _m_tableView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _m_tableView.delegate        = self;
        _m_tableView.dataSource      = self;
        _m_tableView.bounces         = YES;
//        _m_tableView.backgroundColor = [UIColor clearColor];
    }
    return _m_tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.isOwnedLock ? 1 : 0;
    } else {
        return self.isOwnedLock ? 1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AGLSettingsCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AGLSettingsCell";
    
    DYFAuthIDAndGestureLockSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[DYFAuthIDAndGestureLockSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (@available(iOS 13.0, *)) {
            cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        }
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType    = UITableViewCellAccessoryNone;
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.m_textLabel.text = @"开启密码锁定";
        cell.m_switch.on      = self.isOwnedLock;
        cell.m_switch.hidden  = NO;
        [cell.m_switch addTarget:self action:@selector(openPasscodeLock:) forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 1) {
        cell.accessoryType    = UITableViewCellAccessoryNone;
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.m_textLabel.text = DYFSecurityHelper.faceIDAvailable ? @"开启Face ID解锁" : @"开启Touch ID指纹解锁";
        cell.m_switch.on      = [DYFSecurityHelper authIDOpen];
        cell.m_switch.hidden  = NO;
        [cell.m_switch addTarget:self action:@selector(openAuthID:) forControlEvents:UIControlEventValueChanged];
        
    } else {
        cell.selectionStyle   = UITableViewCellSelectionStyleGray;
        cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
        NSString *gestureCode = [DYFSecurityHelper getGestureCode];
        cell.m_textLabel.text = gestureCode.length > 0 ? @"重置手势密码" : @"设置手势密码";
        cell.m_switch.hidden  = YES;
    }
    
    return cell;
}

- (void)openPasscodeLock:(UISwitch *)sender {
    self.isOwnedLock = sender.on;
    
    [self.m_tableView reloadData];
    
    if (!sender.on) {
        [DYFSecurityHelper setAuthIDOpen:NO];
        [DYFSecurityHelper setGestureCodeOpen:NO];
    }
}

- (void)openAuthID:(UISwitch *)sender {
    if (sender.on) {
        [DYFSecurityHelper.sharedHelper evaluateAuthID:^(BOOL success, BOOL shouldEnterPassword, NSString *message) {
            if (success) {
                [DYFSecurityHelper setAuthIDOpen:YES];
                [self yf_showMessage:message];
                [self autoReturnAfterDelay:1.2f];
            } else {
                [self yf_showMessage:message];
                [self.m_tableView reloadData];
            }
        }];
    } else {
        [DYFSecurityHelper setAuthIDOpen:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        DYFGestureSettingsController *vc = [[DYFGestureSettingsController alloc] init];
        NSString *gestureCode = [DYFSecurityHelper getGestureCode];
        if (gestureCode.length > 0) {
            vc.gestureSettingsType = DYFGestureSettingsTypeChange;
        } else {
            vc.gestureSettingsType = DYFGestureSettingsTypeSet;
        }
        
        [vc gestureSettingsWithCompletion:^(BOOL successful) {
            if (successful) {
                [DYFSecurityHelper setGestureCodeOpen:YES];
            }
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)autoReturnAfterDelay:(NSTimeInterval)delayInSeconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self back];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持横屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
