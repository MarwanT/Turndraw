//
//  UIBezierPath+Utilities.m
//  Turndraw
//
//  Created by Marwan Toutounji on 2/5/16.
//  Copyright © 2016 Keeward. All rights reserved.
//

#import "UIBezierPath+Utilities.h"
#import "UIBezierPath+Elements.h"
#import "BezierElement.h"

@implementation UIBezierPath (Utilities)


- (NSUInteger) count {
  return self.elements.count;
}

@end
