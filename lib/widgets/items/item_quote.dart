import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_motivation/utils/message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/assets_color.dart';
import '../../data/models/quotes.dart';

import 'dart:js' as js;
import 'dart:html' as html;

class ItemQuoteWidget extends StatelessWidget {
  const ItemQuoteWidget({super.key, required this.model, required this.keys});
  final Quotes model;
  final GlobalKey keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: keys,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(
                        text: "❝ ",
                        style: GoogleFonts.poppins(
                            color: AssetsColor.secondary, fontSize: 18.sp),
                        children: [
                          TextSpan(
                              text: model.q ?? "",
                              style: GoogleFonts.poppins(
                                  color: AssetsColor.black, fontSize: 23.sp)),
                          TextSpan(
                              text: " ❞",
                              style: GoogleFonts.poppins(
                                  color: AssetsColor.secondary,
                                  fontSize: 18.sp))
                        ])),
                    const SizedBox(
                      height: 12,
                    ),
                    Text.rich(TextSpan(
                        text: "- ${model.nama ?? "Anonim"}",
                        style: GoogleFonts.poppins(color: AssetsColor.black),
                        children: [
                          TextSpan(
                              text: " (${model.keterangan ?? "-"})",
                              style: GoogleFonts.poppins(color: Colors.grey))
                        ])),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
                color: AssetsColor.greyYoung.withOpacity(35 / 100),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await captureWidget(keys, context, false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/ic_gallery.svg",
                      colorFilter: ColorFilter.mode(
                          AssetsColor.secondary, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                InkWell(
                  onTap: () {
                    ClipboardData clipboard =
                        ClipboardData(text: "${model.q}\n- ${model.nama}");
                    Clipboard.setData(clipboard);
                    Message.showSuccessToast(
                        FToast().init(context), "Berhasil mengcopy");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/ic_copy.svg",
                      colorFilter: ColorFilter.mode(
                          AssetsColor.secondary, BlendMode.srcIn),
                    ),
                  ),
                ),
                kIsWeb
                    ? const SizedBox()
                    : const SizedBox(
                        width: 12,
                      ),
                kIsWeb
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          captureWidget(keys, context, true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_share.svg",
                            colorFilter: ColorFilter.mode(
                                AssetsColor.secondary, BlendMode.srcIn),
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  captureWidget(keys, context, isShare) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 24, maxWidth: 24),
              child: Center(
                child: CircularProgressIndicator(
                  color: AssetsColor.white,
                ),
              ));
        });
    final RenderRepaintBoundary boundary =
        keys.currentContext.findRenderObject();

    final ui.Image image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio);

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    if (kIsWeb) {
      js.context.callMethod(
        "saveAs",
        [
          html.Blob([pngBytes]),
          '${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().millisecond}.png',
        ],
      );
      Navigator.pop(context);
    } else {
      File f = File(
          "${(await getExternalStorageDirectory())?.path ?? (await getApplicationDocumentsDirectory()).path}/${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().millisecond}.jpg");
      await f.writeAsBytes(pngBytes);
      Navigator.pop(context);
      if (!isShare) {
        await OpenFilex.open(f.path);
      } else {
        await Share.shareXFiles([
          XFile(f.path),
        ], text: "Hi, im share quote from app 'Motivatisi - Kata'");
      }
    }
  }
}
