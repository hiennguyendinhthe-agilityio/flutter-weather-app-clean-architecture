import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';

abstract class VendorRepository {
  InfiniteQuery<List<Vendor>, int> fetchInfiniteVendors();

  Future<void> refreshVendors();

  Query<List<Vendor?>> getVendorsCached();
}

class VendorRepositoryImpl implements VendorRepository {
  VendorRepositoryImpl(this._service);
  final ApiService _service;

  @override
  Query<List<Vendor>> getVendorsCached() {
    return Query<List<Vendor>>(
      config: QueryConfig(
        cacheDuration: const Duration(minutes: 5),
        refetchDuration: const Duration(minutes: 5),
      ),
      key: 'getBestVendors',
      queryFn: () async {
        return await _service.getVendors();
      },
    );
  }

  @override
  InfiniteQuery<List<Vendor>, int> fetchInfiniteVendors() {
    return InfiniteQuery<List<Vendor>, int>(
      config: QueryConfig(
        cacheDuration: const Duration(seconds: 5),
        refetchDuration: const Duration(seconds: 5),
      ),
      revalidateAll: true,
      key: 'Vendors',
      getNextArg: (state) {
        if (state.lastPage == null) return 1;
        if (state.lastPage!.isEmpty) return null;

        return state.length + 1;
      },
      queryFn: (page) async => Vendor.listFromJson(
        await _service.getMoreVendors(page: page, limit: 10),
      ),
    );
  }

  @override
  Future<void> refreshVendors() async {
    CachedQuery.instance.invalidateCache(key: 'Vendors');

    await fetchInfiniteVendors().refetch();
  }
}
