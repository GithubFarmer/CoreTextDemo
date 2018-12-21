//
//  ViewController.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/17.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "ViewController.h"
#import "CTView.h"
#import "CTHeader.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "UIView+extend.h"


@interface ViewController ()

@property (nonatomic, strong) CTDisplayView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self imageAndLetterDemo];
    
//    [self writeData];
    //测试图片的显示是否正确
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 160, 80, 80)];
//    imageView.image = [UIImage imageNamed:@"hello2.png"];
//    [self.view addSubview:imageView];
}

//coreText简易demo
- (void)coreTextDemo{
    CTView *view = [[CTView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    view.backgroundColor = [UIColor clearColor];
    view.center = self.view.center;
    [self.view addSubview:view];
}

//只对展示文字的coreText操作
- (void)stringDemo{
    self.displayView = [[CTDisplayView alloc]initWithFrame:CGRectMake(100, 120, 250, 80)];
    self.displayView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.displayView];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc]init];
    config.textColor = [UIColor blackColor];
    config.width = self.displayView.width;
    
    NSString *string = @"按照以上原则，我们忠诚于中国人民，爱护当好每个公民应尽的责任，爱护国家。积极努力的建设我们的新中国，为了我们自己的中国梦，贡献自己的一份心意，愿我们伟大的祖国越来越好，越来越强大！";

    //设置字符串
    CoreTextData *data = [CTFrameParser parseContent:string config:config];
    self.displayView.data = data;
    self.displayView.height = data.height;
}

//对文字进一步加工的coreText操作
- (void)attributestringDemo{
    
    self.displayView = [[CTDisplayView alloc]initWithFrame:CGRectMake(100, 120, 250, 80)];
    self.displayView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.displayView];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc]init];
    config.textColor = [UIColor blackColor];
    config.width = self.displayView.width;
    
    NSString *string = @"按照以上原则，我们忠诚于中国人民，爱护当好每个公民应尽的责任，爱护国家。积极努力的建设我们的新中国，为了我们自己的中国梦，贡献自己的一份心意，愿我们伟大的祖国越来越好，越来越强大！";
    //    NSDictionary *dict = [CTFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:string];
    [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 10)];
    
    //设置富文本字符串
    CoreTextData *data = [CTFrameParser parseAttrContent:attstr config:config];
    self.displayView.data = data;
    self.displayView.height = data.height;
}


//写入数据，了解家目录、Documnets、Library、Temp目录
- (void)writeData{
    NSArray  *arr = @[
                      @{@"type":@"img",@"width":@"200",@"height":@"108",@"name":@"hello1"},
                      @{@"type":@"txt",@"content":@"yuyu",@"size":@"20",@"color":@"red"},
                      @{@"type":@"txt",@"content":@"发觉开发高科技啊话费卡和饭卡和副科级",@"size":@"20",@"color":@"blue"},
                      @{@"type":@"txt",@"content":@"风大爆发吧接口发觉开发八块",@"size":@"20",@"color":@"yellow"},
                      @{@"type":@"img",@"width":@"30",@"height":@"30",@"name":@"hello2"},
                      @{@"type":@"txt",@"content":@"发的话费卡哈可减肥",@"size":@"20",@"color":@"red"}
                      ];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"1.json"];
    [arr writeToFile:path atomically:YES];
    NSLog(@"%@",path);
    NSArray *da = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"data:%@",da);
}

- (void)imageAndLetterDemo{
    self.displayView = [[CTDisplayView alloc]initWithFrame:CGRectMake(10, 100, 400, 80)];
    self.displayView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.displayView];
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc]init];
    config.width = self.displayView.width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.displayView.data = data;
    self.displayView.height = data.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
