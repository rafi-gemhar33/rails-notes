puts(File.open("/Users/rafi/Desktop/rails-notes/ruby/10_collections_central_enumerable_and_enumerator/report.dat").slice_before do |line|
  line.start_with?("=")
end.to_a)
