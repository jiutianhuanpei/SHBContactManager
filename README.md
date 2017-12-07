# SHBContactManager
获取系统联系人


把系统的 AddressBook 和 Contacts 两个框架进行组件化封装，以便在不同的系统版本下可以运行对应的api。

封装出的组件外放了三个api:

方法 | 说明 
|:---|:---|
- (void)HYMediator_applyForPermission:(void(^)(BOOL granted, NSError \*error))handler | 获取系统读取通讯录权限
- (NSArray \<NSDictionary \*>\*)HYMediator_fetchAllLocalContacts | 读取所有的，符合规则的成员，规则写在 `ContactsTools` 文件里。
- (void)HYMediator_contactsDidChanged:(dispatch\_block\_t)handler | 接收通讯录有改变时的通知回调

