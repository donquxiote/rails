class ActiveRecord::Tasks::SQLiteDatabaseTasks
  delegate :connection, :establish_connection, :to => ActiveRecord::Base

  def initialize(configuration)
    @configuration = configuration
  end

  def create
    if File.exist? configuration['database']
      $stderr.puts "#{configuration['database']} already exists"
      return
    end

    establish_connection configuration
    connection
  end

  def drop
    require 'pathname'
    path = Pathname.new configuration['database']
    file = path.absolute? ? path.to_s : File.join(Rails.root, path)

    FileUtils.rm(file)
  end

  alias :purge :drop

  private

  attr_reader :configuration
end
