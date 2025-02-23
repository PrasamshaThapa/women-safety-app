import 'package:flutter/cupertino.dart';

import 'custom_dialog.dart';
import 'custom_permission_dialog.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  showCustomDialog(
    context,
    title: 'LOGOUT!',
    description: 'Are you sure you want to logout?',
    action: (context) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: AlertOutlinedButton(
            title: 'YES',
            isLeft: true,
            // onTap: () => _logout(context),
            onTap: () {},
          ),
        ),
        Expanded(
          child: AlertOutlinedButton(
            title: 'NO',
            isLeft: false,
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  );
}

// void _logout(BuildContext context) {
//   final authBloc = context.read<AuthBloc>();
//   var user = authBloc.state.user;
//   JsonMap data = {
//     'refreshToken': user?.refreshToken,
//   };
//   authBloc.add(AuthEvent.logoutPressed(data: data));
//   CustomToasts.success('Logging Out');
//   AutoRouter.of(context).maybePop();
// }
