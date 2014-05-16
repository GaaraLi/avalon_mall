class Topic::TopicController < ApplicationController
  layout "topic" 
  def shangxian
    
    @top1_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (90,91)");

    
    @top2_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (89)");

    
    @top3_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (85,86)");

    
    @top4_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (77)");

    
    @top5_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (80)");

    
    @top6_goods_qty = MallInventory.select(" ifnull(sum(inventory_qty),0) as sum_qty").where("mall_sku_id in (89)");

  end
end