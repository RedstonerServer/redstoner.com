class MemoryController < ApplicationController

  before_filter :logged_in

  def index
    current_uuid = current_user.uuid.gsub("-", "")
    Dir.chdir("/etc/minecraft/redstoner/plugins/JavaUtils/memory/players/#{current_uuid}")
    psjson = JSON.parse(File.read("projects.json"))
    @projects = psjson["owns"] + psjson["read"] + psjson["write"]
    @project_names = @projects.collect{|p| (data = JSON.parse(File.read(File.expand_path("../..")+"/projects/#{p}/project.json")))["name"] + " | #{"own" if data["owner"] == current_uuid}#{"write" if data["write"].include? current_uuid}#{"read" if data["read"].include? current_uuid}"}

  end

  def list
    render :index
  end

  def table
    Dir.chdir("/etc/minecraft/redstoner/plugins/JavaUtils/memory/projects/#{params[:project]}")
    @data = []
    Dir.glob('*').reverse.each do |f|
      File.open(Dir.pwd+"/#{f}") do |file|
        @data.concat(file.read.unpack("C*").map{|h| h.to_s(16)})
        if JSON.parse((jf = File.open(Dir.pwd+"/project.json")).read)["read"].include? current_user.uuid.gsub("-","")
          @can_edit = false
        else
          @can_edit = true
        end
        jf.close
      end
    end
  end

  def update_memory
    Dir.chdir("/etc/minecraft/redstoner/plugins/JavaUtils/memory/projects/#{params[:project]}")
    new_text = ""
    File.open("#{params[:file]}.hex"){|f| new_text = f.read.unpack("C*").collect{|h| h.to_s(16)}}
    new_text[params[:mem_id].to_i] = params[:value]
    File.open("#{params[:file]}.hex", "w") do |f|
      f.write((new_text.collect{|h| h.to_s.to_i(16)}).pack("C*").force_encoding("UTF-8"))
    end
    render nothing: true
  end

  private

  def logged_in
    unless current_user
      flash[:alert] = "Please log in before viewing memory files."
      redirect_to home_statics_path
    end
  end
end
