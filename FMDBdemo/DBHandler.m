//
//  DBHandler.m
//  FMDBdemo
//
//  Created by 刘健 on 16/6/12.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "DBHandler.h"
#import "FMDB.h"

@interface DBHandler()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation DBHandler

+ (instancetype)sharedInstance
{
    
    static DBHandler *sharedInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[DBHandler alloc] init];
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *databasePath = [cachePath stringByAppendingString:@"/lj.db"];
            
            sharedInstance.database = [FMDatabase databaseWithPath:databasePath];
            BOOL flag = [sharedInstance.database open];
            
            if (flag) {
                NSLog(@"database open successful");
            }else{
                NSLog(@"database open failure");
            }
            
            BOOL createBool = [sharedInstance.database executeUpdate:@"create table if not exists first_table(id integer primary key autoincrement, name text, phone text)"];
            
            if (createBool) {
                NSLog(@"first_table has be created");
            }else{
                NSLog(@"first_table create fail");
            }
            
            // 开启数据库队列俩处理数据
            sharedInstance.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
        });
    return sharedInstance;
}

/**
 *  增
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)insertDataWithSql:(NSString *)sql, ...
{
    return [_database executeUpdate:@"insert into first_table (name,phone) values('liujian','13333333333')"];
}

/**
 *  删
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)deleteDataWithSql:(NSString *)sql, ...
{
    return [_database executeUpdate:@"delete from first_table where name like ?", @"liujian"];
}

/**
 *  改
 *
 *  @param sql       sql
 *
 *  @return return yes if successful
 */
- (BOOL)updateDataWithSql:(NSString *)sql, ...
{
    return [_database executeUpdate:@"update first_table set name = ? where phone = '13333333333'", @"liujian2"];
}

/**
 *  查
 *
 *  @param sql sql
 *
 *  @return return array contain dictionary if successful
 */
- (NSMutableArray *)selectDataWithSql:(NSString *)sql, ...
{
    FMResultSet *resultes = [_database executeQuery:@"select * from first_table"];
    NSMutableArray *tempArray = [NSMutableArray array];
    while ([resultes next]) {
        NSDictionary *dict = [resultes resultDictionary];
        [tempArray addObject:dict];
    }
    if (tempArray.count) {
        return tempArray.mutableCopy;
    }else{
        return nil;
    }
}


@end
