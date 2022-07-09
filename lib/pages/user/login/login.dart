import 'package:Tik/pages/user/login/phone_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wheel/wheel.dart';

import '../../../component/dialogs.dart';
import '../../../component/page_dia_code_selection.dart';
import '../../../networking/rest/login/login_provider.dart';
import '../../../themes/global_style.dart';
import 'login_controller.dart';
import 'login_password.dart';

class Login extends StatelessWidget {
  const Login({Key? key, required this.regions, this.inputController})
      : super(key: key);
  final List<RegionFlag> regions;
  final inputController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          double screenWidth = MediaQuery.of(context).size.width;

          Future<void> onPhoneChanged() async {
            final text = inputController.text;
            controller.userName.value = text;
          }

          Future<void> onNextClick() async {
            final text = inputController.text;
            if (text.isEmpty) {
              return;
            }

            final result = await showLoaderOverlay(
              context,
              LoginApi.checkPhoneExist(
                text,
                controller.getDefaultRegionFlag.dialCode!
                    .replaceAll("+", "")
                    .replaceAll(" ", ""),
              ),
            );
          }

          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text("红矮星词典"),
                actions: [],
              ),
              body: Form(
                key: controller.sigInFormKey.value,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 60),
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 45,
                                  width: screenWidth * 0.9,
                                  child: PhoneInput(
                                    selectedRegion:
                                        controller.getDefaultRegionFlag,
                                    onPrefixTap: () async {
                                      final RegionFlag region =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return RegionSelectionPage(
                                              regions: regions);
                                        }),
                                      );
                                      if (region != null) {
                                        controller.updateCurrentFlag(region);
                                      }
                                    },
                                    onDone: onNextClick,
                                    onPhoneChanged: onPhoneChanged,
                                    controller: inputController,
                                  )),
                            ],
                          )),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Builder(
                              builder: (context) {
                                return ButtonTheme(
                                    minWidth: screenWidth * 0.85,
                                    height: 50.0,
                                    child: Center(
                                        child: ElevatedButton(
                                      style:
                                          GlobalStyle.getButtonStyle(context),
                                      onPressed: () async {
                                        String phone = controller
                                                .getDefaultRegionFlag
                                                .dialCode! +
                                            controller.userName.value;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => LoginPassword(
                                              phone: phone,
                                            ),
                                          ),
                                        );
                                      },
                                      child: controller.submitting.value
                                          ? SizedBox(
                                              height: 45,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              ),
                                            )
                                          : Text("下一步"),
                                    )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
