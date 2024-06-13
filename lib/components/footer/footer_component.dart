import 'package:flutter/material.dart';
import 'package:musicmate/constants/theme.dart';
import 'styles.dart';

class FooterComponent extends StatelessWidget {
  final SizedBox? footerSize;
  final Widget child;
  final BoxDecoration? footerStyle;
  final EdgeInsetsGeometry? footerMargin;
  final EdgeInsetsGeometry? footerPadding;

  const FooterComponent(
      {super.key,
      this.footerSize,
      required this.child,
      this.footerStyle,
      this.footerMargin,
      this.footerPadding});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          child: Container(
              height: footerSize?.height ?? Metrics.height(context) * 0.09,
              margin: footerMargin,
              width: double.infinity,
              padding: footerPadding,
              decoration: Styles.footerStyle.copyWith(
                color: footerStyle?.color,
                gradient: footerStyle?.gradient,
                shape: footerStyle?.shape,
                border: footerStyle?.border,
                borderRadius: footerStyle?.borderRadius,
              ),
              child: child

              // ButtonComponent(
              //   btnTitle: 'Confirm',
              //   btnTextStyle: TextStyle(
              //       fontSize: FontSize.medium,
              //       color: AppColor.white,
              //       fontWeight: FontWeight.bold),
              //   btnStyle: BoxDecoration(
              //       color: Colors.amber,
              //       borderRadius: BorderRadius.circular(5)),
              // )

              //  Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     const SizedBox(
              //       // width: Metrics.width(context) * 0.6,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Expanded(
              //               child: TextComponent(
              //             text: '123',
              //             textStyle: TextStyle(
              //                 color: AppColor.white,
              //                 fontSize: FontSize.content,
              //                 fontWeight: FontWeight.w700),
              //           )),
              //           Expanded(
              //               child: TextComponent(
              //                   text: 'Price',
              //                   textStyle:
              //                       TextStyle(color: AppColor.white)))
              //         ],
              //       ),
              //     ),
              
              //     ButtonComponent(
              //       btnTitle: 'Proceed',
              //       btnStyle: const BoxDecoration(
              //           color: AppColor.white,
              //           borderRadius:
              //               BorderRadius.all(Radius.circular(5))),
              //       btnSize: SizedBox(
              //         width: Metrics.width(context) * 0.3,
              //       ),
              //       btnTextStyle: const TextStyle(
              //           color: AppColor.aquaBlue,
              //           fontWeight: FontWeight.w700),
              //     )
              //   ],
              // )

              ),
        ),
      ),
    );
  }
}
