class ActiveRecord::Tasks::PostgreSQLDatabaseTasks
  DEFAULT_ENCODING = ENV['CHARSET'] || 'utf8'

  delegate :connection, :establish_connection, :clear_active_connections!,
    :to => ActiveRecord::Base

  def initialize(configuration)
    @configuration = configuration
  end

  def create(master_established = false)
    establish_master_connection unless master_established
    connection.create_database configuration['database'],
      configuration.merge('encoding' => encoding)
    establish_connection configuration
  end

  def drop
    establish_master_connection
    connection.drop_database configuration['database']
  end

  def purge
    clear_active_connections!
    drop
    create true
  end

  private

  attr_reader :configuration

  def encoding
    configuration['encoding'] || DEFAULT_ENCODING
  end

  def establish_master_connection
    establish_connection configuration.merge(
      'database'           => 'postgres',
      'schema_search_path' => 'public'
    )
  end
end
