class NamesController < ApplicationController
  require 'iconv'
	require 'csv'
	require 'json'

	def index

	end

  def search
  	name = params[:name]
  	big5 = Iconv.conv("Big5", "utf-8", name).bytes.to_a
  	num = big5.length / 2
  	big5_done = Array.new

  	for i in 0...num
			first = big5[i * 2].to_s(16).upcase
			second = big5[i * 2 + 1].to_s(16).upcase
			big5_done.push(first + second)
		end

		dictionary = JSON.parse(File.read("#{Rails.root}/public/dictionary.json"))
		stroke = JSON.parse(File.read("#{Rails.root}/public/strokes.json"))
		cns = Array.new
		for i in 0...big5_done.length
			cns.push(dictionary[big5_done[i]]["page"] + "-" + dictionary[big5_done[i]]["cns"])
		end

		puts cns

		for single_cns in cns
			puts stroke[single_cns]
		end

		@characters = Array.new
		@sum = 0
		for i in 0...num
			character = Hash.new
			chinese = name[i]
			strokes = stroke[cns[i]]
			character['chinese'] = chinese
			character['strokes'] = strokes
			@characters.push(character)
			@sum += strokes
		end
		puts @characters


  end
end
