//
//  AppDelegate.m
//  CoreBluetoothDemo
//
//  Created by muhlenXi on 2016/12/12.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBPeripheral * peripheral;
@property (nonatomic,strong) CBCentralManager * centralManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 蓝牙中心初始化
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CBCentralManagerDelegate

// 蓝牙中心状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"----%ld",(long)central.state);
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@">>> CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@">>> CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@">>> CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@">>> CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@">>> CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@">>> CBManagerStatePoweredOn");
            
            // 根据 Service 获取已配对的设备
            //CBUUID * serviceUUID = [CBUUID UUIDWithString:@"180A"];
            //NSArray *peripherals = [central retrieveConnectedPeripheralsWithServices:@[serviceUUID]];
            
            // 根据 UUID 获取已配对的设备
            NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"32CDD66A-659D-8449-3F9A-ACCF201C8660"];
            NSArray * peripheralsArr = [central retrievePeripheralsWithIdentifiers:@[uuid]];
            
            NSArray *peripherals  = peripheralsArr;
            
            if (peripherals.count > 0) {
                CBPeripheral *peripheral = [peripherals firstObject];
                peripheral.delegate = self;
                self.peripheral = peripheral;//**关键**需要转存外设值，才能发起连接
                NSLog(@"self.peripheral == %@",self.peripheral);
                
                // 连接外设
                [self.centralManager connectPeripheral:self.peripheral options:nil];
                
                
            } else {
                
                // 搜索外设
                [central scanForPeripheralsWithServices:nil options:nil];
            }
            
        }
            break;
        default:
            break;
    }
    
}

// 搜索到外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"--DiscoverPeripheral--%@",peripheral.name);
    
    if ([peripheral.name isEqualToString:@"MI Band 2"]) {
        
        // 停止搜索外设
        [central stopScan];
        
        self.peripheral = peripheral;
        [central connectPeripheral:peripheral options:nil];
    }
}

// 外设已连接
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"--连接成功--%@",peripheral.name);
    
    NSLog(@"--连接成功--%@",peripheral);
    
    // 搜索服务
    [peripheral discoverServices:nil];
}

// 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"--DisconnectPeripheral--%@",peripheral.name);
}

// 连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"--FailToConnectPeripheral--%@",peripheral.name);
}

#pragma mark - CBPeripheralDelegate

// 搜索到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //NSLog(@"peripheral.services === %@",peripheral.services);
    
    NSLog(@"===============================Services==========================================");
    
    
    for (CBService * service in peripheral.services) {
        
        NSLog(@"service(UUID) %@ ----> (UUIDString) %@",service.UUID,service.UUID.UUIDString);
        
        if ([service.UUID.UUIDString isEqualToString:@"180A"]) {
            
            

        } else if ([service.UUID.UUIDString isEqualToString:@"1811"]){
            // 搜索特征
            // [peripheral discoverCharacteristics:nil forService:service];
        } else if ([service.UUID.UUIDString isEqualToString:@"180D"]){
            // 搜索特征
            // [peripheral discoverCharacteristics:nil forService:service];
        } else if ([service.UUID.UUIDString isEqualToString:@"FEE0"]){
            // 搜索特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
        
        
        
    }
    
    
    
}

// 搜索到特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //NSLog(@"DiscoverCharacteristics === %@",service.characteristics);
    
    NSLog(@"=========================Characteristics====================================");
    
    for (CBCharacteristic * characteristic in service.characteristics) {
        
        //这里外设需要订阅特征的通知，否则无法收到外设发送过来的数据
        //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
        
        NSLog(@"  %@  characteristic -> UUIDString ==  %@",service.UUID,characteristic.UUID.UUIDString);
        
        [peripheral readValueForCharacteristic:characteristic];
        
    }
    
    
}

// 给特征写命令
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"写入命令错误：%@",error.localizedDescription);
    } else {
        NSLog(@"写入命令成功");
    }
}

// 特征更新数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"didUpdateValue == %@",characteristic.value);
    
    NSLog(@"======================ValueForCharacteristic==================================");
    
    NSLog(@"%@ --- %@",characteristic.UUID.UUIDString,characteristic.value);
    
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A28"]) {
        NSString * value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"固件版本号：%@",value);
    }else {
        NSString * value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"value == %@",value);
        
        Byte * Bytes = (Byte *) characteristic.value.bytes;
        
        NSLog(@"Bytes == %s",Bytes);
    }
    
    
    
    

    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"UpdateValueForDescriptor == %@",descriptor.value);
}


@end
