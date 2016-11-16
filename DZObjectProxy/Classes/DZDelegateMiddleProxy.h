//
//  DZDelegateMiddleProxy.h
//  Pods
//
//  Created by baidu on 2016/11/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DZDelegateMiddleProxy : NSProxy
@property (nonatomic, weak) id originalDelegate;
@property (nonatomic, weak, readonly) id middleMan;
- (instancetype)initWithMiddleMan:(id)middleMan;
@end
