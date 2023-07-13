import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_motivation/constants/assets_color.dart';
import 'package:flutter_motivation/data/models/status.dart';
import 'package:flutter_motivation/modules/homePage/bloc/home_page_bloc.dart';
import 'package:flutter_motivation/modules/searchPage/search_page.dart';
import 'package:flutter_motivation/widgets/texts/poppins_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/items/item_quote.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late HomePageBloc homePageBloc;

  @override
  void initState() {
    super.initState();
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    homePageBloc.add(GetRandomQuoteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PoppinsTextWidget(
          text: "Motivasi - Kata",
          fontColor: AssetsColor.white,
          fontSize: 20,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            icon: RotatedBox(
              quarterTurns: 1,
              child: SvgPicture.asset(
                "assets/icons/ic_search.svg",
                colorFilter:
                    ColorFilter.mode(AssetsColor.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      backgroundColor: AssetsColor.white,
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == Status.SUCCESS) {
            return RefreshIndicator(
              onRefresh: () async {
                return homePageBloc.add(GetRandomQuoteEvent());
              },
              child: LayoutBuilder(builder: (context, constraint) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraint.maxHeight,
                      minWidth: double.infinity),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: PoppinsTextWidget(
                              text: "Tarik kebawah untuk merefresh",
                              fontColor: AssetsColor.grey,
                              fontSize: 12.sp),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 20,
                                ),
                            shrinkWrap: true,
                            itemCount: state.model.data?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ItemQuoteWidget(
                                keys: GlobalKey(),
                                model: state.model.data![index],
                              );
                            }),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else if (state.status == Status.ERROR) {
            return Center(
              child: PoppinsTextWidget(
                  text: "Opps Error", fontColor: Colors.red, fontSize: 20.sp),
            );
          }
          return const SizedBox();
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   backgroundColor: AssetsColor.secondary,
      //   onPressed: () {
      //     Navigator.of(context).push(
      //         MaterialPageRoute(builder: (context) => const SearchPage()));
      //   },
      //   child: SvgPicture.asset(
      //     "assets/icons/ic_search.svg",
      //     color: AssetsColor.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomNavigationBar(
      //     backgroundColor: Colors.white,
      //     selectedLabelStyle: GoogleFonts.poppins(),
      //     unselectedLabelStyle: GoogleFonts.poppins(),
      //     selectedItemColor: AssetsColor.black,
      //     unselectedItemColor: AssetsColor.black,
      //     selectedFontSize: 14,
      //     unselectedFontSize: 14,
      //     onTap: (index) {
      //       if (index == 0) {
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (context) => const CounteryPage()));
      //       }
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset(
      //           "assets/icons/ic_country.svg",
      //         ),
      //         label: "Negara",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: SvgPicture.asset("assets/icons/ic_category.svg"),
      //         label: "Kategori",
      //       )
      //     ]),
    );
  }
}
