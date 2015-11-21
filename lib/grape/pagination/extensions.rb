module Grape::Pagination
  module Extensions
    def paginate(options = {})
      options.reverse_merge!(per_page: 30)
      params do
        optional :page,
          type: Integer,
          desc: I18n.t('api.params.page'),
          default: 1
        optional :per_page,
          type: Integer,
          desc: I18n.t('api.params.per_page'),
          default: options[:per_page]
      end
    end
  end
end
