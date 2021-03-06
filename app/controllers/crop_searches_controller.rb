class CropSearchesController < ApplicationController

  # TODO: eventually this search should also be searching guides
  def search
    # Singularize a word to only search singulars.
    search_word = params[:cropsearch][:q].singularize

    # Use search term to find crops
    @crops = Crop.full_text_search(search_word, max_results: 2)
    if @crops.empty?
      @crops = Crop.all.limit(2)
    end

    # Use the crop results to look-up guides
    crop_ids = @crops.pluck(:id)
    @guides = crop_ids.map! do |id|
      Guide.where(crop_id: id)
    end
    @guides.flatten!

    render :show
  end
end
