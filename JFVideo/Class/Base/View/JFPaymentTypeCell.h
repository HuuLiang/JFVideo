//
//  JFPaymentTypeCell.h
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFPaymentTypeCell : UITableViewCell

- (instancetype)initWithPaymentType:(JFPaymentType)paymentType;

@property (nonatomic,retain) NSArray *availablePaymentTypes;
@property (nonatomic) UIButton *chooseBtn;

@property (nonatomic,copy) JFSelectionAction selectionAction;

@end
