import 'package:web_view_ble/src/services/ble_service.dart';
import 'package:web_view_ble/web_view_ble.dart';

void registerRemoteCharacteristicsGattServer(controller) {
  //To read charcteristic
  controller.addJavaScriptHandler(
      handlerName: 'device:readCharacteristicValue',
      callback: (args) async {
        logInfo("readCharacteristicValue Called ${args.toString()}");
        String deviceID = args[0]['data']['deviceId'];
        String characteristicUUID = args[0]['data']['characteristicUUID'];
        String serviceUUID = args[0]['data']['serviceUUID'];
        var data = await BleService.to
            .readCharacteristics(characteristicUUID, serviceUUID, deviceID);
        return data;
      });

  //To write charcteristic
  controller.addJavaScriptHandler(
      handlerName: 'device:writeCharacteristicValue',
      callback: (args) async {
        logInfo("writeCharacteristicValue Called");
        print("#####LOGINFO###### "+args.toString());
        logWarning(args.toString());
        String deviceID = args[0]['data']['deviceId'];
        String characteristicUUID = args[0]['data']['characteristicUUID'];
        String serviceUUID = args[0]['data']['serviceUUID'];
        var value = args[0]['data']['value'];
        bool writeWithResponse = true;
        var s=await BleService.to.writeCharacteristics(characteristicUUID,
            serviceUUID, deviceID, value, writeWithResponse);
        return true;

      });

  //To Start Notification
  controller.addJavaScriptHandler(
      handlerName: 'device:startNotifications',
      callback: (args) async{
        logInfo("#####LOGINFO###### "+'Started notification ${args.toString()}');
        String deviceID = args[0]['data']['deviceId'];
        String characteristicUUID = args[0]['data']['characteristicUUID'];
        String serviceUUID = args[0]['data']['serviceUUID'];
        BleService.to.subscribeCharacteristics(
            characteristicUUID: characteristicUUID,
            serviceUUID: serviceUUID,
            deviceID: deviceID);
        await Future.delayed(Duration(seconds: 1));
        return true;
      });

  //To Stop Notification
  controller.addJavaScriptHandler(
      handlerName: 'device:stopNotifications',
      callback: (args) {
        String deviceID = args[0]['data']['deviceId'];
        String characteristicUUID = args[0]['data']['characteristicUUID'];
        String serviceUUID = args[0]['data']['serviceUUID'];
        BleService.to.unSubscribeCharacteristics(
            characteristicUUID: characteristicUUID,
            serviceUUID: serviceUUID,
            deviceID: deviceID);
        return true;

      });
}
