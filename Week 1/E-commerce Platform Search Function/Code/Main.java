import java.util.Arrays;
import java.util.Comparator;

class Product {
    int productId;
    String productName;
    String category;
    public Product(int productId, String productName, String category) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }
    @Override
    public String toString() {
        return "[" + productId + ", " + productName + ", " + category + "]";
    }
}
public class Main {
    public static Product linearSearch(Product[] products, String targetName) {
        for (Product product : products) {
            if (product.productName.equalsIgnoreCase(targetName)) {
                return product;
            }
        }
        return null;
    }
    public static Product binarySearch(Product[] products, String targetName) {
        Arrays.sort(products, Comparator.comparing(p -> p.productName.toLowerCase()));

        int left = 0, right = products.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            int cmp = targetName.compareToIgnoreCase(products[mid].productName);

            if (cmp == 0) return products[mid];
            else if (cmp < 0) right = mid - 1;
            else left = mid + 1;
        }
        return null;
    }

    public static void main(String[] args) {
        Product[] products = {
            new Product(101, "Laptop", "Electronics"),
            new Product(102, "Shirt", "Clothing"),
            new Product(103, "Phone", "Electronics"),
            new Product(104, "Book", "Education"),
            new Product(105, "Shoes", "Footwear")
        };

        String searchTerm = "Phone";
        Product foundLinear = linearSearch(products, searchTerm);
        System.out.println("Linear Search Result: " + (foundLinear != null ? foundLinear : "Product not found"));
        Product foundBinary = binarySearch(products, searchTerm);
        System.out.println("Binary Search Result: " + (foundBinary != null ? foundBinary : "Product not found"));
    }
}
