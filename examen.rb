require "uri"
require "net/http"
require "json"

def request (url, token=nil)
    url = URI("#{url}api_key=#{token}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    return JSON.parse response.read_body
end

def web_page_nasa(info_hash)
    File.open('apped_index.html', 'w') do |file|
        file.puts"<!doctype html>"
        file.puts "<html lang='es'>"
        file.puts "<head>"
        file.puts"<title> Exam</title>"
        file.puts"<meta charset='utf-8'>"
        file.puts"<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>"
        file.puts"<link rel='stylesheet' href='assets/css/style.css'>"
        file.puts"<!-- Bootstrap CSS -->"
        file.puts"<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css'
            integrity='sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2' crossorigin='anonymous'>"
        file.puts "</head>"
        file.puts "<body>"
        file.puts "<div class='container'>"
        file.puts"<h1 class='text-info'>Mars Rover Photos</h1>"
        file.puts"<div class='row'>"
        file.puts"<ul class='list-group'>"
        info_hash.each do |photo|
            file.puts "<li list-group-item d-flex justify-content-between align-items-center><img src='#{photo["img_src"]}'class='img-fluid mt-5'></li>"
        end
        file.puts "<head>"
        file.puts "</ul>"
        file.puts "</body>"
        file.puts "</html>"
    end
end

def photos_count(info_hash)
    hash_answer={}
    info_hash.each do |photo|
        camera=photo["camera"]
        name_camera=camera["name"]
        if (hash_answer[:"#{name_camera}"])
            hash_answer[:"#{name_camera}"]+=1
            hash_answer[:"#{name_camera}"]=1
        end
    end
    return hash_answer
end

body=request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&","1ww0S1lt1baa5sfWYqvZlxstrubhgRWDskEFp0Hs")
photos=body["photos"]
puts web_page_nasa(photos)
camara_photos=photos_count(photos)
puts camara_photos