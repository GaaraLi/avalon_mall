var mapObj;

function map_initialize(center_point) {
  mapObj = new AMap.Map("map_canvas", {center: center_point, level: 12});
  mapObj.plugin(["AMap.ToolBar","AMap.OverView,AMap.Scale"], function() {
  // 加载工具条
  tool = new AMap.ToolBar({
          direction: false, // 隐藏方向导航
          ruler: false, // 隐藏视野级别控制尺
          autoPosition: false // 禁止自动定位
      });
      mapObj.addControl(tool);
  });
  return mapObj;
}

function markers(vendors) {
  var mark;
  for(var i = 0; i < vendors.length; i++ ) {
    mark = marker(vendors[i]);
    marker_popup(mark, vendors[i]);
  }
}

function marker(vendor) {
  var position = new AMap.LngLat(vendor.address.longitude, vendor.address.latitude);
  var marker = new AMap.Marker({map: mapObj, position: position, icon: "http://webapi.amap.com/images/marker_sprite.png"});
  return marker;
}

function marker_popup(marker, vendor) {
  var info = [];
  if (vendor.main_photo != null ) {
    info.push('<img src=' + vendor.main_photo.vendor_picture.thumb.url + '/>');
  }
  info.push('<div><a href= ' + vendor.id + ' target="_blank">' + vendor.name + '</a><br/>');
  info.push("<span> 地址: " + vendor.address.street + "</span>");

  var inforWindow = new AMap.InfoWindow({
    offset:new AMap.Pixel(0,-30),
    content:info.join("")
  });

  AMap.event.addListener(marker,'click',function(e){
    inforWindow.open(mapObj, marker.getPosition());
  });
}