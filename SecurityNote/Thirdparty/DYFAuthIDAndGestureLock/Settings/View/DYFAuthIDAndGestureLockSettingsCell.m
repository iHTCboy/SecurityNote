//
//  DYFAuthIDAndGestureLockSettingsCell.m
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

#import "DYFAuthIDAndGestureLockSettingsCell.h"
#import "UIView+Ext.h"

@implementation DYFAuthIDAndGestureLockSettingsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
    }
    return self;
}

- (UILabel *)m_textLabel {
    if (!_m_textLabel) {
        _m_textLabel = [[UILabel alloc] init];
        _m_textLabel.adjustsFontSizeToFitWidth = YES;
        _m_textLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _m_textLabel;
}

- (UISwitch *)m_switch {
    if (!_m_switch) {
        _m_switch = [[UISwitch alloc] init];
        _m_switch.on = NO;
    }
    return _m_switch;
}

- (void)addSubviews {
    [self.contentView addSubview:self.m_textLabel];
    [self.contentView addSubview:self.m_switch];
}

- (void)layoutSubviews {
    self.m_textLabel.left = 20.f;
    self.m_textLabel.width = 200.f;
    self.m_textLabel.height = 28.f;
    self.m_textLabel.top = (AGLSettingsCellHeight - self.m_textLabel.height)/2.f;
    
    self.m_switch.top = (AGLSettingsCellHeight - self.m_switch.height)/2.f;
    self.m_switch.right = self.contentView.width - self.m_textLabel.left;
}

@end
