module ExtendedMigration # append some defaults

  def create_table table_name, **options
    timestamps = true if (timestamps = options.delete :timestamps).nil?
    block = -> (t) do
      t.extend ColumnMethods
      t.timestamps if timestamps
      yield t if block_given?
    end
    super table_name, options, &block
  end

  module ColumnMethods

    def timestamps *args, **options
      options.reverse_merge! null: false, index: true
      super *args, options
    end

    def references *args, **options
      if polymorphic = options.delete(:polymorphic)
        polymorphic = {} unless Hash === polymorphic
        polymorphic.reverse_merge! limit: 50
      end
      options.reverse_merge! index: true, polymorphic: polymorphic
      super *args, options
    end

    def column name, type, **options
      case type.to_sym
      when :string
        options.reverse_merge! null: false, limit: 255
      when :integer
        options.reverse_merge! null: false
      when :boolean
        options.reverse_merge! null: false, index: true
      end
      super name, type, options
    end

  end
end
