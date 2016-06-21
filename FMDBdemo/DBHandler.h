//
//  DBHandler.h
//  FMDBdemo
//
//  Created by 刘健 on 16/6/12.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHandler : NSObject

+ (instancetype)sharedInstance;

/**
 *  增
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)insertDataWithSql:(NSString *)sql, ...;

/**
 *  删
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)deleteDataWithSql:(NSString *)sql, ...;

/**
 *  改
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)updateDataWithSql:(NSString *)sql, ...;

/**
 *  查
 *
 *  @param sql sql
 *
 *  @return return array contain dictionary if successful
 */
- (NSMutableArray *)selectDataWithSql:(NSString *)sql, ...;


@end
