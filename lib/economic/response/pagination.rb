module Economic
  class Response::Pagination < Economic::Model
    field :max_page_size_allowed
    field :skip_pages
    field :page_size
    field :results
    field :results_without_filter
    field :first_page
    field :next_page
    field :last_page

    def next_page?
      next_page.present?
    end
  end
end
