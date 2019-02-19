require "google/cloud/vision"

@vision = Google::Cloud::Vision.new(
    project: "vote-201701",
    keyfile: "./google/key.json"
)
    
@image_analyst = @vision.image "./public/img/std_card2.png"

@image_analyst.document.words.each do |x|
    if x.to_s.size == 9
        puts x
    end
end