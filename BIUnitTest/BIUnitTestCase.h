//
//  BITestCase.h
//  BIUnitTest
//
//  Created by booiljung on 12. 7. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BIUnitTestCaseOption <NSObject>
@optional
- (void)setUp;
- (void)tearDown;
@end

@interface BIUnitTestCase : NSObject <BIUnitTestCaseOption>
@end
