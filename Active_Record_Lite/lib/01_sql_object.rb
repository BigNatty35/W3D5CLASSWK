require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject



  def self.columns
    return @cols if @cols
    var = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
      0
    SQL

    cols = var.map do |el|
      el.to_sym
    end
    @cols = cols

  end

  def self.finalize!

    cols = self.columns
    cols.each do |col|

    define_method(col) do
      attributes[col]
      # instance_variable_get("@#{col}")
    end

    define_method("#{col}=") do |value|
      attributes[col]=value
      # instance_variable_set("@#{name}", value)
    end
  end


  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name = self.to_s.underscore + "s"
  end

  def self.all
    var = DBConnection.execute(<<-SQL)
      SELECT #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL

    self.parse_all(var)

  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    possible = self.all
    possible.each do |pos|
      return pos if pos.id == id
    end
    nil
  end

  def initialize(params = {})
    params.each do |k, v|
      if self.class.columns.include?(k.to_sym)
        self.send("#{k.to_sym}=", v)
      else
        raise "unknown attribute '#{k.to_sym}'"
      end
    end
  end

  def attributes
    return @attributes if @attributes
    @attributes = {}
  end

  def attribute_values
    
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
