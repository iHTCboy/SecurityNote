//
//  TCMeController.m
//  SecurityNote
//
//  Created by joonsheng on 14-8-12.
//  Copyright (c) 2014年 JoonSheng. All rights reserved.
//

#import "TCMeController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD+MJ.h"
#import "TCAbutSNoteViewController.h"
#import "TCHelpViewController.h"

#import <StoreKit/StoreKit.h>

@interface TCMeController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageHead;

@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableViewCell *textCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *feedBackCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *recommed;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboutSnot;

@end

@implementation TCMeController

NSTimer * timer;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }

    //设置Table属性
    //self.tableView.separatorColor = TCCoror(3, 123, 252);

    self.imageCell.selectedBackgroundView = [[UIView alloc]initWithFrame:self.imageCell.frame];
    self.imageCell.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    self.textCell.selectedBackgroundView = [[UIView alloc]initWithFrame:self.textCell.frame];
    self.textCell.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    self.helpCell.selectedBackgroundView = [[UIView alloc]initWithFrame:self.helpCell.frame];
    self.helpCell.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    self.feedBackCell.selectedBackgroundView = [[UIView alloc]initWithFrame:self.feedBackCell.frame];
    self.feedBackCell.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    self.recommed.selectedBackgroundView = [[UIView alloc]initWithFrame:self.recommed.frame];
    self.recommed.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    self.aboutSnot.selectedBackgroundView = [[UIView alloc]initWithFrame:self.aboutSnot.frame];
    self.aboutSnot.selectedBackgroundView.backgroundColor = TCCoror(3, 123, 252);
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 

    //设置文字
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //判断是否有存储帐号，如果有，就显示出来
    if ([defaults valueForKey:@"textView"])
    {
        self.textView.text = [defaults valueForKey:@"textView"];
    }
    else
    {
       self.textView.text = @"有點文藝，有點年輕，但不是文藝青年。";
    }
    
    //设置头像属性
    
    /*读取入图片*/
    //Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    //因为拿到的是个路径，所以把它加载成一个data对象
    NSData *data=[NSData dataWithContentsOfFile:uniquePath];
    
    //判断是否存储照片，如果没有就用默认
    if (data)
    {
        //把该图片读出来
        UIImage * image = [UIImage imageWithData:data];
        CGFloat min = MIN(image.size.width, image.size.height);
        self.imageHead.image = image;
        self.imageHead.layer.cornerRadius = min/2;
        self.imageHead.layer.masksToBounds = YES;
    }
    else
    {
         [self.imageHead setImage:[self ellipseImage:[UIImage imageNamed:@"cluck.jpg"] withInset:0 withBorderWidth:15 withBorderColor:TCCoror(38, 141, 252)]];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 200;
    }
    
    
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //设置照片
    if ([indexPath section] == 0 && [indexPath row] == 0)
    {
        UIActionSheet * sheets = [[UIActionSheet alloc]initWithTitle:@"选择更换您头像的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"选择默认头像", nil];
        
        sheets.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        //帮定tag
        sheets.tag = 1;
        
        [sheets showInView:self.view];
    }
    
    //设置文字
    if ([indexPath section] == 0 && [indexPath row] == 1)
    {
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"编辑" message:@"请输入你的密语" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alter.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        //拿到当前选中列表的文字
        [alter textFieldAtIndex:0].text = self.textView.text;
        
        //显示文本框的x
        [alter textFieldAtIndex:0].clearButtonMode =UITextFieldViewModeWhileEditing;
        
        [alter show];
    }
    
    //帮助
    if ([indexPath section] == 1 && [indexPath row] == 0)
    {
       
        TCHelpViewController * helpV = [[TCHelpViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:helpV animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
    
    //反馈，通过邮件
    if ([indexPath section] == 1 && [indexPath row] == 1)
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];

        // 设置邮件主题
        [mail setSubject:@"关于使用密记的反馈和建议"];
        
        // 设置邮件内容
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString * messBody = [NSString stringWithFormat:@"我使用的当前版本:%@,%@,OS %@\n我的反馈和建议：\n1、\n2、\n3、",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]];

        [mail setMessageBody:messBody isHTML:NO];
        
        
        // 设置收件人列表
        [mail setToRecipients:@[@"ihetianchong@qq.com"]];
        
        
//        // 设置抄送人列表
//        [mail setCcRecipients:@[@"1234@qq.com"]];
//        // 设置密送人列表
//        [mail setBccRecipients:@[@"56789@qq.com"]];
        
        // 设置代理
        mail.mailComposeDelegate = self;
        // 显示控制器
        [self presentViewController:mail animated:YES completion:nil];
        
    }
    
    //推荐好友
    if ([indexPath section] == 1 && [indexPath row] == 2)
    {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"选择推荐给好友的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"短信",@"邮件", nil];
        
        sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        
        //帮定tag
        sheet.tag = 2;
        
        [sheet showInView:self.view];
        
    }
    
    //评价
    if ([indexPath section] == 1 && [indexPath row] == 3)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
            [SKStoreReviewController requestReview];
            
        } else {
            NSURL *url  = [NSURL URLWithString:@"https://itunes.apple.com/us/app/inotes/id925021570?l=zh&ls=1&mt=8&action=write-review"];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    
    //关于密记
    if ([indexPath section] == 1 && [indexPath row] == 4)
    {
        
        TCAbutSNoteViewController * about = [[TCAbutSNoteViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:about animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        
    }
    



}


//alertView方法调用,需要实现UIAlertViewDelegate协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {

    }
    
    //确定按钮
    if (buttonIndex == 1)
    {
        self.textView.text = [alertView textFieldAtIndex:0].text;
        
        NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
        [defaults setValue:self.textView.text forKey:@"textView"];
        [defaults synchronize];

    }
    
}


//处理Sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击了头像
    if (actionSheet.tag == 1 && buttonIndex == 0)
    {
        //拍照
        UIImagePickerController * camera = [[UIImagePickerController alloc]init];
        
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        camera.delegate = self;
        
        [self presentViewController:camera animated:YES completion:^{
            
            
        }];
        
        
    }
    else if(actionSheet.tag == 1 && buttonIndex == 1)
    {
        //从相册
        UIImagePickerController * photo = [[UIImagePickerController alloc]init];
        
        photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        photo.delegate = self;
        
        [self presentViewController:photo animated:YES completion:^{
            
        
        }];
        
    }
    else if(actionSheet.tag == 1 && buttonIndex == 2)
    {
        //默认头像
        
        UIImage * newImage  = [self ellipseImage:[UIImage imageNamed:@"cluck.jpg"] withInset:0 withBorderWidth:15 withBorderColor:TCCoror(38, 141, 252)];
        
        [self.imageHead setImage:newImage];
        
        //存储头像图片
        //Document
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        
        /*写入图片*/
        //帮文件起个名
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
        //将图片写到Documents文件中
        [UIImagePNGRepresentation(newImage) writeToFile:uniquePath atomically:YES];
        
    }
    
    
    //点击了好友推荐
    if (actionSheet.tag == 2 && buttonIndex == 0)
    {
        //发短信
        MFMessageComposeViewController *mess = [[MFMessageComposeViewController alloc] init];
        
        // 设置短信内容
        mess.body = @"亲，我现在使用密记，这款应用非常棒！记列表，写日记，备忘录，非常实用的功能，并且整个界面很简洁，你也快来下载试试用啊！包你惊喜！";
        
        // 设置收件人列表
        //mess.recipients = @[@"joonsheng.htc@icloud.com"];
        
        // 设置代理
        mess.messageComposeDelegate = self;
        
        // 显示控制器
        [self presentViewController:mess animated:YES completion:nil];
    }
    else if(actionSheet.tag == 2 &&buttonIndex == 1)
    {
        // 不能发邮件
        //if (![MFMailComposeViewController canSendMail]) return;
        
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        // 设置邮件主题
        [mail setSubject:@"亲，快来下载密记试试啊！"];
        // 设置邮件内容
        [mail setMessageBody:@"亲，我现在使用密记，这款应用非常棒！记列表，写日记，备忘录，非常实用的功能，并且整个界面很简洁，你也快来下载试试用啊！包你惊喜！" isHTML:NO];
        
        // 设置代理
        mail.mailComposeDelegate = self;
        // 显示控制器
        [self presentViewController:mail animated:YES completion:nil];
    
    }
}


//处理头像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [picker dismissViewControllerAnimated:YES completion:^{
         
     }];
    
    UIImage * newImage = info[UIImagePickerControllerOriginalImage];
    
//    UIImage * newImage  = [self ellipseImage:image withInset:0 withBorderWidth:15 withBorderColor:TCCoror(38, 141, 252)];
    [self.imageHead setImage:newImage];
  
    
    //存储头像图片
    //Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);

    /*写入图片*/
    //帮文件起个名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    //将图片写到Documents文件中
    [UIImagePNGRepresentation(newImage) writeToFile:uniquePath atomically:YES];

}


//处理短信
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        //NSLog(@"取消发送");
        [MBProgressHUD showSuccess:@"已取消发送"];
        
    }
    else if (result == MessageComposeResultSent)
    {
        //NSLog(@"已经发出");
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } else
    {
        //NSLog(@"发送失败");
        [MBProgressHUD showError:@"发送失败"];
    }
    
    
    //定时器关闭提示
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didhideHUD) userInfo:nil repeats:NO];
}



//处理邮件
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 关闭邮件界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultCancelled)
    {
        [MBRoundProgressView setAnimationDelay:1];
        //NSLog(@"取消发送");
        [MBProgressHUD showSuccess:@"已取消发送"];
        
    } else if (result == MFMailComposeResultSent)
    {
        //NSLog(@"已经发出");
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } else
    {
        //NSLog(@"发送失败");
        [MBProgressHUD showError:@"发送失败"];
    }
    
    //定时器关闭提示
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didhideHUD) userInfo:nil repeats:NO];
}


//隐藏提示框
-(void)didhideHUD
{
    
    [MBProgressHUD hideHUD];
    
}


//设置圆形头像
- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f , image.size.height - inset * 2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset + width/2, inset +  width/2, image.size.width - width- inset * 2.0f, image.size.height - width - inset * 2.0f));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
