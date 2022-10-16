module Music
  class Scale
    NOTES = %w(c c# d d# e f f# g a a# b)

    def play
      NOTES.to_enum
    end
  end
end

scale = Music::Scale.new
scale.play.map {|note| puts "Next note: #{note}" }
scale.play.with_each(1) {|note,i| puts "Note #{i}: #{note}" }


1100001 
0100011

1000010
0100011
1100001