require 'csv'
require 'nokogiri'
require 'open-uri'
require 'byebug'

def main
  start_page = latest_page - read_page_num

  date_list = []
  profit_list = []

  puts '出力開始'

  for num in start_page...latest_page do
    begin
      res = URI.open(url(num)).read
      doc = Nokogiri::HTML.parse(res)
      title = doc.title
      date_list << title.slice(/[0-9]+\/[0-9]+/)
      profit_list << doc.at_css('#more').text.split(/\r\n/)[1].strip.split(/ |円/).last
    rescue
    end
  end

  output_csv(date_list, profit_list)
  puts '出力終了'
end

def output_csv(date_list, profit_list)
  prefix = Time.now.to_s.gsub(' ', '')

  CSV.open("output/#{prefix}.csv", 'w') do |csv|
    csv << header

    date_list.each_with_index do |date, i|
      csv << [date, profit_list[i]]
    end

    csv << ['合計利益', delimited(profit_list.map { |p| p.gsub(',', '') }.map(&:to_i).sum)]
  end
end

def header
  ['日付', '本日の利益']
end

def url(page)
  "https://kabuol.com/blog-entry-#{page}.html"
end

def latest_page
  3691
end

def read_page_num
  100
end

def delimited(num)
  num.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')
end

main
