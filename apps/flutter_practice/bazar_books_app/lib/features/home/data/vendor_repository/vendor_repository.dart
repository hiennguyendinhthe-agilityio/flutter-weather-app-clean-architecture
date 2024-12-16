import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';

abstract class VendorRepository {
  InfiniteQuery<List<Vendor>, int> getVendors();

  Future<void> refreshVendors();

  Future<List<Vendor>> fetchVendors();

  Query<List<Vendor?>> getVendorsCached();
}

class VendorRepositoryImpl implements VendorRepository {
  VendorRepositoryImpl();
  final _service = ApiService(Dio());

  @override
  Query<List<Vendor>> getVendorsCached() {
    return Query<List<Vendor>>(
      key: 'getBestVendors',
      queryFn: () async {
        return await _service.getVendors();
      },
    );
  }

  @override
  InfiniteQuery<List<Vendor>, int> getVendors() {
    return InfiniteQuery<List<Vendor>, int>(
      revalidateAll: true,
      key: 'Vendors',
      getNextArg: (state) {
        if (state.lastPage?.isEmpty ?? false) return null;
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

    await getVendors().refetch();
  }

  @override
  Future<List<Vendor>> fetchVendors() async {
    try {
      // Call the appropriate method from ApiService to fetch vendors
      final vendors = await _service.getVendors();
      return vendors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }
}
