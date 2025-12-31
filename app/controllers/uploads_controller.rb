class UploadsController < ApplicationController
  def new
    @files = []
    upload_path = Rails.root.join('public', 'uploads')

    if Dir.exist?(upload_path)
      # Get all files, excluding "." and ".."
      @files = Dir.children(upload_path)
    end
  end

  def create
    uploaded_file = params[:my_file]

    if uploaded_file.respond_to?(:original_filename)
      # 1. Sanitize the filename
      clean_name = sanitize_filename(uploaded_file.original_filename)

      # 2. Define path using Rails.root for absolute safety
      directory = Rails.root.join('public', 'uploads')
      filepath = directory.join(clean_name)

      # 3. Ensure the directory exists
      FileUtils.mkdir_p(directory)

      # 4. Write binary data
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_file.read)
      end

      redirect_to new_upload_path, notice: "Saved as: #{clean_name}"
    else
      redirect_to new_upload_path, alert: "No file selected."
    end
  end

  def destroy
    # 1. Sanitize the input to prevent directory traversal
    filename = File.basename(params[:filename])
    filepath = Rails.root.join('public', 'uploads', filename)

    # 2. Check if file exists and delete it
    if File.exist?(filepath)
      File.delete(filepath)
      redirect_to new_upload_path, notice: "File '#{filename}' was successfully deleted."
    else
      redirect_to new_upload_path, alert: "File not found."
    end
  end

  private

  def sanitize_filename(filename)
    # Remove directory info and keep only the base name
    extension = File.extname(filename).downcase
    basename = File.basename(filename, extension).gsub(/[^0-9A-Z_]/i, '_')

    # Return the "clean" version: alphanumeric name + lowercase extension
    "#{basename}#{extension}"
  end
end
