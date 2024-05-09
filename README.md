# IT_Flutter_and_MQTT
https://ithelp.ithome.com.tw/articles/10251279?sc=rss.iron

問題一：client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload); //The argument type 'Uint8Buffer?' can't be assigned to the parameter type 'Uint8Buffer'. dartargument_type_not_assignable
問題二：可能因改版 之前的 Future<MqttServerClient> connect() async 不用回傳，現在需要
