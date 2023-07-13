import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_motivation/constants/assets_color.dart';
import 'package:flutter_motivation/modules/homePage/screen/home_page.dart';
import 'package:flutter_motivation/modules/searchPage/bloc/search_page_bloc.dart';
import 'package:flutter_motivation/widgets/items/item_quote.dart';
import 'package:flutter_motivation/widgets/texts/poppins_text.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/quotes.dart';
import '../../utils/message.dart';

class WebMotivationPage extends StatelessWidget {
  const WebMotivationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetsColor.white,
      body: ScreenUtil().orientation != Orientation.landscape
          ? const HomePageScreen()
          : Row(
              children: [
                BlocBuilder<SearchPageBloc, SearchPageState>(
                  builder: (context, stateInit) {
                    return AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: stateInit is SearchPageInitial ? 1.sw : 0.4.sw,
                      color: AssetsColor.primary,
                      height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                stateInit is SearchPageInitial ? 50.w : 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/ic_launcher.png"))),
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              PoppinsTextWidget(
                                text: "Ayo cari kata motivasimu",
                                fontColor: AssetsColor.white,
                                fontSize: 24.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              PoppinsTextWidget(
                                text:
                                    "Temukan kata motivasi dari tokoh-tokoh terkenal diseluruh dunia",
                                fontColor: AssetsColor.white,
                                textAlign: TextAlign.center,
                                fontSize: 16.sp,
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              TextField(
                                cursorColor: AssetsColor.primary,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    BlocProvider.of<SearchPageBloc>(context)
                                        .add(SearchQuoteEvent(value));
                                  } else {
                                    Message.showFailedToast(
                                        FToast().init(context),
                                        "Masukan kata kunci pencarian");
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: AssetsColor.primary, fontSize: 18),
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: AssetsColor.white,
                                    hintText: "Cari kata atau nama tokoh",
                                    hintStyle: GoogleFonts.poppins(
                                        color: AssetsColor.grey)),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<SearchPageBloc, SearchPageState>(
                  builder: (context, state) {
                    return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: state is SearchPageInitial ? 0 : 0.6.sw,
                        height: double.infinity,
                        color: AssetsColor.white,
                        child: BlocBuilder<SearchPageBloc, SearchPageState>(
                          builder: (context, state) {
                            if (state is SearchPageLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is SearchPageSuccess) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: PoppinsTextWidget(
                                          text: state.data.data?.paginate ?? "",
                                          fontColor: AssetsColor.black,
                                          fontSize: 16.sp),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: PoppinsTextWidget(
                                          text:
                                              "Maksimal sampai halaman ${state.data.data?.lastPaginate ?? 0}",
                                          fontColor: AssetsColor.black,
                                          fontSize: 12.sp),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 20,
                                          );
                                        },
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            state.data.data!.result?.length ??
                                                0,
                                        itemBuilder: (context, index) {
                                          return ItemQuoteWidget(
                                              keys: GlobalKey(),
                                              model: state.data.data!
                                                      .result?[index] ??
                                                  Quotes());
                                        }),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          BlocProvider<PaginationCubit>(
                                              create: (context) =>
                                                  PaginationCubit(
                                                      searchPageBloc: BlocProvider
                                                          .of<SearchPageBloc>(
                                                              context)),
                                              child: BlocBuilder<
                                                  PaginationCubit, int>(
                                                builder: (context, page) {
                                                  // return ListView.separated(
                                                  //     padding:
                                                  //         const EdgeInsets.symmetric(
                                                  //             horizontal: 20),
                                                  //     separatorBuilder:
                                                  //         (context, index) {
                                                  //       return const SizedBox(
                                                  //         width: 20,
                                                  //       );
                                                  //     },
                                                  //     itemCount: state.data.data
                                                  //             ?.lastPaginate ??
                                                  //         0,
                                                  //     scrollDirection: Axis.horizontal,
                                                  //     shrinkWrap: true,
                                                  //     itemBuilder: (context, index) {
                                                  //       return ConstrainedBox(
                                                  //           constraints:
                                                  //               const BoxConstraints(
                                                  //                   minWidth: 48),
                                                  //           child: ElevatedButton(
                                                  //             style: ElevatedButton.styleFrom(
                                                  //                 backgroundColor:
                                                  //                     stateCubit ==
                                                  //                             index
                                                  //                         ? AssetsColor
                                                  //                             .greyYoung
                                                  //                         : AssetsColor
                                                  //                             .primary),
                                                  //             onPressed: () {
                                                  //               context
                                                  //                   .read<
                                                  //                       PaginationCubit>()
                                                  //                   .changePage(
                                                  //                       index + 1,
                                                  //                       BlocProvider.of<
                                                  //                                   SearchPageBloc>(
                                                  //                               context)
                                                  //                           .world);
                                                  //             },
                                                  //             child: PoppinsTextWidget(
                                                  //                 text: (index + 1)
                                                  //                     .toString(),
                                                  //                 fontColor:
                                                  //                     stateCubit ==
                                                  //                             index
                                                  //                         ? AssetsColor
                                                  //                             .secondary
                                                  //                         : AssetsColor
                                                  //                             .white,
                                                  //                 fontSize: 15.sp),
                                                  //           ));
                                                  //     });
                                                  int totalPaginate = state.data
                                                          .data?.lastPaginate ??
                                                      0;
                                                  int jumlahPage = 5;
                                                  return Pagination(
                                                    paginateButtonStyles:
                                                        PaginateButtonStyles(
                                                            textStyle: GoogleFonts
                                                                .poppins(
                                                                    color: AssetsColor
                                                                        .white)),
                                                    prevButtonStyles: PaginateSkipButton(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20))),
                                                    nextButtonStyles: PaginateSkipButton(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        20))),
                                                    onPageChange: (number) {
                                                      context
                                                          .read<
                                                              PaginationCubit>()
                                                          .changePage(
                                                              number,
                                                              BlocProvider.of<
                                                                          SearchPageBloc>(
                                                                      context)
                                                                  .world);
                                                    },
                                                    useGroup: false,
                                                    totalPage: totalPaginate,
                                                    width: 0.6.w,
                                                    show: 2,
                                                    currentPage: page + 1,
                                                  );
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        ));
                  },
                )
              ],
            ),
    );
  }
}
