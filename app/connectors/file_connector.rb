class FileConnector
  class << self
    def read(path)
      commentout_filter file_read_raw(path)
    end

    private

    def file_read_raw(_path)
      path = if _path.start_with?('./')
               _path
             else
               File.join(ProofSystem.file_base, _path)
             end
      (File.read path).chomp
    end

    def commentout_filter(data)
      (data.split("\n")
       .map { |row| row.sub(/#.*$/, '')})
       .reject(&:empty?)
       .join("\n")
    end
  end
end
