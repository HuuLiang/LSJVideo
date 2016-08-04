//
//  LSJWebViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWebViewController.h"

@interface LSJWebViewController ()
{
    UIWebView *_webView;
}
@end

@implementation LSJWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [self init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    {
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
