//
//  main.m
//  BIUnitTest
//
//  Created by booiljung on 12. 5. 23..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


#import <string>
#import "BIUnitTest.h"



int main(int argc, char *argv[])
{
	@autoreleasepool {
		@try {
			if (BIParseAndRunArgumentsForUnitTest(argc, argv))
				return 0;
			return UIApplicationMain(argc, argv, nil, nil);
		}
		@catch (NSException *exception) {
			NSLog(@"main catch exception %@ %@", exception.name, exception.reason);
		}
	}
	return 0;
}

