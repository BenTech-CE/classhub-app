extension StringFilename on String {
  bool isImage() {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.tiff', '.svg'];
    final lower = toLowerCase();

    return imageExtensions.any((ext) => lower.endsWith(ext));
  }

  String shortenFilename({int visibleStart = 8, int visibleEnd = 3}) {
    final dotIndex = lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == 0) return this; // Sem extensão válida

    final name = substring(0, dotIndex);
    final extension = substring(dotIndex); // Inclui o ponto

    if (name.length <= visibleStart + visibleEnd + 3) return this; // Não precisa encurtar

    final start = name.substring(0, visibleStart);
    final end = name.substring(name.length - visibleEnd);

    return '$start...$end$extension';
  }
}