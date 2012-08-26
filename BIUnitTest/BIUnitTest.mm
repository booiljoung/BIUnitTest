//
//  BIUnitTest.mm
//  BIUnitTest
//
//  Created by booiljung on 12. 7. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <assert.h>

#import "objc/runtime.h"

#import "BIUnitTest.h"


/// @brief 주어진 클래스의 인스턴스 메소드들을 검색하여 돌려줍니다.
/// @return 인스턴스 메소드들의 이름이 담긴 NSString 개체들.
NSMutableArray *instanceMethodsForClass(Class cls ///< Class. to search.
										)
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

/// @brief 주어진 클래스 이름에서 유닛 테스트를 수행합니다. 해당 메소드들은 -setUp을 가장 먼저 처리하고, 가장 마지막에 -tearDown를 처리합니다.
/// test로 시작 하는 메소드들을 중간에 영숫자 순서에 따라 처리합니다.
/// 테스트 실패는 assert를 할용합니다.
void BIUnitTestWithClassNamed(NSString *className ///< a Class name to run unit test.
							  )
{
	Class unitTestClass = NSClassFromString(className);
	if (unitTestClass == nil) {
		NSLog(@"BIUniTest error: %@ unit test case class was NOT found!", className);
		return;
	}
		
	NSObject *unitTestCaseInstance = [[unitTestClass alloc] init];
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
		[unitTestCaseInstance performSelector:@selector(setUp)];
	
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
		[unitTestCaseInstance performSelector:@selector(tearDown)];
	NSLog(@"BIUniTest: %@ unit test case class success", className);
}


static const char *unittest_argument_name = "unittest=";

/// @brief: 쉘 커맨드 라인을 분석하여 -unitest=클래스명을 주어진 인자들에 대해 유닛테스트를 수행합니다.
/// @return: 유닛 테스트를 수행한 수량.
int BIParseAndRunArgumentsForUnitTest(int argc, ///< main(argc, argv)
									  char *argv[] ///< main(argc, argv)
									  )
{
	int unitTest = YES;
	for (int num = 1; num < argc; num++) {
		char *arg = argv[num];
		if (strlen(arg) < 1)
			continue;
		if (arg[0] != '-')
			continue;
		if (strncmp(arg+1, unittest_argument_name, strlen(unittest_argument_name)) == 0) {
			NSString *className = [NSString stringWithCString:arg + 1 + strlen(unittest_argument_name) encoding:NSStringEncodingConversionExternalRepresentation];
			BIUnitTestWithClassNamed(className);
			unitTest++;
		}
	}
	
	return unitTest;
}


