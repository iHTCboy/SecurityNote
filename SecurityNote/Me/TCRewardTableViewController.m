//
//  TCRewardTableViewController.m
//  SecurityNote
//
//  Created by HTC on 2020/12/17.
//  Copyright © 2020 JoonSheng. All rights reserved.
//

#import "TCRewardTableViewController.h"

#import <StoreKit/StoreKit.h>

@interface TCRewardTableViewController ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation TCRewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rewardIdentifier"];
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
//    if (@available(iOS 11.0, *)) {
//        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
//    }
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        NSLog(@"InAppPurchase[objc] Initialized.");
    }
    else {
        NSLog(@"InAppPurchase[objc] Initialization failed: payments are disabled.");
        return;
    }
    
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//交易凭证转化为base64字符串
    NSLog(@"receiptString: %@", receiptString);
    
    // 获取Library/Caches目录
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [cachePath stringByAppendingPathComponent:@"receipt.txt"];
    // 字符串写入时执行的方法
    [receiptString ? : @"null" writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"txtPath is %@", txtPath);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rewardIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rewardIdentifier"];
        cell.textLabel.font = [UIFont systemFontOfSize:35];
        
        //cell被选中的颜色
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TCCoror(51, 149, 253);
        //右侧的指示
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (@available(iOS 13.0, *)) {
            cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        }
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"打赏1个煎蛋🍳";
            break;
        case 1:
            cell.textLabel.text = @"打赏1个鸡腿🍗";
            break;
        case 2:
            cell.textLabel.text = @"打赏1杯咖啡☕";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *goodsID = @"";
    switch (indexPath.row) {
        case 0:
            goodsID = @"com.iHTCboy.iNote.egg";
            break;
        case 1:
            goodsID = @"com.iHTCboy.iNote.chicken";
            break;
        case 2:
            goodsID = @"com.iHTCboy.iNote.coffee";
            break;
        default:
            break;
    }
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = goodsID;
    if (payment) {
       // payment.quantity = 1;
       [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
//    NSArray *inArray = @[goodsID];
//    NSSet *productIdentifiers = [NSSet setWithArray:inArray];
//    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
//    productsRequest.delegate = self;
//    [productsRequest start];
}

- (void) paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    
    NSString *state, *error, *transactionIdentifier, *transactionReceipt, *productId;
    NSInteger errorCode;
    
    for (SKPaymentTransaction *transaction in transactions) {
        
        error = state = transactionIdentifier = transactionReceipt = productId = @"";
        errorCode = 0;
        NSLog(@"paymentQueue:updatedTransactions: %@", transaction.payment.productIdentifier);
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
//                NSLog(@"paymentQueue:updatedTransactions: Purchasing...");
//                state = @"PaymentTransactionStatePurchasing";
//                productId = transaction.payment.productIdentifier;
                break;
            case SKPaymentTransactionStateFailed:
                // demo 可以这样完成交易，但实际还是要真的发货成功才调用
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    UIAlertController *vc= [UIAlertController alertControllerWithTitle:@"打赏已取消" message:@"感谢您的支持！🤟🏻" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [vc addAction:ac];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                break;
            case SKPaymentTransactionStatePurchased:{
                // demo 可以这样完成交易，但实际还是要真的发货成功才调用
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                UIAlertController *vc= [UIAlertController alertControllerWithTitle:@"打赏成功！" message:@"感谢您的支付！🤟🏻" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [vc addAction:ac];
                [self presentViewController:vc animated:YES completion:nil];
                
                break;
            }
            default:
                break;
        }
    }
    
}
                
                


//- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
//
//    NSMutableArray *validProducts = [NSMutableArray array];
//    for (NSString *pid in response.invalidProductIdentifiers) {
//        NSLog(@"invalidProductIdentifiers: %@", pid);
//    }
//
//    for (SKProduct *product in response.products) {
//        // Get the currency code from the NSLocale object
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        [numberFormatter setLocale:product.priceLocale];
//        NSString *currencyCode = [numberFormatter currencyCode];
//
//        NSLog(@"productsRequest:didReceiveResponse:  - %@: %@", product.productIdentifier, product.localizedTitle);
//        NSLog(@"%@",NILABLE(product.localizedDescription));
//        NSLog(@"%@",NILABLE(product.localizedTitle));
//        NSLog(@"%@",NILABLE(product.price));
//        NSLog(@"%@",NILABLE(product.priceLocale));
//        NSLog(@"%@",NILABLE(product.productIdentifier));
//        NSLog(@"%@",(product.downloadable));
//        NSLog(@"%@",NILABLE(product.downloadContentLengths));
//        NSLog(@"%@",NILABLE(product.downloadContentVersion));
//        //NSLog(@"%@",NILABLE(product.subscriptionPeriod));
//        //NSLog(@"%@",NILABLE(product.introductoryPrice));
//
//        NSLog(@"currencyCode: %@",currencyCode);
//    }
//}


@end
