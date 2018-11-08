require 'zip'

class ExportController < ApplicationController

  before_action :require_admin

  def index
    @contests = Contest.all.sort_by { |c| c.year }
  end

  def tsv
    contest = if params[:year] then Contest.where(:year => params[:year]).first else Contest.current end
    output = "Unique Hash\tCategory\tPlace\tEmail\tName\tShipping Name\tStreet\tCity\tState\tZip\tCountry\tDay Phone\tEvening Phone\tEmployer\tSchool\n"

    contest.categories.order(:category_type_id => :asc, :id => :asc).each do |category|
      entries = Entry.where(:contest => contest, :category => category)
        .select { |entry| entry.place && entry.place.sequence_number.to_i != 99 }
        .sort_by { |entry| entry.place.sequence_number }

      entries.each do |entry|
        if !entry.place || entry.place.sequence_number.to_i == 99
          next
        end

        user = entry.user
        parent_user = entry.user.user ? entry.user.user : nil

        email = ''
        street = ''
        city = ''
        state = ''
        zip = ''
        country = ''
        day_phone = ''
        evening_phone = ''
        employer = ''
        school = ''

        if parent_user
          email = parent_user.email ? parent_user.email : ''
          street = parent_user.street ? parent_user.street : ''
          city = parent_user.city ? parent_user.city : ''
          state = parent_user.state ? parent_user.state.name : ''
          zip = parent_user.zip ? parent_user.zip : ''
          country = parent_user.country ? parent_user.country.name : ''
          day_phone = parent_user.day_phone ? parent_user.day_phone : ''
          evening_phone = parent_user.evening_phone ? parent_user.evening_phone : ''
          employer = user.employer ? user.employer : ''
        else
          email = user.email ? user.email : ''
          street = user.street ? user.street : ''
          city = user.city ? user.city : ''
          state = user.state ? user.state.name : ''
          zip = user.zip ? user.zip : ''
          country = user.country ? user.country.name : ''
          day_phone = user.day_phone ? user.day_phone : ''
          evening_phone = user.evening_phone ? user.evening_phone : ''
          employer = user.employer ? user.employer : ''
          school = user.school ? user.school : ''
        end
        output += entry.unique_hash
        output += "\t"
        output += entry.category.name
        output += "\t"
        output += entry.place.name
        output += "\t"
        output += email
        output += "\t"
        output += user.name
        output += "\t"
        output += parent_user ? parent_user.name : user.name
        output += "\t"
        output += street
        output += "\t"
        output += city
        output += "\t"
        output += state
        output += "\t"
        output += zip
        output += "\t"
        output += country
        output += "\t"
        output += day_phone
        output += "\t"
        output += evening_phone
        output += "\t"
        output += employer
        output += "\t"
        output += school
        output += "\n"
      end
    end

    send_data(output, :type => 'text/tsv', :filename => "aps_#{contest.year}_certificates.txt")
  end

  # This endpoint will export the winners of the contest into
  # the format to be used on the seminar's main website.
  #
  # Yes, this is the worst, most un-maintainable mess ever.
  def website
    contest = if params[:year] then Contest.where(:year => params[:year]).first else Contest.current end

    if !contest
      render :plain => "There is no contest for the year #{params[:year]}"
      return
    end

    base_path = "/tmp/contest-#{contest.year}-export"
    FileUtils.rm_rf(base_path)
    FileUtils.mkdir_p(base_path)
    
    winners_yaml = {
      :year => contest.year,
      :info => "Below is a list of the winners from the Atlanta Photojournalism Seminar's #{contest.year} photo contest. Thank you to everyone who entered and participated in the contest, and congratulations to the winners!",
      :categories => []
    }
    main_slideshow_yaml = []
    contest.categories.order(:category_type_id => :asc, :id => :asc).each do |category|
      # Make the base category directory        
      slug = category.name.downcase.gsub(' ', '-').gsub('/', '-')
      winners = []        

      # Reset yaml and erb
      yaml_data = []
      erb = ""
      source_directory = "#{base_path}/contest/winners/#{contest.year}/#{slug}"
      FileUtils.mkdir_p(source_directory)
      Entry.where(:contest => contest, :category => category)
           .sort_by { |e| if e.place then e.place.sequence_number.to_i else 99 end }
           .each do |entry|
        if !entry.place || entry.place.sequence_number == 99
          next
        end

        ident = entry.unique_hash[0..5]
        image_directory = "#{base_path}/images/#{contest.year}/contest-winners/#{slug}"
        winner = "#{entry.user}"
        winner << " / #{entry.user.affiliation}" if entry.user.affiliation

        # If this is a "URL" category, like a video category,
        # we'll add a link to the winner's video.
        if category.category_type.has_url
          winners << { :info => "<a href='#{entry.url}' target='_blank'>#{entry.place.name} – #{winner}</a>" }
        else
          winners << { :info => "#{entry.place.name} – #{winner}" }
        end
        
        place = entry.place.name.downcase.gsub(' ', '-')

        # Copy images for single image category
        if category.category_type.maximum_files == 1
          image = entry.images.first
          filename = "#{contest.year}-#{slug}-#{place}-#{ident}.jpg"
          FileUtils.mkdir_p(image_directory)
          FileUtils.cp("#{Dir.home}/contest.photojournalism.org/shared/public#{image.public_url}", "#{image_directory}/#{filename}")
          yaml_data << { :title => "#{entry.place.name} - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }

          if entry.place.sequence_number == 1
            main_slideshow_yaml << { :title => "#{entry.place.name} - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }
          end

        # Copies images for multi-image category
        elsif category.category_type.maximum_files > 1
          image_directory = "#{image_directory}/#{place}-#{ident}"
          FileUtils.mkdir_p(image_directory)
          entry.images.sort_by { |i| i.number }.each do |image|
            filename = "#{contest.year}-#{slug}-#{place}-#{image.number}-#{ident}.jpg"
            begin
              FileUtils.cp("#{Dir.home}/contest.photojournalism.org/shared/public#{image.public_url}", "#{image_directory}/#{filename}")
              yaml_data << { :title => "#{entry.place.name} - #{contest.year} #{category.name}", :credit => "#{winner}", :caption => "#{image.caption}", :url => "#{image_directory.gsub(/#{base_path}/, '')}/#{filename}" }
            rescue
              puts "Could not find file #{filename}"
            end
          end
          File.open("#{source_directory}/slideshow-#{place}-#{ident}.yml", 'w') { |f| f.write yaml_data.to_yaml }
          yaml_data = []

          erb << "\n\n<h3>#{entry.place.name}: #{winner}</h3>"
          erb << "\n\n<%= partial 'layouts/slideshow', locals: { id: 'carousel-#{ident}', yaml_data: 'source/contest/winners/#{contest.year}/#{slug}/slideshow-#{place}-#{ident}.yml' } %>"
        end
      end
      winners_yaml[:categories] << { :name => category.name, :url => "#{slug}/", :winners => winners }

      erb_header = <<-eos
---
title: #{contest.year} #{category}
navigation: Contest
comments: on
---

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
        File.open("#{source_directory}/index.html.erb", 'w') { |f| f.write "#{erb_header}#{erb}" }
      end
    end

    # Write base winners YAML file
    File.open("#{base_path}/contest/winners/#{contest.year}/winners.yml", 'w') { |f| f.write winners_yaml.to_yaml }

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
  end

  def images
    contest = Contest.current
    failed_images = "The following images failed:"
    base_dir = "/tmp/contest-#{contest.year}-images"
    FileUtils.mkdir_p(base_dir)
    Category.all.each do |c|
      slug = c.name.downcase.gsub(' ', '-').gsub('/', '-')
      FileUtils.mkdir_p("#{base_dir}/#{slug}")
    end
    Entry.all.each do |e|
      if !e.place && e.category_type.maximum_files > 0
        slug = e.category.name.downcase.gsub(' ', '-').gsub('/', '-')
        if e.category_type.maximum_files == 1
          begin
            FileUtils.cp(e.images.first.path, "#{base_dir}/#{slug}/#{e.images.first.filename}") if e.images.first
          rescue
            failed_images << "\ni.id"
            puts "Could not find image: #{e.images.first.id}"
          end
        else
          FileUtils.mkdir_p("#{base_dir}/#{slug}/#{e.unique_hash[0..6]}")
          e.images.each do |i|
            begin
              FileUtils.cp(i.path, "#{base_dir}/#{slug}/#{e.unique_hash[0..6]}/#{i.filename}")
            rescue
              puts "Could not find image: #{i.id}"
              failed_images << "\ni.id"
            end
          end
        end
      end
    end
    render :plain => failed_images
  end

  private

  def export(year)
    exported_directory = "/tmp/contest-#{year}-export"
    zip_exported_directory(exported_directory)
    download_exported_zip("#{exported_directory}.zip")

    FileUtils.rm("#{exported_directory}.zip")
    FileUtils.rm_rf(exported_directory)
  end

  def zip_exported_directory(directory)
    zipfile_name = "#{directory}.zip"
    options = { "directories-recursively" => true }

    FileUtils.rm(zipfile_name) if File.exists?(zipfile_name)

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      directory_pathname = Pathname.new(File.dirname(directory))
      Dir[File.join(directory, '**', '**')].each do |file|                
        file_relative_pathname = Pathname.new(file).relative_path_from(directory_pathname)
        zipfile.add(file_relative_pathname,file)
      end
    end
  end

  def download_exported_zip(filename)
    zip_data = File.read(filename) 
    send_data(zip_data, :type => 'application/zip', :filename => filename.split("/")[-1])
  end
end
