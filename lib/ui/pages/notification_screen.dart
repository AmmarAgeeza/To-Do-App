import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  String _payload = '';

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  'Hello , Ammar',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,

                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Title',
                            style: TextStyle(color: Colors.white,fontSize: 30),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(_payload.toString().split('|')[0],style: const TextStyle(color: Colors.white,fontSize: 20,),),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Description',
                            style: TextStyle(color: Colors.white,fontSize: 40),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(_payload.toString().split('|')[1],textAlign: TextAlign.justify,style: const TextStyle(color: Colors.white,fontSize: 20,),),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Date',
                            style: TextStyle(color: Colors.white,fontSize: 40),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(_payload.toString().split('|')[2],style: const TextStyle(color: Colors.white,fontSize: 20,),),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
