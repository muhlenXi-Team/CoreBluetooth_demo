#### XYJConversionTool 进制转换工具

* *单字节 16 进制字符串转为 10 进制整数  @"bb" -> 187*

	    convertHexadecimalToDecimal:(NSString *) hex;

* *16进制字符串转10进制数  @"A" -> 10*

		convertAlphabetToUint8:(NSString *) alphabet;

* *将十进制整数转化为十六进制字符串*

		convertllintToHexString:(long long int) value
	
* *NSData 转换成十六进制字符串*


	    convertDataToHexStr:(NSData *)data;