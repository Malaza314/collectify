import 'package:collectify/Widgets/loading_overlay.dart';
import 'package:collectify/Widgets/themedata.dart';
// import 'package:collectify/home/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gap/gap.dart';


const double h1 = 40.0;
const double h2 = 30.0;
const double h3 = 22.0;
const double h4 = 15.0;
const double h5 = 11.0;

Widget spacer1() => const Gap(40.0);
Widget spacer2() => const Gap(30.0);
Widget spacer3() => const Gap(20.0);
Widget spacer4() => const Gap(10.0);
Widget spacer5() => const Gap(5.0);

TextStyle contentTextStyle({
  double fontSize = h3,
  FontWeight fontWeight = FontWeight.normal,
  Color? fontColor,
  bool isButtonStyle = false,
}) {
  Color effectiveFontColor = fontColor ??
      (isButtonStyle ? Colors.white : Colors.black);
  return TextStyle(
      fontSize: fontSize, fontWeight: fontWeight, color: effectiveFontColor);
}

Align contentText(
    {Alignment alignment = Alignment.topLeft,
    double padding = 12.0,
    double fontSize = h3,
    FontWeight fontWeight = FontWeight.normal,
    Color fontColor = Colors.black,
    TextAlign textAlign = TextAlign.center,
    required String data}) {
  return Align(
    alignment: alignment,
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        data,
        textAlign: textAlign,
        style: contentTextStyle(
            fontSize: fontSize, fontWeight: fontWeight, fontColor: fontColor),
      ),
    ),
  );
}

// - - - - APP BAR - - - -
AppBar appBar(BuildContext context, {
  bool automaticallyImplyLeading = false,
  Widget? leading,
  bool centerTitle = true,
  Widget? title,
  String? titleText,
  List<Widget>? actions
}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    leading: automaticallyImplyLeading && leading == null
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )
        : leading,
    centerTitle: centerTitle,
    title: titleText != null 
      ? Text(
        titleText, 
        style: contentTextStyle(
          fontSize: h2, 
          fontColor: white, 
          fontWeight: FontWeight.bold
        ),
      ) 
      : title,
    actions: actions,
    surfaceTintColor: Colors.transparent,
    backgroundColor: blue,
    elevation: 0,
  );
}

Future<void> showAwesomeDialog({
  required BuildContext context,
  String tittle = "Info",
  String? tittleText,
  String? message,
  double? width,
  Widget? body,
  VoidCallback? btnOkOnPress,
  String? btnOkText,
  Color btnOkColor = neumorphic_light,
  Color btnCancelColor = neumorphic_light,
  VoidCallback? btnCancelOnPress, required AnimType animType, required DialogType dialogType, required String title,
}) async {
  bool isMobile = MediaQuery.of(context).size.width < 600;

  AwesomeDialog(
    width: isMobile
        ? MediaQuery.of(context).size.width * 0.95
        : MediaQuery.of(context).size.width / 2,
    context: context,
    dialogType: tittle == "Success"
        ? DialogType.success
        : tittle == "Warning"
            ? DialogType.warning
            : tittle == "Error"
                ? DialogType.error
                : tittle == "question"
                    ? DialogType.question
                    : DialogType.noHeader,
    dialogBorderRadius: BorderRadius.circular(20.0),
    buttonsBorderRadius: BorderRadius.circular(8.0),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    buttonsTextStyle: contentTextStyle(
      fontSize: h4,
      fontColor: white,
    ),
    btnOkOnPress: btnOkOnPress,
    btnOkText: btnOkText ?? "OK",
    btnOkColor: btnOkColor,
    btnCancelOnPress: btnCancelOnPress,
    btnCancelColor: btnCancelColor,
    animType: AnimType.scale,
    title: tittleText ?? tittle,
    titleTextStyle: const TextStyle(
        color: white, fontWeight: FontWeight.bold, fontSize: 20),
    // descTextStyle: contentTextStyle(fontSize: h4, fontColor: purple_indigo),
    // desc: message,

    padding: const EdgeInsets.all(18.0),
    body: LoadingOverlay(
      child: body ?? const Text(""),
    ),
    showCloseIcon: btnOkOnPress == null,
    closeIcon: const Icon(
      Icons.cancel_rounded,
      color: red,
      size: 30.0,
    ),
  ).show();
}

Future<void> showAlertDialog({
  required BuildContext context,
  required String titleText,
  required Widget content,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          titleText,
          style: contentTextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: content,
      );
    },
  );
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final Color? textColor;
  final void Function(String)? onEditingComplete;
  final void Function(String)? onChanged;
  final String hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final Color backgroundColor;
  final double height;
  final double? width;
  final bool password;
  final bool? enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    this.textColor,
    this.onEditingComplete,
    this.onChanged,
    required this.hintText,
    this.icon,
    this.suffixIcon,
    required this.backgroundColor,
    required this.height,
    this.width,
    this.password = false,
    this.enabled,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  int currentLines = 1;
  int maxLines = 6;

  @override
  void initState() {
    super.initState();
    if (!widget.password) {
      widget.controller.addListener(_adjustHeight);
    }
  }

  @override
  void dispose() {
    if (!widget.password) {
      widget.controller.removeListener(_adjustHeight);
    }
    super.dispose();
  }

  void _adjustHeight() {
    final text = widget.controller.text;
    final lines = '\n'.allMatches(text).length + 1;
    setState(() {
      currentLines = lines;
    });
  }

  @override
  Widget build(BuildContext context) {
    double calculatedHeight =
        widget.password ? widget.height : (currentLines * 20).toDouble();
    calculatedHeight = calculatedHeight.clamp(widget.height, widget.height * 2);

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.password,
        onFieldSubmitted: widget.onEditingComplete,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        minLines: 1,
        scrollPhysics: const BouncingScrollPhysics(),
        maxLines: widget.password ? 1 : maxLines,
        keyboardType: widget.password ? TextInputType.text : TextInputType.multiline,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: Colors.deepPurple)
              : null,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle: contentTextStyle(
            fontSize: h5,
            fontColor: blue, 
            fontWeight: FontWeight.w600
          )
          ,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: contentTextStyle(
          fontSize: h4, 
          fontColor: widget.textColor ?? dark_blue
        ),
      ),
    );
  }
}

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final void Function(String)? onSubmitted;
//   final String hintText;
//   final IconData? icon;
//   final Widget? suffixIcon;
//   final Color backgroundColor;
//   final double height;
//   final double width;
//   final bool obscureText;

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     this.onSubmitted,
//     required this.hintText,
//     this.icon,
//     this.suffixIcon,
//     required this.backgroundColor,
//     required this.height,
//     required this.width,
//     this.obscureText = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         onSubmitted: onSubmitted,
//         maxLines: 1,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: deep_magenta),
//           suffixIcon: suffixIcon,
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.black54),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: height * 0.3),
//         ),
//         style: const TextStyle(fontSize: 16, color: dark_blue),
//       ),
//     );
//   }
// }

class CustomElevatedButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Color? textColor;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;

  const CustomElevatedButton(
      {Key? key,
      this.color,
      required this.text,
      this.textColor,
      required this.onPressed,
      this.icon,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return ElevatedButton(
      // iconAlignment: IconAlignment.end,

      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? dark_blue,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: isMobile ? 15 : 18,
                color: textColor ?? white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Icon(
              icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}



showScaffoldMessenger ({
  required BuildContext context, 
  required String message, 
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? red : green,
      content: Text(
        message, 
        style: contentTextStyle(
          fontColor: white,
          fontSize: h4,
        ),
      ),
    ),
  );
}


ElevatedButton customElevatedButton({
  required void Function()? onPressed,
  required String text,
  Color? color = blue,
  Color? textColor,
}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        text,
        style: contentTextStyle(
          fontColor: white,
          fontSize: h4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
}