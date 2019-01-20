This patched java.nio.fileFiles just dummifies the isWritable method
so it returns true always.

Using docker + wine + java makes Files.isWritable return false
maybe because DOS attributes are not propagated to the
mounted volumes and it check those, and thinks it is readonly.

Without this patch. This is the exception thrown:

```
> Task :compileKotlinMingwX64
error: compilation failed: null

 * Source files: expect.kt, hello.kt, actual.kt
 * Compiler version info: Konan: 1.1-rc2-5686 / Kotlin: 1.3.20
 * Output kind: LIBRARY

exception: java.nio.file.ReadOnlyFileSystemException
        at com.sun.nio.zipfs.ZipFileSystem.checkWritable(ZipFileSystem.java:155)
        at com.sun.nio.zipfs.ZipFileSystem.deleteFile(ZipFileSystem.java:1335)
        at com.sun.nio.zipfs.ZipPath.delete(ZipPath.java:655)
        at com.sun.nio.zipfs.ZipFileSystemProvider.delete(ZipFileSystemProvider.java:206)
        at java.nio.file.spi.FileSystemProvider.deleteIfExists(FileSystemProvider.java:739)
        at java.nio.file.Files.deleteIfExists(Files.java:1165)
        at java.nio.file.CopyMoveHelper.copyToForeignTarget(CopyMoveHelper.java:117)
        at java.nio.file.Files.copy(Files.java:1277)
        at org.jetbrains.kotlin.konan.file.FileKt$recursiveCopyTo$1.invoke(File.kt:197)
        at org.jetbrains.kotlin.konan.file.FileKt$recursiveCopyTo$1.accept(File.kt)
...
```
