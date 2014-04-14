$(document).ready(function()
{
    var addSelOption = function(jq, defaultText) //方法addSelOption : 为匹配对象添加一项 defaultText， jq ： jQuery对象
    {
        //创建option对象，并设置文本为"请选择"，value值为-1
        var opt = $("<option/>").text(defaultText).attr("value", "-1");
        //将option对象添加到select中
        jq.append(opt);
    }
    //添加span节点并添加loadding的gif图片
    var requestUrl = "/customers/allcarbrand";
    $.ajax(
    {
        url : requestUrl,
        success : function(json)
        {
            $("#car_brand_branch").empty()
            addSelOption($("#car_brand_branch"), "品牌")
            $(json).each(function()
            {
                var opt = $("<option/>").text(this.name).attr("value", this.id);
                $("#car_brand_branch").append(opt);
            });
            $("#car_brand_branch").change(function()
            {
                var car_brand_id = $(this).val();
                if( car_brand_id != "-1")
                {
                    var requestUrl = "/customers/carbrand";
                    $.ajax(
                    {
                        dataType : "json",
                        url : requestUrl,
                        data:"id="+car_brand_id.toString(),
                        //传入的参数
                        success : function(json)
                        {
                            $("#car_model_id").empty()
                            addSelOption($("#car_model_id"), "车型");
                            $("#customer_car_model_id").empty()
                            addSelOption($("#customer_car_model_id"));
                            $("#car_set_branch").empty();
                            addSelOption($("#car_set_branch"), "车系");
                            $(json).each(function()
                            {
                                var opt = $("<option/>").text(this.name).attr("value", this.id);
                                $("#car_set_branch").append(opt);
                            });
                        }
                    });
                }
                else
                {
                    $("#car_set_branch").empty();
                    addSelOption($("#car_set_branch", "车系"));
                    $("#car_model_id").empty();
                    addSelOption($("#car_model_id", "车型"));
                }
            });
            $("#car_set_branch").change(function()
            {
                var car_set_id = $(this).val();
                if( car_set_id != "-1")
                {
                    var requestUrl = "/customers/carset/" + car_set_id.toString();
                    $.ajax(
                    {
                        dataType : "json",
                        url : requestUrl,
                        success : function(json)
                        {
                            $("#car_model_id").empty()
                            addSelOption($("#car_model_id"), "车型");
                            $(json).each(function()
                            {
                                var opt = $("<option/>").text(this.name).attr("value", this.id);
                                $("#car_model_id").append(opt);
                            });
                        }
                    });
                }
                else
                {
                    $("#car_model_id").empty();
                    addSelOption($("#car_model_id"), "车型");
                }
            });
        }
    });
});
