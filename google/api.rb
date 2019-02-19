require "google/cloud/vision"
 
# Your Google Cloud Platform project ID
vision = Google::Cloud::Vision.new(
  project: "vote-201701",
  keyfile: "./google/key.json"
 )
 
image  = vision.image "./public/img/card.png"
puts image.text