//
//  PhysicalSimVC.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2021/6/7.
//  Copyright © 2021 zhongxiuhao. All rights reserved.
//

// 使用Chipmunk库来模拟物理行为;

#import "PhysicalSimVC.h"
#import <Masonry/Masonry.h>

#import "Crate.h"

#import "ObjectiveChipmunk.h"

#define GRAVITY 1000

@interface PhysicalSimVC ()

@property (nonatomic, strong) UIView            *containerView;
@property (nonatomic, strong) ChipmunkSpace     *space;
@property (nonatomic, strong) CADisplayLink     *timer;
@property (nonatomic, assign) CFTimeInterval    lastSetp;

@end

@implementation PhysicalSimVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView = [UIView new];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self simDemo];
}

- (void)simDemo {
    self.containerView.layer.geometryFlipped = YES;
    // set up physics space;
    self.space = [ChipmunkSpace new];
    [self.space setGravity:cpv(0, -GRAVITY)];
    
    // add a crate;
    Crate *crate = [[Crate alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    [self.containerView addSubview:crate];
    
    [self.space add:crate.cpBody];
    [self.space add:crate.cpShape];
    
    // start the timer;
    self.lastSetp = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(setp:)];
    
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

void updateShape(ChipmunkShape *shape, void *unused) {
    // get the crate object associated with the shape;
    Crate *crate = shape.userData;
    // update crate view position and angle to match physics shape;
    ChipmunkBody *body = crate.cpBody;
    
    crate.center = cpBodyGetPosition(body.body);
    crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body.body));
}

- (void)setp:(CADisplayLink *)timer {
    // calculate setp duration;
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastSetp;
    self.lastSetp = thisStep;
    // update physics;
    cpSpaceStep(self.space.space, stepDuration);
    // update all the shapes;
    cpSpaceEachShape(self.space.space, &updateShape, NULL);
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
