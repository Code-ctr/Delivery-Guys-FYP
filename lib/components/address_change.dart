import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:flutter/material.dart';

class ChangeAddress extends StatelessWidget {
  final TextEditingController addresscon;
  final TextEditingController phonenocon;

  ChangeAddress({
    super.key,
    required String address,
    required String mobileNumber,
  })  : addresscon = TextEditingController(text: address),
        phonenocon = TextEditingController(text: mobileNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 192, 219),
      appBar: AppBar(
        title: const Text("Changing Address"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 90,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: 400,
                    width: 370,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Change your Address if you think\nit's not the correct delivery address",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          controller: addresscon,
                          hinttext: "Your Address",
                          obscuretext: false,
                          enabled: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: phonenocon,
                          hinttext: "Mobile Number",
                          obscuretext: false,
                          enabled: true,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        MyButton(
                          color: Colors.black,
                          hintText: "Change",
                          onTap: () {
                            Navigator.pop(context, {
                              'address': addresscon.text,
                              'mobileNumber': phonenocon.text,
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
