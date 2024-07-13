import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/auth_repository.dart';
import 'package:docs_ai/repository/document_repository.dart';
import 'package:docs_ai/screens/document/widgets/document_card.dart';
import 'package:docs_ai/screens/place_holder_for_empty_document.dart';
import 'package:docs_ai/screens/verify_if_user_not_null.dart';
import 'package:docs_ai/widgets/custom_app_bar.dart';
import 'package:docs_ai/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Contains the visual aspect of the home screen
class Home extends ConsumerWidget {
  /// Creates a [Home] widget
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userProvider);

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: VerifyIfUserNotNull(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /// Mes documents
                FutureBuilder<ErrorModel>(
                  future: ref
                      .read(documentRepositoryProvider)
                      // ignore: discarded_futures
                      .meDocument(user!.token),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<ErrorModel> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return const Text('Error');
                    }

                    if (snapshot.data != null && snapshot.data!.error != null) {
                      return const PlaceHolderForEmptyDocument();
                    }
                    final List<DocumentModel> documents =
                        snapshot.data!.data as List<DocumentModel>;

                    return LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth > 480) {
                          return SizedBox(
                            width: 208 * 3,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: documents.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return DocumentCard(
                                  document: documents[index],
                                );
                              },
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    child: DocumentCard(
                                      document: documents[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Gap(20),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
