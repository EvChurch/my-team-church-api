# frozen_string_literal: true

module Sources
  class ActiveRecordService < GraphQL::Dataloader::Source
    def initialize(model_class)
      @model_class = model_class
      super()
    end

    def fetch(ids)
      records = @model_class.where(id: ids).index_by(&:id)
      records.slice(*ids).values
    end
  end
end
