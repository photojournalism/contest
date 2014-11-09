require 'zip'

class ExportController < ApplicationController

  before_action :require_admin

  def index
    @contests = Contest.all.sort_by { |c| c.year }
  end

  # This endpoint will export the winners of the contest into
  # the format to be used on the seminar's main website.
  #
  # Yes, this is the worst, most un-maintainable mess ever.
  def winners
    contest = if params[:year] then Contest.where(:year => params[:year]).first else Contest.current end

    if contest
      current_timestamp = Time.now.to_i
      base_path = "/tmp/contest-#{contest.year}-export"
      FileUtils.rm_rf(base_path)
      FileUtils.mkdir_p(base_path)
      
      output = {
        :year => contest.year,
        :info => "Below is a list of the winners from the Atlanta Photojournalism Seminar's #{contest.year} photo contest. Thank you to everyone who entered and participated in the contest, and congratulations to the winners!",
        :categories => []
      }
      main_slideshow_yaml = []
      contest.categories.each do |category|
        # Make the base category directory        
        slug = category.name.downcase.gsub(' ', '-').gsub('/', '-')
        winners = []        

        # Reset yaml and erb
        yaml_data = []
        erb = ""
        source_directory = "#{base_path}/contest/winners/#{contest.year}/#{slug}"
        FileUtils.mkdir_p(source_directory)
        Entry.where(:contest => contest, :category => category).sort_by { |e| if e.place then e.place.sequence_number.to_i else 99 end }.each do |entry|          
          ident = entry.unique_hash[0..5]
          image_directory = "#{base_path}/images/#{contest.year}/contest-winners/#{slug}"

          # If the entry placed
          if (entry.place && entry.place.sequence_number != 99)
            winner = "#{entry.user}"
            winner << " / #{entry.user.employer}" if !entry.user.employer.blank?
            winners << { :info => "#{entry.place.name} – #{winner}" }
            place = entry.place.name.downcase.gsub(' ', '-')

            # Copy images for single image category
            if category.category_type.maximum_files == 1
              image = entry.images.first
              filename = "#{contest.year}-#{slug}-#{place}-#{ident}.jpg"
              FileUtils.mkdir_p(image_directory)
              FileUtils.cp("/home/casey/Programming/Rails/contest/public#{image.public_url}", "#{image_directory}/#{filename}")
              yaml_data << { :title => "#{entry.place.name} Winner - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }

              if entry.place.sequence_number == 1
                main_slideshow_yaml << { :title => "#{entry.place.name} Winner - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }
              end

            # Copies images for multi-image category
            elsif category.category_type.maximum_files > 1
              image_directory = "#{image_directory}/#{place}-#{ident}"
              FileUtils.mkdir_p(image_directory)
              entry.images.sort_by { |i| i.number }.each do |image|
                filename = "#{contest.year}-#{slug}-#{place}-#{image.number}-#{ident}.jpg"
                FileUtils.cp("/home/casey/Programming/Rails/contest/public#{image.public_url}", "#{image_directory}/#{filename}")
                yaml_data << { :title => "#{entry.place.name} Winner - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }
              end
              File.open("#{source_directory}/slideshow-#{place}-#{ident}.yml", 'w') { |f| f.write yaml_data.to_yaml }
              yaml_data = []

              erb << "\n\n<h3>#{entry.place.name}: #{winner}</h3>"
              erb << "\n\n<%= partial 'layouts/slideshow', locals: { id: 'carousel-#{ident}', yaml_data: 'source/contest/winners/#{contest.year}/#{slug}/slideshow-#{place}-#{ident}.yml' } %>"
            end
          end
        end
        output[:categories] << { :name => category.name, :url => "#{slug}/", :winners => winners }

        erb_header = <<-eos
---
title: #{contest.year} #{category}
navigation: Contest
comments: on
---

<h1>#{contest.year} #{category}</h1>

<%= partial 'layouts/return_to_winners' %>
        eos

        # Write YAML and ERB for single image categories
        if category.category_type.maximum_files == 1
          File.open("#{source_directory}/slideshow.yml", 'w') { |f| f.write yaml_data.to_yaml }
          yaml_data = []
          File.open("#{source_directory}/index.html.erb", 'w') do |f|
            f.write <<-eos
#{erb_header}
<%= partial 'layouts/slideshow', locals: { id: 'carousel', yaml_data: 'source/contest/winners/#{contest.year}/#{slug}/slideshow.yml', keybindings: true } %>
            eos
          end
        end

        # Write the ERB file for the multiple image categories
        if category.category_type.maximum_files > 1
          File.open("#{source_directory}/index.html.erb", 'w') { |f| f.write "#{erb_header}\n#{erb}" }
        end
      end

      # Write base winners YAML file
      File.open("#{base_path}/contest/winners/#{contest.year}/winners.yml", 'w') { |f| f.write output.to_yaml }

      # Write main slideshow file for contest
      File.open("#{base_path}/contest/winners/#{contest.year}/slideshow.yml", 'w') { |f| f.write main_slideshow_yaml.to_yaml }

      # Write base index page for contest
      File.open("#{base_path}/contest/winners/#{contest.year}/index.html.erb", 'w') do |f|

        f.write <<-eos
---
title: #{contest.year} Winners
navigation: Contest
comments: on
---

<%= partial 'layouts/contest_winners', locals: { year: #{contest.year}, slideshow: true } %>
        eos
      end

      export(contest.year)
    else
      render :plain => "There is no contest for the year #{params[:year]}"
    end
  end

  private

  def export(year)
    zip_exported_directory(year)
    download_exported_zip(year)

    FileUtils.rm("/tmp/contest-#{year}-export.zip")
    FileUtils.rm_rf("/tmp/contest-#{year}-export")
  end

  def zip_exported_directory(year)
    directory = "/tmp/contest-#{year}-export"
    zipfile_name = "#{directory}.zip"
    options = { "directories-recursively" => true }

    FileUtils.rm(zipfile_name) if File.exists?(zipfile_name)

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      puts "zipper: archiving directory: #{directory}"
      directory_chosen_pathname = options["directories-recursively-splat"] ? directory : File.dirname(directory)  
      directory_pathname = Pathname.new(directory_chosen_pathname)
      Dir[File.join(directory, '**', '**')].each do |file|                
        file_pathname = Pathname.new(file)
        file_relative_pathname = file_pathname.relative_path_from(directory_pathname)
        zipfile.add(file_relative_pathname,file)
      end
    end
  end

  def download_exported_zip(year)
    zip_data = File.read("/tmp/contest-#{year}-export.zip") 
    send_data(zip_data, :type => 'application/zip', :filename => "contest-#{year}-export.zip")
  end
end
