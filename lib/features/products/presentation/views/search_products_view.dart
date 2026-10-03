import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/utils/local_image_mapper.dart';
import 'package:sufra_app/core/widgets/app_network_image.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';
import 'package:sufra_app/features/products/presentation/cubit/search/search_cubit.dart';
import 'package:sufra_app/features/products/presentation/cubit/search/search_state.dart';
import 'package:sufra_app/features/products/presentation/views/productDetailsView.dart';

class SearchProductsView extends StatelessWidget {
  const SearchProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchProductsBody(),
    );
  }
}

class _SearchProductsBody extends StatefulWidget {
  const _SearchProductsBody();

  @override
  State<_SearchProductsBody> createState() => _SearchProductsBodyState();
}

class _SearchProductsBodyState extends State<_SearchProductsBody> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        appBar: AppBar(
          backgroundColor: const Color(0xffFAFAFA),
          surfaceTintColor: const Color(0xffFAFAFA),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'البحث',
            style: TextStyle(
              color: Color(0xff202020),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            tooltip: 'رجوع',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xff202020),
              size: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: _SearchField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  setState(() {});

                  context.read<SearchCubit>().search(value);
                },
                onClear: () {
                  _controller.clear();

                  context.read<SearchCubit>().clearSearch();

                  setState(() {});

                  _focusNode.requestFocus();
                },
              ),
            ),
            const Expanded(child: _SearchResults()),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      onChanged: onChanged,
      onSubmitted: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: const TextStyle(
        color: Color(0xff202020),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'ابحث عن وجبتك...',
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(
          color: Color(0xffAAAAAA),
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xff777777),
          size: 22,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'مسح البحث',
                onPressed: onClear,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xff777777),
                  size: 20,
                ),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: const Color(0xffB60F1A), width: 1.3),
      ),
    );
  }

  OutlineInputBorder _border({
    Color color = const Color(0xffEDEDED),
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const _SearchMessage(
            icon: Icons.search_rounded,
            title: 'ابحث عن وجبتك',
            subtitle: 'اكتب اسم الوجبة التي تبحث عنها',
          );
        }

        if (state is SearchWaiting) {
          return const _SearchMessage(
            icon: Icons.keyboard_alt_outlined,
            title: 'كمّل كتابة اسم الوجبة',
            subtitle: 'سنبدأ البحث تلقائيًا بعد لحظة',
          );
        }

        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Color(0xffB60F1A),
            ),
          );
        }

        if (state is SearchEmpty) {
          return _SearchMessage(
            icon: Icons.search_off_rounded,
            title: 'لم نجد نتائج',
            subtitle: 'لا توجد وجبات مطابقة لـ "${state.query}"',
          );
        }

        if (state is SearchFailure) {
          return _SearchMessage(
            icon: Icons.error_outline_rounded,
            title: 'تعذر البحث',
            subtitle: state.message,
          );
        }

        if (state is SearchLoaded) {
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
            itemCount: state.products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 11),
            itemBuilder: (context, index) {
              return _ProductSearchCard(product: state.products[index]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ProductSearchCard extends StatelessWidget {
  static const _primaryColor = Color(0xffB60F1A);

  final ProductEntity product;

  const _ProductSearchCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsView(product: product),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              AppNetworkImage(
                imageUrl: product.image,
                fallbackAsset: LocalImageMapper.product(product.id),
                width: 94,
                height: 94,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xff202020),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xff888888),
                        fontSize: 11.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            color: _primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        if (product.rating > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xffF4B400),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xff666666),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: Color(0xffBBBBBB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SearchMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xffFCEEEF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: const Color(0xffB60F1A)),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff202020),
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff888888),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
