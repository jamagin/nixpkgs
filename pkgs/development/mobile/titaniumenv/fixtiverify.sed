s|apk_zip.write(os.path.join(lib_source_dir, 'libtiverify.so'), lib_dest_dir + 'libtiverify.so')|info = zipfile.ZipInfo(lib_dest_dir + 'libtiverify.so')\n\t\t\tinfo.compress_type = zipfile.ZIP_DEFLATED\n\t\t\tinfo.create_system = 3\n\t\t\tf = open(os.path.join(lib_source_dir, 'libtiverify.so'))\n\t\t\tapk_zip.writestr(info, f.read())\n\t\t\tf.close()|
