class Topic::TopicController < ApplicationController
  layout "topic" 
  def shangxian
    @mall_blocks = MallBlock.where("id in (81,82,83,84,85,86)");
    @mall_today_info = MallBlock.where("id = 88").first;
  end
end