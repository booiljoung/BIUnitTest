//
//  BIUnitTest.m
//  BIUnitTest
//
//  Created by booiljung on 12. 7. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <assert.h>

#import "objc/runtime.h"

#import "BIUnitTest.h"
#import "BIUnitTestCase.h"


NSMutableArray *instanceMethodsForClass(Class cls)
{
    NSMutableArray *methods = [[NSMutableArray alloc] init];
    unsigned int methodOutCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodOutCount);
    for (unsigned int methodNum = 0; methodNum < methodOutCount; methodNum++) {
		NSString *methodName = [NSString stringWithCString:(sel_getName(method_getName(methodList[methodNum]))) encoding:NSUTF8StringEncoding];
        [methods addObject:methodName];
    }
    free(methodList);
    return methods;
}


void BIUnitTestWithClassNamed(NSString *className)
{
	Class unitTestClass = NSClassFromString(className);
	if (unitTestClass == nil) {
		NSLog(@"BIUniTest error: %@ unit test case class was NOT found!", className);
		return;
	}
		
	BIUnitTestCase *unitTestCaseInstance = [[unitTestClass alloc] init];
	if (unitTestCaseInstance == nil) {
		NSLog(@"BIUniTest error: %@ unit test case instance was NOT initialized!", className);
		return;
	}
	
	NSMutableArray *unitTestCaseMethodNames = instanceMethodsForClass(unitTestClass);
	if (unitTestCaseMethodNames.count == 0) {
		NSLog(@"BIUniTest error: %@ unit test case method was not found!", className);
		return;
	}
	
	[unitTestCaseMethodNames sortUsingSelector:@selector(compare:)];
	
	NSLog(@"BIUniTest: %@ unit test case class is started...", className);
	if ([unitTestCaseInstance respondsToSelector:@selector(setUp)])
		[unitTestCaseInstance setUp];
	
	for (NSString *methodName in unitTestCaseMethodNames) {
		NSString *testString = [methodName substringToIndex:4];
		if ([testString compare:@"test"] != NSOrderedSame)
			continue;
		
		SEL sel = NSSelectorFromString(methodName);
		NSLog(@"BIUniTest: [%@ %@] unit test case method is calling!", className, methodName);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		if ([unitTestCaseInstance respondsToSelector:sel])
			[unitTestCaseInstance performSelector:sel];
#pragma clang diagnostic pop
	}
	if ([unitTestCaseInstance respondsToSelector:@selector(tearDown)])
		[unitTestCaseInstance tearDown];
	NSLog(@"BIUniTest: %@ unit test case class success", className);
}


