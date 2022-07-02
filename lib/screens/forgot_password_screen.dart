import 'package:flutter/material.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/auth_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import '../constants.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<AuthVm>(
      vm: AuthVm(context),
      builder: (context, vm, appVm, appUser) {
        return WillPopScope(
          onWillPop: () async {
            vm.updatePasswordResetSuccess(false);
            return false;
          },
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bluegradientColor, yellowgradientColor],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    IconButton(
                      onPressed: () {
                        vm.updatePasswordResetSuccess(false);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded),
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _headerBuilder(),
                          SizedBox(
                            height: 20.0,
                          ),
                          _inputBuilder(vm),
                          SizedBox(
                            height: 20.0,
                          ),
                          HotepButton.filled(
                            value: 'Submit',
                            onPressed: vm.sendPasswordResetMail,
                            loading: vm.stateType == StateType.busy,
                            borderRadius: 15.0,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          if (vm.passwordResetSuccess)
                            Text(
                              'Please check your email ${vm.emailController.text.trim()} for more details.',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Your Email',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'An mail will be sent to the following email address with all the guidance.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _inputBuilder(final AuthVm vm) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: whiteColor,
        border: Border.all(color: Colors.transparent),
      ),
      child: TextFormField(
        controller: vm.emailController,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
