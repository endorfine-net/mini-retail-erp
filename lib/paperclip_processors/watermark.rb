module Paperclip
  class Watermark < Processor

    class InstanceNotGiven < ArgumentError; end

    def initialize(file, options = {},attachment = nil)
      super
      geometry          = options[:geometry]      
      @file = file
      @current_format = File.extname(@file.path)
      @format = options[:format]      
      @basename = File.basename(@file.path, @current_format)
      @watermark = options[:watermark_path]
      @position         = options[:position].nil? ? "SouthEast" : options[:position]      
      @current_geometry = Geometry.from_file file
      @watermark_geometry = watermark_dimensions
      @crop = geometry[-1,1] == '#'
      @convert_options  = options[:convert_options]      
      @target_geometry  = Geometry.parse geometry
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @format           = options[:format]
      @overlay          = options[:overlay].nil? ? true : false
      
      
      #ActiveRecord::Base.logger.info("1BASENAME: #{@basename.to_s}")                              
      #ActiveRecord::Base.logger.info("Watermart: #{@watermark.to_s}")                                    
    end

    # Returns true if the +target_geometry+ is meant to crop.
     def crop?
       @crop
     end

     # Returns true if the image is meant to make use of additional convert options.
     def convert_options?
       not @convert_options.blank?
     end

    def watermark_dimensions
      return @watermark_dimensions if @watermark_dimensions
      @watermark_dimensions = Geometry.from_file @watermark
    end

    def make
      #ActiveRecord::Base.logger.info("BASENAME: #{@basename.to_s}")                        
      #ActiveRecord::Base.logger.info("FORMAT: #{@format.to_s}")                              
      dst = Tempfile.new([@basename, @format].compact.join("."))
#      watermark = " \\( #{@watermark} -extract
#      #{@current_geometry.width.to_i}x#{@current_geometry.height.to_i}
#      +#{@watermark_geometry.height.to_i /
#      2}+#{@watermark_geometry.width.to_i / 2} \\) "
      command = "-gravity center " + @watermark + " " +
      "#{File.expand_path(@file.path)}" + " " + "#{transformation_command}" + " " + "#{File.expand_path(dst.path)}"

      begin
        ActiveRecord::Base.logger.info("Command Sent: #{command}")                        
        success = Paperclip.run("composite", command.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the
        watermark for #{@basename}" if @whiny_thumbnails
      end
      dst
    end
    def transformation_command
       scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
       trans = "-resize \"#{scale}\""
       trans << " -crop \"#{crop}\" +repage" if crop
       trans << " #{convert_options}" if convert_options?
       trans
     end

  end
end