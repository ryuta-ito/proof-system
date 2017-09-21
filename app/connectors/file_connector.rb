class FileConnector
  class << self
    def read(path)
      file_read_raw(path)
    end

    private

    def file_read_raw(_path)
      path = if _path.start_with?('./')
               _path
             else
               File.join(NdProving.file_base, _path)
             end
      (File.read path).chomp
    end
  end
end
