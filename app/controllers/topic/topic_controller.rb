class Topic::TopicController < ApplicationController
  layout "topic" 
  def shangxian
    @mall_blocks = MallBlock.where("id in (81,82,83,84,85)");
    @mall_block_card = MallBlock.where("id = 86").first;
    @mall_today_info = MallBlock.where("id = 88").first;
  end

  def tcx
  	
  end

  def june_act
  	render :layout => 'empty' 
  end
end