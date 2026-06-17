import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardWidget extends StatelessWidget {
  const ShimmerCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah aplikasi sedang menggunakan Dark Mode atau Light Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Sesuaikan warna shimmer agar cocok dengan tema
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[600]! : Colors.grey[100]!;
    // Warna elemen dasar (harus warna solid agar bisa di-shimmer)
    final widgetColor = isDark ? Colors.grey[700]! : Colors.white;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- THUMBNAIL SKELETON ---
            Container(
              width: double.infinity,
              height: 200,
              color: widgetColor, 
            ),
            
            // --- DETAIL SKELETON ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Skeleton (Lingkaran)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widgetColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Text Skeletons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris pertama (Judul yang panjang)
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: widgetColor,
                        ),
                        const SizedBox(height: 8),
                        // Baris kedua (Nama channel yang lebih pendek)
                        Container(
                          width: 150,
                          height: 14,
                          color: widgetColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}