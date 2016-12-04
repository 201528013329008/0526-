//
//  ViewController.m
//  0526基础控件
//
//  Created by 691 on 11/7/16.
//  Copyright © 2016 691. All rights reserved.
//

#import "ViewController.h"
#import "ShopView.h"
#import "Shop.h"

@interface ViewController ()
/** 所有商品 */
@property (strong, nonatomic) IBOutlet UIView *shopsView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addBtn;
/** 删除按钮 */
@property (weak, nonatomic) UIButton *removeBtn;
@property ( nonatomic,strong) NSArray *shops;
@property ( nonatomic,strong) IBOutlet UILabel *hud;
@end

@implementation ViewController

#pragma mark - 添加按钮
-(UIButton*)addButtonWithImage:(NSString*)image highImage:(NSString*)highImage disableImage:(NSString*)disableImage frame:(CGRect)frame tag:(NSInteger)tag action:(SEL)action{
                UIButton*Btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [Btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                [Btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
                [Btn setBackgroundImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
                Btn.frame= frame;
                [self.view addSubview:Btn];
                [Btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
                return Btn;
}


//懒加载plist数据  ，重写get方法

-(NSArray*)shops{
//    将字典转模型的代码放倒这里
    if(_shops== nil){//懒加载可以判空后即可加载
//        NSBundle *bundle =[NSBundle mainBundle];
//        NSString *file = [ bundle pathForResource:@"shops" ofType:@"plist"];
//        self.shops= [NSArray arrayWithContentsOfFile:file];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile: [ [NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"]];
        NSMutableArray *shopArray =[NSMutableArray array];//可变的字典数组转模型
        for (NSDictionary*dict in dictArray) {
            Shop *shop = [Shop shopWithDict:dict];
            [shopArray addObject:shop];
        }
        _shops = shopArray;
        
        
    }
    //    以一个nsbundle对象对应一个资源包（图片 音频 视频 plist）文件
    //    作用：用来访问与之对应的资源包内部的文件，用来获取文件的全路径
    
    return _shops;
}
- (void)viewDidLoad {//公共的部分要学会抽取，不同的部分要转化为参数传进来,写方法到外面
            [super viewDidLoad];



            self.addBtn = [self addButtonWithImage:@"add" highImage:@"add_highlighted" disableImage:@"add_disabled" frame:CGRectMake(100,100,40,40) tag:10 action:@selector(add1)];
            self.removeBtn= [self addButtonWithImage:@"remove" highImage:@"remove_highlighted" disableImage:@"remove_disabled" frame:CGRectMake(300, 100, 40, 40) tag:20 action:@selector(remove1)];
            self.removeBtn.enabled=NO;
            //         创建商品集_shopsView
            self.shopsView =[[UIView alloc]init];
            self.shopsView.frame= CGRectMake(100  , 200, 200, 200);
//            self.shopsView.backgroundColor= [UIColor lightGrayColor];
             self.shopsView.backgroundColor= self.view.backgroundColor;
    
            [self.view addSubview:self.shopsView];
            [self checkButtonEnable];
            //创建指示器
   
            self.hud= [[UILabel alloc]init];
    
            //                self.hud.backgroundColor = [UIColor grayColor];
            [self.view addSubview:self.hud];
            self.hud.alpha= 0.0;
            self.hud.textColor= [UIColor whiteColor];
  
            //  self.hud.text= @"dsf";
    }

//-(void)viewDidUnload{
//    [super viewDidUnload];
//    self.shops== nil;
//}
- (void)didReceiveMemoryWarning {
                    [super didReceiveMemoryWarning];
                    // Dispose of any resources that can be recreated.
}
#pragma mark - 添加shopView商品
-(void)add1{
//   设置大的shopView   位置尺寸 以及什么时候出现  ShopView内部各小控件有自己负责
                                //    [self checkButtonEnable];
                                    
                                    self.shopsView.clipsToBounds= YES;
                                //    每一个商品的尺寸
                                    CGFloat shopW = 40;
                                    CGFloat shopH= 60;
                                    int cols= 3;//九宫
                                    
                                //    每一列之间的间距
                                    CGFloat colMargin= (self.shopsView.frame.size.width-cols*shopW)/(cols-1);
    
                                //   每一行之间的间距
                                    CGFloat rowMargin =10;
    
                                //创建父控件（任何一个控件都可以作为一个父控件）
//                         ShopView*shopView = [  ShopView shopView] ; //如果init方法中没有frame的话  ，那么看不到shopview内部的细节，因为是在后面实现的shopView.frame = cgrectmake()      init也可以掉用initframe
                                       //    shopView被好多控制器公用的时候直接加这一行代码即可

                               ShopView*shopView= [[[NSBundle mainBundle] loadNibNamed:@"ShopView6" owner:nil options:nil] firstObject];
    //如果按照命名规范，xib的名字和类名一致，那么为了避免代码敲错，可以NSStringFromClass（self）传入loadNibNamed
                                //相当于 [[ShopView alloc]init];
                                //    商品的索引
                                    NSUInteger index = self.shopsView.subviews.count;
    
                                // 取出商品模型
                                    shopView.shop = self.shops[index];
                                 //将商品模型传入即可 ，在shopView里面修改，在shopView里面重写setter方法
                                //  Shop*shop = self.shops[index];
    
//    xib与模型plist关系的情节属于所有用到该控件的控制器公用的部分。不要放到控制器中，可扩展
//                                    shopView.backgroundColor= _shopsView.backgroundColor;
//                                    UIImageView *iconView = (UIImageView*)[shopView viewWithTag:1];
//                                    UILabel *nameLable1 = (UILabel*)[shopView viewWithTag:2];
//                                    iconView.image= [UIImage imageNamed:shopView.shop.icon];
//                                    nameLable1.text= shopView.shop.name;
//    
    
    
                                //   商品的(第几列)
                                    NSUInteger col = index%cols;
                                    CGFloat shopX= col*(shopW+colMargin);
                                    
                                //    商品（第几行）
                                    NSUInteger row = index /cols;
                                    CGFloat shopY = row*(shopH + rowMargin);
                                    
                                   shopView.frame= CGRectMake(shopX, shopY, shopW,shopH);
                                    [self.shopsView addSubview:shopView];
                                    

    

    

//    获取单个商品的对象
//       NSDictionary *dict =self.shops[index];
//       Shop*shop= [Shop shopWithDict:dict];
//    （应该一次性将所有的字典添加到模型里面），而不是add一次转一次
//    字典转模型，只需要转一次，以后就可以通过点语法 通过模型来访问数据，容错性比较强，只需要转一次
//    模型的属性就是key 模型有几个属性，那么就需要转几个
//
//     shop.icon= dict[@"icon"];需要用到该模型的控制器有很多，所以为了更好的复用和扩展性，要把模型从控制器中分离开来，把代码放到initWithDict里面，如果以后其他的控制器需要用到此模型，那么
//   shop.name  = dict[@"name"];
//    Shop *shop = [[Shop alloc]init];
//        shopView.shop = self.shops[index];
//    //    添加图片
//                                    UIImageView*iconView =[[UIImageView alloc]init];
//                                    Shop*shop = self.shops[index];//直接取出商品集中的某个商品（之前已经将所有商品的字典转为了模型）
//                                    iconView.image= [UIImage imageNamed: shop.icon];
//                                    iconView.frame= CGRectMake(0, 0, 40, 40);
//                                    [shopView addSubview:iconView];
    
//    //    添加文字
//                                    UILabel*lable = [[UILabel alloc]init];
//                                    lable.frame = CGRectMake(0, shopW, shopW, shopH - iconView.frame.size.width);
//                                    lable.text = shop.name;
//                                    lable.font = [UIFont systemFontOfSize:13];
//                                    lable.textAlignment = NSTextAlignmentCenter;
//                                    [shopView addSubview:lable];
//    
                                  [self checkButtonEnable];
//                                    
                                    
                                    
}
#pragma mark- 移除shopView商品
-(void)remove1{
    
                            [self.shopsView.subviews.lastObject removeFromSuperview];
                             [self checkButtonEnable];
                        //    self.addBtn.enabled = YES;
                           
}
-(void)checkButtonEnable{
                        self.addBtn.enabled = (self.shopsView.subviews.count!= self.shops.count);
                        
                        self.removeBtn.enabled = (self.shopsView.subviews.count!=0);
                        NSString*text =nil;
                        
                        if(self.addBtn.enabled== NO){
                           text = @"加满";
                        }else if (self.removeBtn.enabled==NO){
                             text = @"没了";
                        }
                       if (text==nil) return;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
                        self.hud.frame= CGRectMake(150, 250, 100, 20);
      [UIView commitAnimations];
                        self.hud.text = text;

                        self.hud.alpha= 1;//如果此处设置为0的话，那么lable背景和字体都会变得透明
                        
                        self.hud.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];//设置背景透明字体不透明
                     
                        self.hud.textAlignment= 1;
                        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideHUD) userInfo:nil repeats:NO];
                        //    定时的三种方法，隐藏hud
                        //        [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1.5];或者利用GCD
                        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       //        self.hud.alpha = 0.0;
                        
}


#pragma mark - 隐藏HUD
-(void)hideHUD{
    self.hud.alpha= 0.0;
}
-(void)click:(UIButton*)btn{
    //多个按钮共用一种方法时必须要方法名有参数传入
//click:
}




@end
