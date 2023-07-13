import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_motivation/constants/assets_color.dart';
import 'package:flutter_motivation/data/models/quotes.dart';
import 'package:flutter_motivation/utils/message.dart';
import 'package:flutter_motivation/widgets/items/item_quote.dart';
import 'package:flutter_motivation/widgets/texts/poppins_text.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/search_page_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late FocusNode focusNode;
  late SearchPageBloc searchPageBloc;
  @override
  void initState() {
    super.initState();
    searchPageBloc = BlocProvider.of<SearchPageBloc>(context);
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetsColor.white,
      appBar: AppBar(
          title: TextField(
        focusNode: focusNode,
        cursorColor: AssetsColor.white,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            searchPageBloc.add(SearchQuoteEvent(value));
          } else {
            Message.showFailedToast(
                FToast().init(context), "Masukan kata kunci pencarian");
          }
        },
        style: GoogleFonts.poppins(color: AssetsColor.white, fontSize: 18),
        decoration: InputDecoration(
            hintText: "Cari kata atau nama tokoh",
            hintStyle: GoogleFonts.poppins(color: AssetsColor.grey)),
      )),
      body: BlocBuilder<SearchPageBloc, SearchPageState>(
        builder: (context, state) {
          if (state is SearchPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchPageSuccess) {
            if (state.data.data?.result?.isNotEmpty ?? false) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PoppinsTextWidget(
                          text: state.data.data?.paginate ?? "",
                          fontColor: AssetsColor.black,
                          fontSize: 16.sp),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.data.data!.result?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ItemQuoteWidget(
                              keys: GlobalKey(),
                              model:
                                  state.data.data!.result?[index] ?? Quotes());
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocProvider<PaginationCubit>(
                              create: (context) => PaginationCubit(
                                  searchPageBloc: searchPageBloc),
                              child: BlocBuilder<PaginationCubit, int>(
                                builder: (context, page) {
                                  //  ListView.separated(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 20),
                                  //     separatorBuilder: (context, index) {
                                  //       return const SizedBox(
                                  //         width: 20,
                                  //       );
                                  //     },
                                  //     itemCount: state.data.data?.lastPaginate ?? 0,
                                  //     scrollDirection: Axis.horizontal,
                                  //     shrinkWrap: true,
                                  //     itemBuilder: (context, index) {
                                  //       return SizedBox(
                                  //           width: 48.w,
                                  //           height: 48.w,
                                  //           child: ElevatedButton(
                                  //             style: ElevatedButton.styleFrom(
                                  //                 backgroundColor:
                                  //                     page == index
                                  //                         ? AssetsColor.greyYoung
                                  //                         : AssetsColor.primary),
                                  //             onPressed: () {
                                  //               context
                                  //                   .read<PaginationCubit>()
                                  //                   .changePage(index + 1,
                                  //                       searchPageBloc.world);
                                  //             },
                                  //             child: PoppinsTextWidget(
                                  //                 text: (index + 1).toString(),
                                  //                 fontColor: page == index
                                  //                     ? AssetsColor.secondary
                                  //                     : AssetsColor.white,
                                  //                 fontSize: 15.sp),
                                  //           ));
                                  //     });
                                  int totalPaginate =
                                      state.data.data?.lastPaginate ?? 0;
                                  int jumlahPage = 5;
                                  return Pagination(
                                    paginateButtonStyles: PaginateButtonStyles(
                                        textStyle: GoogleFonts.poppins(
                                            color: AssetsColor.white)),
                                    prevButtonStyles: PaginateSkipButton(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))),
                                    nextButtonStyles: PaginateSkipButton(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    onPageChange: (number) {
                                      context
                                          .read<PaginationCubit>()
                                          .changePage(
                                              number,
                                              BlocProvider.of<SearchPageBloc>(
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
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: PoppinsTextWidget(
                      text:
                          "Tidak ditemukan kata kunci '${searchPageBloc.world}'",
                      fontColor: Colors.red,
                      textAlign: TextAlign.center,
                      fontSize: 20.sp),
                ),
              );
            }
          } else if (state is SearchPageError) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: PoppinsTextWidget(
                    text: "Error get data",
                    fontColor: Colors.red,
                    fontSize: 20.sp),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
