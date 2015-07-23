//
//  ViewController.m
//  seriesOfLed
//
//  Created by admin on 7/20/15.
//  Copyright (c) 2015 hoangdangtrung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    CGFloat _margin; // > ruby radius
    NSTimer *_timer;
    int _lastOnLed;
    int _numberOfRuby;
    int _numberOfRow;
    int _tag;
    int _multipliedIndex;
    //    CGFloat _space; // > ruby diameter
    //    CGFloat _rubyDiameter;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _margin = 40;
    _multipliedIndex =1;
    //    _rubyDiameter = 24;
    _numberOfRuby = 11;
    _numberOfRow = 21;
    [self drawSeriesOfRuby:_numberOfRuby numberRow:_numberOfRow];
    _lastOnLed = -1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(fromLeftToRight)
                                            userInfo:nil
                                             repeats:YES];
    
    //    [self numberOfRubyvsSpace];
    //    [self checkSizeOfiPhone];
    //    [self rubyCGPointMakeX:320/2 rubyCGPointMakeY:568/3 rubyTag:1];
    
}



- (void) fromLeftToRight {
    if (_lastOnLed == -1) {
        [self turnOFFLed:_numberOfRow*_numberOfRuby-1];   // turn off last Led when _numberOfRow %2 = 1 //
        [self turnOFFLed:_numberOfRuby*(_numberOfRow-1)]; // turn off last Led when _numberOfRow %2 = 0 //
    }
    
    if (_lastOnLed != -1) {
        [self turnOFFLed:_lastOnLed];
    }
    
    if (_lastOnLed != _numberOfRuby*_multipliedIndex) {
        _lastOnLed ++;
    }
    
    if (_lastOnLed == _numberOfRuby*_multipliedIndex) {
        _lastOnLed--;
        _multipliedIndex++;
        _lastOnLed = _lastOnLed + _numberOfRuby;
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(fromRightToLeft)
                                                userInfo:nil
                                                 repeats:1];
    }
    
    [self turnONLed:_lastOnLed];
    
    if (_lastOnLed == _numberOfRuby*_numberOfRow - _numberOfRow%2) { // Repeat Matrix of Led if _numberOfRow %2 = 1 //
        _lastOnLed = -1;
        _multipliedIndex = 1;
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(fromLeftToRight)
                                                userInfo:nil
                                                 repeats:1];
    }
}

- (void) fromRightToLeft {
    if (_lastOnLed != (_numberOfRuby)*_multipliedIndex) {
        [self turnOFFLed:_lastOnLed];
    }
    
    if (_lastOnLed != _numberOfRuby*(_multipliedIndex-1)-1) {
        _lastOnLed --;
    }
    
    if (_lastOnLed == _numberOfRuby*(_multipliedIndex-1)-1) {
        _lastOnLed++;
        _multipliedIndex++;
        _lastOnLed = _lastOnLed + _numberOfRuby;
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(fromLeftToRight)
                                                userInfo:nil
                                                 repeats:1];
    }
    
    [self turnONLed:_lastOnLed];
    
    if (_numberOfRow%2==0) { ///////  Repeat Matrix of Led if _numberOfRow %2 = 0  ////////
        if (_lastOnLed == _numberOfRuby*_numberOfRow - _numberOfRuby) {
            _lastOnLed = -1;
            _multipliedIndex = 1;
            [_timer invalidate];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                      target:self
                                                    selector:@selector(fromLeftToRight)
                                                    userInfo:nil
                                                     repeats:1];
        }
    }
}

- (void) turnONLed: (int)index{
    UIView *view = [self.view viewWithTag:index+ 100];
    if (view && [view isMemberOfClass:[UIImageView class]]) {
        UIImageView *ruby = (UIImageView *)view;
        ruby.image = [UIImage imageNamed:@"rubyRed"];
    }
}

- (void) turnOFFLed: (int)index {
    UIView *view = [self.view viewWithTag:index+100];
    if (view && [view isMemberOfClass:[UIImageView class]]) {
        UIImageView *ruby = (UIImageView *) view;
        ruby.image = [UIImage imageNamed:@"rubyGrey"];
    }
}


// Put a Image to a determined Position =========================
-(void) rubyCGPointMakeX: (CGFloat) x
        rubyCGPointMakeY: (CGFloat) y
                 rubyTag:(CGFloat) tag;
{
    UIImageView *ruby = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rubyGrey"]];
    ruby.center = CGPointMake(x, y);
    ruby.tag = tag;
    [self.view addSubview:ruby];
    //    NSLog(@"w = %f, h= %f",ruby.bounds.size.width,ruby.bounds.size.height);
}

// Distance between Rubys in a row =========================
-(CGFloat)spaceBetweenRubyCenterByRow: (int) n {
    return (self.view.bounds.size.width - 2* _margin)/(n-1);
}

// Distance between Rubys in a column ======================
-(CGFloat)spaceBetweenRubyCenterByColumn: (int) m {
    return (self.view.bounds.size.height - 2* _margin)/(m-1);
}
//-(void)numberOfRubyvsSpace{
//    bool stop = false;
//    int n =3;
//    while (!stop) {
//        CGFloat space = [self spaceBetweenRubyCenter: n];
//        if (space< _rubyDiameter) {
//            stop = true;
//        }else {
//            NSLog(@"Number of Ruby %d, space between ruby center %3.0f",n,space);
//        }
//        n++;
//    }
//}

// ======================   Draw Matrix Ruby   ======================
-(void)drawSeriesOfRuby: (int)numberRubys numberRow:(int) numberRow {
    CGFloat spaceRow = [self spaceBetweenRubyCenterByRow:numberRubys];
    CGFloat spaceColumn = [self spaceBetweenRubyCenterByColumn:numberRow];
    for (int j=0; j< numberRow; j++) {
        for (int i=0; i<numberRubys; i++) {
            [self rubyCGPointMakeX:_margin+ i*spaceRow
                  rubyCGPointMakeY:_margin+ j*spaceColumn
                           rubyTag:_tag+100];
            _tag ++;
        }
    }
}
//-(void) checkSizeOfiPhone{
//    CGSize size = self.view.bounds.size;
//    NSLog(@"w = %f, h = %f",size.width,size.height);
//}

@end
