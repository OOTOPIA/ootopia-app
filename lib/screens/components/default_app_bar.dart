import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AppBarComponents { back, menu, ooz, save, edit, close, proceed }

// ignore: must_be_immutable
class DefaultAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final List<AppBarComponents> components;
  final Function? onTapLeading;
  final Function? onTapTitle;
  final Function? onTapAction;

  DefaultAppBar({
    Key? key,
    required this.components,
    this.onTapLeading,
    this.onTapTitle,
    this.onTapAction,
  })  : preferredSize = Size.fromHeight(45),
        super(key: key);

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  late BuildContext _buildContext;

  bool _oozIsOpened = false;
  late WalletStore walletStore;
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  SmartPageController controller = SmartPageController.getInstance();
  Color iconColor = Color(0XFF3A4046);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (walletStore.wallet == null) {
        walletStore.getWallet();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    walletStore = Provider.of<WalletStore>(context);
    return AppBar(
      centerTitle: true,
      title: appTitle(),
      toolbarHeight: 45,
      elevation: 0.5,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: leading(),
      actions: actions(),
      flexibleSpace: Image(
        image: AssetImage(
          'assets/images/butterfly_top.png',
        ),
        alignment: Alignment.topCenter,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget get logo => Padding(
        padding: EdgeInsets.all(3),
        child: Image.asset(
          'assets/images/Logo-com-sombra.png',
          height: 34,
        ),
      );

  Widget appTitle() {
    if (widget.onTapTitle == null) return logo;
    return GestureDetector(
      onTap: () {
        widget.onTapTitle!();
      },
      child: logo,
    );
  }

  Widget? leading() {
    if (hasComponent(AppBarComponents.back)) {
      return back;
    }
    if (hasComponent(AppBarComponents.menu)) {
      return menu;
    }
    return null;
  }

  List<Widget>? actions() {
    return [
      if (hasComponent(AppBarComponents.ooz)) oozIcon,
      if (hasComponent(AppBarComponents.close)) closeIcon,
      if (hasComponent(AppBarComponents.edit)) editIcon,
      if (hasComponent(AppBarComponents.save)) saveIcon,
      if (hasComponent(AppBarComponents.proceed)) proceedIcon,
    ];
  }

  bool hasComponent(AppBarComponents component) {
    return widget.components.indexOf(component) != -1;
  }

  Widget get back => IconButton(
        onPressed: () {
          if (widget.onTapLeading != null) {
            widget.onTapLeading!();
          }
        },
        icon: Icon(
          FeatherIcons.arrowLeft,
          color: iconColor,
          size: 20,
        ),
      );

  Widget get menu => IconButton(
        onPressed: () {
          if (widget.onTapLeading != null) {
            widget.onTapLeading!();
          }
        },
        icon: Icon(
          FeatherIcons.menu,
          color: iconColor,
        ),
      );

  Widget get oozIcon => GestureDetector(
        onTap: () {
          setState(() {
            if (_oozIsOpened && !(currentPage is WalletPage)) {
              controller.insertPage(WalletPage());
            }
            _oozIsOpened = !_oozIsOpened;
          });
          if (_oozIsOpened) {
            Future.delayed(Duration(seconds: 5), () {
              setState(() {
                _oozIsOpened = false;
              });
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            right: _oozIsOpened
                ? GlobalConstants.of(_buildContext).spacingSmall
                : GlobalConstants.of(_buildContext).spacingNormal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedOpacity(
                opacity: _oozIsOpened ? 0 : 1,
                duration: Duration(milliseconds: 300),
                child: Visibility(
                  visible: !_oozIsOpened,
                  child: Image.asset(
                    'assets/icons/ooz_arrow.png',
                    height: 24,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _oozIsOpened ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Visibility(
                  visible: _oozIsOpened,
                  child: Observer(builder: (_) {
                    return Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ooz-coin-blue-small.svg',
                          color: Theme.of(context).accentColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            walletStore.wallet != null
                                ? '${walletStore.wallet!.totalBalance.toString().length > 6 ? NumberFormat.compact().format(walletStore.wallet?.totalBalance).replaceAll('.', ',') : walletStore.wallet?.totalBalance.toStringAsFixed(2).replaceAll('.', ',')}'
                                : '0,00',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: iconColor,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );

  Widget get closeIcon => IconButton(
        icon: Icon(
          Icons.close,
          color: iconColor,
        ),
        onPressed: () {
          if (widget.onTapAction != null) {
            widget.onTapAction!();
          }
        },
      );

  Widget get editIcon => InkWell(
        onTap: () {
          if (widget.onTapAction != null) {
            widget.onTapAction!();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            right: GlobalConstants.of(_buildContext).spacingNormal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  'assets/icons_profile/feather-edit-2.png',
                  width: 16,
                  color: Color(0xff03145C),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.edit,
                style: GoogleFonts.roboto(
                  color: Color(0xff03145C),
                  fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  Widget get saveIcon => InkWell(
        onTap: () async {
          if (widget.onTapAction != null) {
            widget.onTapAction!();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            right: GlobalConstants.of(_buildContext).spacingNormal,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Icon-feather-check.svg',
                width: 10,
                height: 12,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                AppLocalizations.of(context)!.save,
                style: GoogleFonts.roboto(
                    color: Color(0xff018f9c),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );

  Widget get proceedIcon => InkWell(
        onTap: () async {
          if (widget.onTapAction != null) {
            widget.onTapAction!();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            right: GlobalConstants.of(_buildContext).spacingNormal,
          ),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.proceed,
                style: GoogleFonts.roboto(
                    color: LightColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 8),
              Icon(
                FeatherIcons.arrowRight,
                color: iconColor,
                size: 20,
              ),
            ],
          ),
        ),
      );

  bool get hasNavigation =>
      controller.pages.length > controller.initialPages.length;
  Widget get currentPage => controller.pages[controller.currentPageIndex];
}
