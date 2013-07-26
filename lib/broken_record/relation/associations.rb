module BrokenRecord
  class Relation
    class Associations
      def initialize(relation)
        self.relation = relation
      end

      def belongs_to(parent, params)
        relation.define_record_method(parent) do
          BrokenRecord.string_to_constant(params[:class])
                      .find(send(params[:key]))
        end
      end

      def has_many(children, params)
        table_primary_key = relation.table.primary_key

        relation.define_record_method(children) do
          if params[:through] == nil
            BrokenRecord.string_to_constant(params[:class])
              .where(params[:key] => send(table_primary_key))
          else
            source_ids = BrokenRecord.string_to_constant(params[:class])
              .where("#{params[:target].downcase}_id".to_sym => send(table_primary_key)).map { |r| r.send("#{params[:source].downcase}_id".to_sym) }
            source_ids.map { |source_id|
              BrokenRecord.string_to_constant(params[:source])
                .where(:id => source_id)
            }.flatten
          end
        end
      end

      def has_one(children, params)
        table_primary_key = relation.table.primary_key

        relation.define_record_method(children) do
          BrokenRecord.string_to_constant(params[:class])
            .where(params[:key] => send(table_primary_key)).first
        end
      end

      attr_accessor :relation
    end
  end
end
