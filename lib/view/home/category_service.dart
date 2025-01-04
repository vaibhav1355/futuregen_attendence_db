
import '../../models/contract_transaction_repository.dart';

class CategoryService {
  static const Map<String, int> categoryWithIds = {
    'Admin-General': 1,
    'Academic-General': 2,
    'Fundraising-General': 3,
    'Marketing-General': 4,
    'Operations-General': 5,
    'Finance-General': 6,
    'HR-General': 7,
    'Research-General': 8,
    'Event Management-General': 9,
    'Customer Service-General': 10,
  };

  static Future<List<Map<String, dynamic>>> fetchCategoryDetails(String selectedDate) async {
    final repository = ContractTransactionRepository();
    final fetchedData = await repository.fetchCategoryDetailsByDate(selectedDate);

    return fetchedData.map((item) {
      final categoryName = categoryWithIds.keys.firstWhere(
            (key) => categoryWithIds[key] == item['categoryId'],
        orElse: () => 'Unknown Category',
      );

      return {
        'category': categoryName,
        'hours': item['hours'],
        'journal': item['journal'],
        'isLock': item['isLock'],
      };
    }).toList();
  }
}
