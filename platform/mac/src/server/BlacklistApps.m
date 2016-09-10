/* -*- ObjC -*-

 MacOS X implementation of the SKK input method.

 Copyright (C) 2009 Tomotaka SUWA <t.suwa@mac.com>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 */

#import "BlacklistApps.h"

@interface BlacklistApps(Local)
- (BOOL)isJavaApp:(NSBundle*)bunlde;
- (BOOL)isBlacklistApp:(NSString*)bunldeIdentifier withKey:(NSString*)key;
@end

@implementation BlacklistApps
static BlacklistApps* sharedData_ = nil;

- (void)load:(NSArray*)xs {
    blacklistApps_ = xs;
}

- (BOOL)isInsertEmptyString:(NSBundle *)bundle {
    if([self isJavaApp:bundle]) {
        return YES;
    }

    if([self isBlacklistApp:[bundle bundleIdentifier] withKey:@"insertEmptyString"]) {
        return YES;
    }

    // very special apps
    if([[bundle bundleIdentifier] hasPrefix:@"com.microsoft.Excel"] &&
       [[bundle objectForInfoDictionaryKey:@"CFBundleVersion"] hasPrefix:@"15."]) {
        return YES;
    }

    return NO;
}

- (BOOL)isInsertMarkedText:(NSString *)bundleIdentifier {
    return [self isBlacklistApp:bundleIdentifier withKey:@"insertMarkedText"];
}

- (BOOL)isBlacklistApp:(NSString*)bundleIdentifier withKey:(NSString*)key {
    for (NSMutableDictionary* entry in blacklistApps_) {
        if([bundleIdentifier hasPrefix: entry[@"bundleIdentifier"]] &&
           [entry[key] boolValue] == YES) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isJavaApp:(NSBundle*)bundle {
    if([[bundle bundleIdentifier] hasPrefix:@"jp.naver.line.mac"]) {
        return YES;
    }
    if([bundle objectForInfoDictionaryKey:@"Java"]) {
        return YES;
    }
    if([bundle objectForInfoDictionaryKey:@"Eclipse"]) {
        return YES;
    }
    if([bundle objectForInfoDictionaryKey:@"JVMOptions"]) {
        return YES;
    }
    return NO;
}

+ (BlacklistApps*)sharedManager {
    if (!sharedData_) {
        sharedData_ = [[BlacklistApps alloc] init];
    }
    return sharedData_;
}
@end
