public interface Dao {
	Map<ID, OCIProduct> fetchAllToMap(ID buyerID);
	OCIProduct fetchProductByID(ID productID, ID buyerID);
	Map<ID, OCIProduct> searchProductsByKeyword(String keyword, String categoryID, ID buyerID); // passing 'all' for all categories
}