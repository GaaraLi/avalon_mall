class Topic::TopicController < ApplicationController
  layout "topic" 
  def shangxian
    #goods_id 72
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (90,91)");
    #goods_id 73
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (92,93,94)");
    #goods_id 68
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (85,86)");
    #goods_id 63
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (79)");
    #goods_id 75
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (96,97)");
    #goods_id 66
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (82)");
  end
end