class Api::PagesController < ApplicationController
skip_before_filter :verify_authenticity_token

  def index
    page_contents = PageContent.all
    render json: "#{page_contents.to_json(:only => [:url, :h1_data, :h2_data, :h3_data, :links])}"
  end

  def index_page_content
    begin
      doc = HtmlParser.doc_from_url(params[:url])
    rescue
      render json: {}, status: 400 and return
    end
    h1_data = HtmlParser.parse(doc, 'h1')
    h2_data = HtmlParser.parse(doc, 'h2')
    h3_data = HtmlParser.parse(doc, 'h3')
    links = HtmlParser.parse_link(doc)

    if PageContent.create!(url: params[:url], h1_data: h1_data,
                       h2_data: h2_data, h3_data: h3_data, links: links)
      render json: {}, status: 201
    else
     render json: {}, status: 500
    end
  end
end
