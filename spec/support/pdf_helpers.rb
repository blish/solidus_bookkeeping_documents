module PdfHelpers
  def embedded_files(pdf)
    objects = PDF::Reader.new(StringIO.new(pdf)).objects
    names = objects.deref(objects.deref(objects.trailer[:Root])[:Names])
    return {} unless names

    name_tree_entries(objects, names[:EmbeddedFiles]).to_h do |name, file_spec|
      stream = objects.deref(objects.deref(objects.deref(file_spec)[:EF])[:F])
      [name.to_s, stream.unfiltered_data]
    end
  end

  def xmp_metadata(pdf)
    PDF::Reader.new(StringIO.new(pdf)).metadata
  end

  private

  def name_tree_entries(objects, node)
    node = objects.deref(node)
    entries = Array(objects.deref(node[:Names])).each_slice(2).to_a
    Array(objects.deref(node[:Kids])).each { |kid| entries += name_tree_entries(objects, kid) }
    entries
  end
end

RSpec.configure do |config|
  config.include PdfHelpers
end
