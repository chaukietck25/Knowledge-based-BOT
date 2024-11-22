import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:knowledge_based_bot/Views/auth/components/sign_in_form.dart';
import 'package:knowledge_based_bot/Views/auth/components/sign_up_form.dart';
class CustomSignInDialog extends StatefulWidget {
  final ValueChanged onClosed;

  const CustomSignInDialog({super.key, required this.onClosed});

  @override
  _CustomSignInDialogState createState() => _CustomSignInDialogState();
}

class _CustomSignInDialogState extends State<CustomSignInDialog> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 697,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.all(Radius.circular(40))),
        child: Scaffold(
          
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 16)),
                
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: const [
                      SignInForm(),
                      SignUpForm(),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    "Bằng cách đăng nhập, bạn đồng ý với các điều khoản và điều kiện của chúng tôi",
                    textAlign: TextAlign.left,
                  ),
                ),
                
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Hoặc",
                        style: TextStyle(color: Colors.black26),
                      ),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("Đăng kí với Google",
                      style: TextStyle(color: Colors.black54)),
                ),
                IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/google_box.svg",
                          height: 64,
                          width: 64,
                        ))
              ]),
              const Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Sign up",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
            position: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child);
      },
      pageBuilder: (context, _, __) => CustomSignInDialog(onClosed: onClosed))
      .then(onClosed);
}

// Future<Object?> customSigninDialog(BuildContext context,
//     {required ValueChanged onClosed}) {
//   int _selectedIndex = 0;
//   // void _onTabTapped(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }

//   return showGeneralDialog(
//       barrierDismissible: true,
//       barrierLabel: "Sign up",
//       context: context,
//       transitionDuration: const Duration(milliseconds: 400),
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
//         return SlideTransition(
//             position: tween.animate(
//                 CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
//             child: child);
//       },
//       pageBuilder: (context, _, __) => Center(
//             child: Container(
//               height: 620,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.95),
//                   borderRadius: const BorderRadius.all(Radius.circular(40))),
//               child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 resizeToAvoidBottomInset:
//                     false, // avoid overflow error when keyboard shows up
//                 body: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Column(children: [
//                       Row(
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               // Handle open sign in form
//                               setState(() {
//                                 _selectedIndex = 0;
//                               });
//                             },
//                             child: const Text(
//                               "Đăng nhập",
//                               style: TextStyle(
//                                   fontSize: 34, fontFamily: "Poppins"),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // Handle open sign up form
//                               setState(() {
//                                 _selectedIndex = 1;
//                               });
//                             },
//                             child: Text(
//                               'Đăng ký',
//                               style: TextStyle(
//                                   fontSize: 34, fontFamily: "Poppins")
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                         child: Text(
//                           "Access to 240+ hours of content. Learn design and code, by builder real apps with Flutter and Swift.",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Expanded(
//                         child: IndexedStack(
//                           index: _selectedIndex,
//                           children: const [
//                             SignInForm(),
//                             SignUpForm(),
//                           ],
//                         ),
//                       ),
                   
//                       const Row(
//                         children: [
//                           Expanded(
//                             child: Divider(),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               "OR",
//                               style: TextStyle(color: Colors.black26),
//                             ),
//                           ),
//                           Expanded(
//                             child: Divider(),
//                           ),
//                         ],
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 20.0),
//                         child: Text("Sign up with Email, Apple or Google",
//                             style: TextStyle(color: Colors.black54)),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () {
//                                 // Handle open sign up form
//                               },
//                               icon: SvgPicture.asset(
//                                 "assets/icons/email_box.svg",
//                                 height: 64,
//                                 width: 64,
//                               )),
//                           IconButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () {},
//                               icon: SvgPicture.asset(
//                                 "assets/icons/apple_box.svg",
//                                 height: 64,
//                                 width: 64,
//                               )),
//                           IconButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () {},
//                               icon: SvgPicture.asset(
//                                 "assets/icons/google_box.svg",
//                                 height: 64,
//                                 width: 64,
//                               ))
//                         ],
//                       )
//                     ]),
//                     const Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: -48,
//                       child: CircleAvatar(
//                         radius: 16,
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.close, color: Colors.black),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )).then(onClosed);
// }
