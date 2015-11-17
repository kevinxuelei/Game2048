//
//  RootViewController.m
//  Game2048
//
//  Created by lanou3g on 15/8/16.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import "RootViewController.h"
#import "QuartzCore/QuartzCore.h" 

@interface RootViewController ()

@end

@implementation RootViewController








- (void)viewDidLoad
{
    self.sum = 0;
    self.array = [NSMutableArray arrayWithCapacity:16];
    self.flag = 16;
    [super viewDidLoad];
    
    UILabel *scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 20)];
    scoreLable.text = [NSString stringWithFormat:@"%d",self.sum];
    scoreLable.textAlignment =  NSTextAlignmentCenter;
    scoreLable.tag = 100;
    scoreLable.backgroundColor = [UIColor greenColor];
    scoreLable.layer.borderWidth = 1.5;
    scoreLable.layer.borderColor = [[UIColor grayColor] CGColor];
    scoreLable.layer.cornerRadius = 10;
    scoreLable.clipsToBounds = YES;
    [self.view addSubview:scoreLable];
    
    UIButton * abutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    abutton.frame = CGRectMake(20, 100, 100, 30);
    [abutton setTitle:@"重新开始" forState:UIControlStateNormal];
    [abutton addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    abutton.layer.borderWidth = 1.5;
    abutton.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:abutton];

    
    
    self.gameView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-self.view.bounds.size.width, self.view.bounds.size.width, self.view.bounds.size.width)];
    //    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    self.gameView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    
//     self.gameView.backgroundColor = [UIColor colorWithRed:206/255.0 green:192/255.0 blue:180/255.0 alpha:1];
    [self.view addSubview:self.gameView];
    
    for (int i = 0; i<4; i++) {
        for (int j = 0; j<4; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+72.5*j,  20+72.5*i, 62.5, 62.5)];
            label.tag = (i+1)*10+(j+1);
            label.backgroundColor = [UIColor yellowColor];
            label.font = [UIFont systemFontOfSize:20];
            label.textAlignment =  NSTextAlignmentCenter;
            label.layer.borderWidth = 3;
            label.layer.borderColor = [[UIColor grayColor] CGColor];
            label.layer.cornerRadius = 10;
            label.clipsToBounds = YES;
            [self.gameView addSubview:label];
            [self.array addObject:[NSNumber numberWithInt:(i+1)*10+(j+1)]];

            
        }
    }
     

    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeView:)];
    swipeGestureDown.direction =  UISwipeGestureRecognizerDirectionDown;
    [self.gameView addGestureRecognizer:swipeGestureDown];
    
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeView:)];
    [self.gameView addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeView:)];
    swipeGestureLeft.direction =  UISwipeGestureRecognizerDirectionLeft;
    [self.gameView addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeView:)];
    swipeGestureUp.direction =  UISwipeGestureRecognizerDirectionUp;
    [self.gameView addGestureRecognizer:swipeGestureUp];

    

    [self getNewNum];
    [self getNewNum];

    
}

-(void) plus:(UIButton *)sender{
    [self gameRestart];
}


-(void)getNewNum{
    int num = 0;
    NSInteger temp = arc4random()%10+1;
    if (temp ==9) {
        num = 4;
    }else{
        num = 2;
    }
    NSInteger random = arc4random()%self.flag;
    NSInteger lucation = [[self.array objectAtIndex:random] intValue];
    UILabel *alable = (UILabel *)[self.gameView viewWithTag: lucation];
    alable.text = [NSString stringWithFormat:@"%d",num];
    [self.array removeObjectAtIndex:random];
    self.flag--;
    [self changeColor:alable];
}


-(void)changeView:(UISwipeGestureRecognizer *)sender{
    [self finish];

    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            _n = 0;
            for (int i = 4; i>0; i--) {
                for (int j = 4; j>1; j--) {
                    UILabel *alable = (UILabel *)[self.gameView viewWithTag: i*10+j];
                    UILabel *blable = (UILabel *)[self.gameView viewWithTag: i*10+j-1];
                    int a = [alable.text intValue];
                    int b = [blable.text intValue];
                     if (a==0 && b!=0){
                         [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString  stringWithString:blable.text];
                        blable.text =[NSString stringWithFormat:@""];
                      
                        [self.array addObject:[NSNumber numberWithInt:i*10+j-1]];
                        [self.array removeObject:[NSNumber numberWithInt:i*10+j]];


                         if (j<4) {
                             j+=2;
                         }else{
                             j++;
                         }
                         _n = 1;
                     }else if (a == b && a!=0) {
                         [self moveLabel:alable toLabel:blable];
                         alable.text = [NSString stringWithFormat:@"%d",[blable.text intValue]*2];
                         blable.text =[NSString stringWithFormat:@""];
                         
                         [self.array addObject:[NSNumber numberWithInt:i*10+j-1]];
                         self.flag++;
                         _n = 1;
                         self.sum +=b*2;
                         UILabel *scoreLable = (UILabel *)[self.view viewWithTag: 100];
                         scoreLable.text = [NSString stringWithFormat:@"%d",self.sum];
                         

                    }
                    [self changeColor:alable];
                    [self changeColor:blable];

                }
                
            }
            if(_n == 1) {
                [self getNewNum];
            }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            _n = 0;
            for (int i = 4; i>0; i--) {
                for (int j = 1; j<4; j++) {
                    UILabel *alable = (UILabel *)[self.gameView viewWithTag: i*10+j];
                    UILabel *blable = (UILabel *)[self.gameView viewWithTag: i*10+j+1];
                    int a = [alable.text intValue];
                    int b = [blable.text intValue];
                    if (a==0 && b!=0){
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString  stringWithString:blable.text];
                        blable.text =[NSString stringWithFormat:@""];
                        
                        [self.array addObject:[NSNumber numberWithInt:i*10+j+1]];
                        [self.array removeObject:[NSNumber numberWithInt:i*10+j]];
                        if (j>1) {
                            j-=2;
                        }else{
                            j--;
                        }
                        _n = 1;
                    }else if (a == b && a!=0) {
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString stringWithFormat:@"%d",[blable.text intValue]*2];
                        blable.text =[NSString stringWithFormat:@""];
                        [self changeColor:alable];
                        [self.array addObject:[NSNumber numberWithInt:i*10+j+1]];
                        self.flag++;
                        _n = 1;
                        self.sum +=b*2;
                        UILabel *scoreLable = (UILabel *)[self.view viewWithTag: 100];
                        scoreLable.text = [NSString stringWithFormat:@"%d",self.sum];
                        
                    }
                    [self changeColor:alable];
                    [self changeColor:blable];

                }
            }
            if(_n == 1) {
                [self getNewNum];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            _n = 0;
            for (int i = 4; i>0; i--) {
                for (int j = 1; j<4; j++) {
                    UILabel *alable = (UILabel *)[self.gameView viewWithTag: j*10+i];
                    UILabel *blable = (UILabel *)[self.gameView viewWithTag: (j+1)*10+i];
                    int a = [alable.text intValue];
                    int b = [blable.text intValue];
                    if (a==0 && b!=0){
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString  stringWithString:blable.text];
                        blable.text =[NSString stringWithFormat:@""];

                        [self.array addObject:[NSNumber numberWithInt:(j+1)*10+i]];
                        [self.array removeObject:[NSNumber numberWithInt: j*10+i]];
                        if (j>1) {
                            j-=2;
                        }else{
                            j--;
                        }
                        _n = 1;
                    }else if (a == b && a!=0) {
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString stringWithFormat:@"%d",[blable.text intValue]*2];
                        blable.text =[NSString stringWithFormat:@""];
                        [self.array addObject:[NSNumber numberWithInt:(j+1)*10+i]];
                        self.flag++;
                        _n = 1;
                        self.sum +=b*2;
                        UILabel *scoreLable = (UILabel *)[self.view viewWithTag: 100];
                        scoreLable.text = [NSString stringWithFormat:@"%d",self.sum];
                       
                    }
                     [self changeColor:alable];
                    [self changeColor:blable];
                }
            }
            if(_n == 1) {
                [self getNewNum];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            _n = 0;
            for (int i = 4; i>0; i--) {
                for (int j = 4; j>0; j--) {
                    UILabel *alable = (UILabel *)[self.gameView viewWithTag: j*10+i];
                    UILabel *blable = (UILabel *)[self.gameView viewWithTag: (j-1)*10+i];
                    
                    int a = [alable.text intValue];
                    int b = [blable.text intValue];
                    if (a==0 && b!=0){
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString  stringWithString:blable.text];
                        blable.text =[NSString stringWithFormat:@""];
                        [self.array addObject:[NSNumber numberWithInt:(j-1)*10+i]];
                        [self.array removeObject:[NSNumber numberWithInt: j*10+i]];
                        if (j<4) {
                            j+=2;
                        }else{
                            j++;
                        }
                        _n = 1;
                       
                    }else if (a == b && a!=0) {
                        [self moveLabel:alable toLabel:blable];
                        alable.text = [NSString stringWithFormat:@"%d",[blable.text intValue]*2];
                        blable.text =[NSString stringWithFormat:@""];
                        [self.array addObject:[NSNumber numberWithInt:(j-1)*10+i]];
                        self.flag++;
                        _n = 1;
                        self.sum +=b*2;
                        UILabel *scoreLable = (UILabel *)[self.view viewWithTag: 100];
                        scoreLable.text = [NSString stringWithFormat:@"%d",self.sum];
                        
                    }
                    [self changeColor:alable];
                    [self changeColor:blable];
                    
                }
            }
            if(_n == 1) {
                [self getNewNum];
            }
            break;
            
        default:
            break;
    }


}

-(void)moveLabel:(UILabel *)alabel
         toLabel:(UILabel *)blabel{
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0;
    animation.fromValue = [NSValue valueWithCGPoint:blabel.center];
    animation.toValue = [NSValue valueWithCGPoint:alabel.center];
[alabel.layer addAnimation:animation forKey:@"position"];
}


-(void)finish{
            for (int i = 1; i<5; i++) {
                for (int j = 1; j<5; j++) {
                    UILabel *alable = (UILabel *)[self.gameView viewWithTag: i*10+j];
                    UILabel *blable = (UILabel *)[self.gameView viewWithTag: i*10+j+1];
                    UILabel *clable = (UILabel *)[self.gameView viewWithTag: i*10+j-1];
                    UILabel *dlable = (UILabel *)[self.gameView viewWithTag: (i+1)*10+j];
                    UILabel *elable = (UILabel *)[self.gameView viewWithTag: (i-1)*10+j];
                    
                    int a = [alable.text intValue];
                    int b = [blable.text intValue];
                    int c = [clable.text intValue];
                    int d = [dlable.text intValue];
                    int e = [elable.text intValue];
                    if (a <= 0
                        || (j > 0 && a==b)
                        || (i < 4 && a == c)
                        || (j > 0 && a == d)
                        || (i < 4 &&  a == e)) {
                            return;
                        }
                }
            }
//    NSLog(@"-----------------------");
//        for (int i =4; i>1; i--) {
//            UILabel *alable = (UILabel *)[self.gameView viewWithTag: 40+i];
//            UILabel *blable = (UILabel *)[self.gameView viewWithTag: 40+i-1];
//            UILabel *clable = (UILabel *)[self.gameView viewWithTag: i*10+4];
//            UILabel *dlable = (UILabel *)[self.gameView viewWithTag: (i-1)*10+4];
//            int a = [alable.text intValue];
//            int b = [blable.text intValue];
//            int c = [clable.text intValue];
//            int d = [dlable.text intValue];
//            if (a == b|| d==c) {
//                m = 1;
//            }
//        }
    
    
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"游戏结束"message:@"是否从新开始？" delegate:self cancelButtonTitle:@"YES"otherButtonTitles:@"NO",nil];
    
    [alert show];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //YES应该做的事
            [self gameRestart];
            break;
        case 1://NO应该做的事
            break;
    }
}

-(void) gameRestart{
    [self.array removeAllObjects];
    self.array = [NSMutableArray arrayWithCapacity:16];
    for (int i = 0; i<4; i++) {
        for (int j = 0; j<4; j++) {
            [self.array addObject:[NSNumber numberWithInt:(i+1)*10+(j+1)]];
            UILabel *alable = (UILabel *)[self.gameView viewWithTag: (i+1)*10+(j+1)];
            alable.text = @"";
            [self changeColor:alable];
        }
    }
    self.sum = 0;
    self.flag = 16;
    [self getNewNum];
    [self getNewNum];
}


- (void) changeColor:(UILabel *)lable {
    NSInteger i = 0;
    NSInteger sum = 1;
    if ([lable.text intValue] == 0) {
        lable.backgroundColor = [UIColor clearColor];
        lable.layer.borderColor = [[UIColor clearColor] CGColor];
        
    }else{
        lable.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    while (1) {
        sum*=2;
        i++;
        if ([lable.text intValue]==sum) {
            switch (i) {
                case 1:
                    lable.backgroundColor = [UIColor greenColor];
                    break;
                case 2:
                    lable.backgroundColor = [UIColor blueColor];
                    break;
                case 3:
                    lable.backgroundColor = [UIColor colorWithRed:27/255.0 green:33/255.0 blue:144/255.0 alpha:1];
                    break;
                case 4:
                    lable.backgroundColor = [UIColor orangeColor];
                    break;
                case 5:
                    lable.backgroundColor = [UIColor cyanColor];
                    break;
                case 6:
                    lable.backgroundColor = [UIColor magentaColor];
                    break;
                case 7:
                    lable.backgroundColor = [UIColor brownColor];
                    break;
                case 8:
                    lable.backgroundColor = [UIColor purpleColor];
                    
                    break;
                case 9:
                    lable.backgroundColor = [UIColor colorWithRed:173/255.0 green:75/255.0 blue:135/255.0 alpha:1];
                    break;
                case 10:
                    lable.backgroundColor = [UIColor colorWithRed:58/255.0 green:22/255.0 blue:25/255.0 alpha:1];
                    break;
                case 11:
                    lable.backgroundColor = [UIColor whiteColor];
                    break;
                    
                default:
                    break;
            }
            break;
        }
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
