//
//  ViewController.m
//  FMDBdemo
//
//  Created by 刘健 on 16/5/3.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *databasePath = [cachePath stringByAppendingString:@"/lj.db"];
    
    _database = [FMDatabase databaseWithPath:databasePath];
    BOOL flag = [_database open];
    
    if (flag) {
        NSLog(@"database open successful");
    }else{
        NSLog(@"database open failure");
    }
    
    BOOL createBool = [_database executeUpdate:@"create table if not exists first_table(id integer primary key autoincrement, name text, phone text)"];
    
    if (createBool) {
        NSLog(@"first_table has be created");
    }else{
        NSLog(@"first_table create fail");
    }
    
    // 开启数据库队列俩处理数据
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
}
- (IBAction)addAction:(UIButton *)sender {
    BOOL addBool = [_database executeUpdate:@"insert into first_table (name,phone) values('liujian','13333333333')"];
    if (addBool) {
        NSLog(@"insert data successful");
    }else{
        NSLog(@"insert data failure");
    }
}
- (IBAction)deleteAction:(UIButton *)sender {
    BOOL deleteBool = [_database executeUpdate:@"delete from first_table where name like ?", @"liujian"];
    if (deleteBool) {
        NSLog(@"deleteBool data successful");
    }else{
        NSLog(@"deleteBool data failure");
    }
}
- (IBAction)updateAction:(UIButton *)sender {
    BOOL updateBool = [_database executeUpdate:@"update first_table set name = ? where phone = '13333333333'", @"liujian2"];
    if (updateBool) {
        NSLog(@"updateBool data successful");
    }else{
        NSLog(@"updateBool data failure");
    }
}
- (IBAction)selectAction:(UIButton *)sender {
    
    FMResultSet *resultes = [_database executeQuery:@"select * from first_table"];
    
    while ([resultes next]) {
        NSString *identify = [resultes objectForColumnName:@"id"];
        NSString *name = [resultes objectForColumnName:@"name"];
        NSString *phone = [resultes objectForColumnName:@"phone"];
        NSLog(@"query object: id=%@, name=%@, hone=%@",identify, name, phone);
        
        NSDictionary *dict = [resultes resultDictionary];
        NSLog(@"查询结果字典:%@",dict);
        
    }
}
- (IBAction)queueAction:(UIButton *)sender {
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL xx = [db executeUpdate:@"insert into first_table (name, phone) values(?, ?)",@"张三",@"13333333332"];
        [db executeUpdate:@"insert into first_table (name, phone) values(?, ?)", @"李四", @"13333333331"];
        [db executeUpdate:@"insert into first_table (name, phone) values(?, ?)", @"王五", @"13333333330"];
        
        for (int i = 0; i < 100000; i++) {
           BOOL xx = [_database executeUpdate:@"insert into first_table (name,phone) values('liujian','13333333333')"];
            NSLog(@"thread = %@ result = %@",[NSThread currentThread].name,xx ? @"yes": @"no");
        }
        
    }];
    
}
- (IBAction)transcation:(UIButton *)sender {
    [_databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"update first_table sewt name = ? where phone = ?",@"王老五", @"13333333330"];
        [db executeUpdate:@"update first_table set name = ? where phone = ?",@"李老四", @"13333333331"];
        [db executeUpdate:@"update first_table set name = ? where phone = ?",@"张老三", @"13333333332"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
