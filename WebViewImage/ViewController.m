//
//  ViewController.m
//  WebViewImage
//
//  Created by 樊康鹏 on 16/2/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "ViewController.h"
#import "WebImgScrollView.h"
@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mapp.aiderizhi.com/?url=/post/content&id=22837"]]];
   webView.delegate =self;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回所有图片
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var srcs = [];\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    srcs[i] = objs[i].src;\
    };\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+srcs;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        NSArray * imageUrlArr = [str  componentsSeparatedByString:@","];
        [WebImgScrollView showImageWithImageArr:imageUrlArr];
        
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
