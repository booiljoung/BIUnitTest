//
//  main.m
//  BIUnitTest
//
//  Created by booiljung on 12. 5. 23..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


#import <string>
#import "BIUnitTest.h"

const char *unittest_argument_name = "unittest=";


int parse_and_run_arguments(int argc, char *argv[])
{
	int unitTest = YES;
	for (int num = 1; num < argc; num++) {
		char *arg = argv[num];
		if (strlen(arg) < 1)
			continue;
		if (arg[0] != '-')
			continue;
		if (strncmp(arg+1, unittest_argument_name, strlen(unittest_argument_name)) == 0) {
			std::string class_name();
			NSString *className = [NSString stringWithCString:arg + 1 + strlen(unittest_argument_name) encoding:NSStringEncodingConversionExternalRepresentation];
			BIUnitTestWithClassNamed(className);
			unitTest++;
		}
	}
		
	return unitTest;
}



int main(int argc, char *argv[])
{
	@autoreleasepool {
		@try {
			if (parse_and_run_arguments(argc, argv))
				return 0;
			return UIApplicationMain(argc, argv, nil, nil);
		}
		@catch (NSException *exception) {
			NSLog(@"main catch exception %@ %@", exception.name, exception.reason);
		}
	}
	return 0;
}

