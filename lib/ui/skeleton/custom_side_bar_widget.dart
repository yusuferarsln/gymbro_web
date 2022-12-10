import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/ui/skeleton/screen_size.dart';
import 'package:gymbro_web/ui/skeleton/sidebar_page.dart';

import '../../constants/appcolors.dart';

class CustomSideBarWidget extends ConsumerStatefulWidget {
  const CustomSideBarWidget({
    super.key,
    required this.size,
    required this.onSelected,
    this.pageX,
  });

  final ScreenSize size;
  final ValueChanged<int> onSelected;
  final AccountType? pageX;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomSideBarWidgetState();
}

class _CustomSideBarWidgetState extends ConsumerState<CustomSideBarWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [];
    if (widget.pageX == AccountType.broAdmin) {
      pages = SidebarRootPage.values;
    } else {
      pages = SidebarPage.values;
    }

    return Expanded(
      child: Container(
        width: widget.size == ScreenSize.large ? 250 : 65,
        color: AppColors.oliveBlack,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int i = 0; i < pages.length; i++)
              ListTile(
                selected: i == _selectedIndex,
                onTap: () {
                  setState(() => _selectedIndex = i);
                  widget.onSelected(i);
                },
                title: widget.size == ScreenSize.large
                    ? Text(pages[i].title)
                    : const Text(''),
                leading: widget.size == ScreenSize.large
                    ? Icon(pages[i].icon)
                    : Icon(
                        pages[i].icon,
                      ),
                trailing: widget.size == ScreenSize.large
                    ? const Icon(
                        Icons.chevron_right_rounded,
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
