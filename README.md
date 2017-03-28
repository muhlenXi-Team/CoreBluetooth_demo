## CoreBluetooth_demo
关于CoreBluetooth的应用
 
测试设备:小米手环2代

工具App：LightBlue

### 注意事项

*导入的头文件：*

```objc
#import <CoreBluetooth/CoreBluetooth.h>
```

*需要遵守的协议：*

`<CBCentralManagerDelegate,CBPeripheralDelegate>`

### CBCentralManager部分

#### CentralManager初始化

```objc
self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
```

#### 扫描外设

```objc
[central scanForPeripheralsWithServices:nil options:nil];
```

*需要实时获取 RSSI 和 广播的数据，需要扫描的时候添加 options ！*

```objc
[self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
```

#### 连接外设

```objc
[self.centralManager connectPeripheral:self.peripheral options:nil];
```

#### 扫描外设中的服务

```objc
[self.peripheral discoverServices:nil];
```

#### 扫描外设中的特征

```objc
[peripheral discoverCharacteristics:nil forService:service];;
```

#### 订阅特征的通知

```objc
//这里外设需要订阅特征的通知，否则无法收到外设发送过来的数据
[peripheral setNotifyValue:YES forCharacteristic:characteristic];
```

#### 读取特征中的值

```objc
[peripheral readValueForCharacteristic:characteristic];
```

#### 写数据到特征

```objc
Byte value[2] = {0};
value[0]= 0x00;
value[1]= 0x01;
            
[self.peripheral writeValue:[NSData dataWithBytes:value length:2] forCharacteristic:self.FFA8Charac type:CBCharacteristicWriteWithResponse];
```

### CBCentralManagerDelegate 代理方法

*1、蓝牙中心状态改变:*

```objc
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
```

*2、搜索到外设:*

```objc
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
```

*3、外设已连接:*

```objc
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
```

*4、外设断开连接:*

```objc
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
```

*5、连接外设失败:*

```objc 
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
```

### CBPeripheralDelegate 代理方法

*1、搜索到服务:*

```objc
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
```
*2、搜索到特征:*

```objc
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
```

*3、给特征写命令:*

```objc
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
```

*4、特征更新数据:*

```objc 
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
```

### 高级部分

#### 根据 UUID 获取已配对的设备

```objc
NSString * uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:BleBindUUID];
NSLog(@" bind uuidStr == %@",uuidStr);
if (uuidStr != nil) {
                
	NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:uuidStr];
	NSArray * peripheralsArr = [central retrievePeripheralsWithIdentifiers:@[uuid]];
	if (peripheralsArr.count > 0) {
		CBPeripheral *peripheral = [peripherals firstObject];
		self.peripheral = peripheral;//**关键**需要转存外设值，才能发起连接
		self.peripheral.delegate = self;
		NSLog(@"self.peripheral == %@",self.peripheral);
    }
}
```

#### 电量数据处理

```objc
NSString * string = [self convertDataToHexStr:characteristic.value];
unsigned long str  = strtoul([string UTF8String], 0, 16);
NSString * battery = [NSString stringWithFormat:@"%lu%@",str,@"%"];

NSLog(@"battery == %@",battery);
```

#### NSData 转 NSString

```objc
NSString * value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];

NSLog(@"device value == %@",value);
```

#### NSData 转 Byte数组

```objc
Byte * resultByte = (Byte *)[data bytes];
    
for (int i = 0; i < data.length; i++) {
	NSLog(@"%d",resultByte[i]);
}
```

#### Byte 中从低位到高位依次获取每一位Bit的值

*一个字节包含8个二进制位，每个二进制位的数值为1或0！*

```objc
Byte * resultByte = (Byte *)[data bytes];
  
Byte hour0 = resultByte[0];
Byte min0  = resultByte[1];
Byte week = resultByte[2];
        
Byte sun = week % 2;          //获取第0位
Byte mon = week % 4 / 2;
Byte tues  = week % 8 / 4;
Byte wed = week % 16 / 8;
Byte thur = week % 32 / 16;
Byte fri = week % 64 / 32;
Byte sat = week % 128 / 64;
Byte isOpen = week / 128;    //获取第7位
```

#### Byte 中对任意一位置1或置0

```objc
Byte notice[1]={0xff};

// 第 0 位 置1
notice[0] = notice[0] | 0b00000001;
// 第 0 位 置0
notice[0] = notice[0] & 0b11111110;

// 第 1 位 置1
notice[0] = notice[0] | 0b00000010;
// 第 1 位 置0
notice[0] = notice[0] & 0b11111101;

notice[0] = notice[0] | 0b00000100;
notice[0] = notice[0] & 0b11111011;

notice[0] = notice[0] | 0b00001000;
notice[0] = notice[0] & 0b11110111;

notice[0] = notice[0] | 0b00010000;
notice[0] = notice[0] & 0b11101111;

notice[0] = notice[0] | 0b00100000;
notice[0] = notice[0] & 0b11011111;

notice[0] = notice[0] | 0b01000000;
notice[0] = notice[0] & 0b10111111;

// 第 7 位 置1
notice[0] = notice[0] | 0b10000000;
// 第 7 位 置0
notice[0] = notice[0] & 0b01111111;
```
*他最大的乐趣一直是来自学习本身...*