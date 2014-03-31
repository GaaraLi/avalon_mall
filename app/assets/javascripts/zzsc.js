window.Common=window.Common||{};
(function(a,e,f,i,h){
	e.TriggerOn={onReady:"ready",onLoad:"load",onAdd:"add"};
	var b={type:"GET",dataType:"json",url:"/svc/q",beforeSend:h,error:h,success:h};
	var c={url:"url",data:"args"};
	var d=["success","error","complete"];
e.init=function(j){
	var k=this;
	k.settings=a.extend(true,{},b,j);
	k.inited=true;
	a(function(){
		k.invoke(e.TriggerOn.onReady)
	});
	a(i).load(function(){k.invoke(e.TriggerOn.onLoad)
	})
};

e.addCall=function(j,l){var k=this;
if(!k.inited){k.init()
}if(!l){l=e.TriggerOn.onReady
}if(!k.ajaxQueue){k.ajaxQueue={}
}if(l===e.TriggerOn.onAdd){k.ajaxQueue[l]=j;
k.invoke(e.TriggerOn.onAdd);
k.ajaxQueue[l]={};
return
}if(!k.ajaxQueue[l]){k.ajaxQueue[l]=j
}else{if(a.isArray(k.ajaxQueue[l])){k.ajaxQueue[l].push(j)
}else{k.ajaxQueue[l]=[k.ajaxQueue[l],j]
}}};
function g(o){var n={reqParam:[],resFunc:[]};
if(o){var k=0,m=o.length?o.length:1,j=a.isArray(o)?o[k]:o;
do{var p={},q={};
a.each(c,function(r,s){if(!j[r]){return true
}if(r==="data"){var l=[];
if(typeof j[r]==="string"){j[r].replace(/[?&]*([^=&]+)=([^&]*)/gi,function(v,t,u){l.push(u)
})
}else{if(typeof j[r]==="object"){a.each(j[r],function(t,u){l.push(u)
})
	}}p[s]=l
	}else{p[s]=j[r]
	}});
	p.index=k;
	n.reqParam.push(p);
	a.each(d,function(l,r){if(j[r]){q[r]=j[r]
	}});
	q.index=k;
	n.resFunc.push(q);
	k=k+1;
	j=o[k]
	}while(j&&k<m)
	}return n
	}e.invoke=function(m){var k=this,l=k.settings;
	if(k.exists(m)){var j=g(k.ajaxQueue[m]);
	return a.ajax({url:l.url,dataType:l.dataType,type:l.type,data:"args="+f.stringify(j.reqParam)+"&r="+Math.round(Math.random()*10000),beforeSend:function(){if(a.isFunction(l.beforeSend)){l.beforeSend.apply(k,arguments)
	}},error:function(p,o,n){if(a.isFunction(l.error)){l.error.apply(k,arguments)
	}},success:function(n,o,p){if(a.isFunction(l.success)){l.success.apply(k,arguments)
	}a.each(n,function(r,s){var q=j.resFunc[s.index];
	if(q&&s.status===1){a.isFunction(q.success)&&q.success.apply(k,[s.data])
	}})
	}}).done(function(){k.remove(m)
	})
	}};
	e.exists=function(k){var j=this;
	if(j.ajaxQueue&&j.ajaxQueue[k]){return true
	}else{return false
	}};
	e.remove=function(k){var j=this;
	if(j.exists(k)){j.ajaxQueue[k]=h
	}};
	a.ajaxEnqueue=function(j){e.addCall(j)
	}
})(jQuery,Common.AjaxCombiner=Common.AjaxCombiner||{},JSON,window);


window.Plugin=window.Plugin||{};
(function(a,c,l,k){var b={imgListClass:"ul.imgList",btnListClass:".btnList",imgBtnWrapClass:".BtnimgList",imgBtnWidth:100,imgBtnHeight:51,numBtnCLass:".numList",arrow:false,firstBannerLazyLoad:false,autoPlay:true,autoPlayInterval:4000,bannerHover:k,imgBtnHover:k,beforeSlideTo:k};
var h=function(m){var n=a();
for(var o=1;
o<=m.bannerNum;
o++){n=n.add("<a href='javascript:void(0);'>"+o+"</a>")
}m.numBtnContainer.append(a('<div class="BtnNumWrap"></div>').append(n.eq(m.currentBanner-1).addClass("cur").end()));
m.numBtnWrap=m.numBtnContainer.find(".BtnNumWrap");
m.numBtnWrap.animate({bottom:(1-(m.bannerContainer.height()-100))+419+"px"});
m.numBtns=m.numBtnContainer.find("a")
};
var g=function(m){var o=a(),n=m.bannerContainer.outerHeight()/2-52;
//o=o.add('<div class="pagingArrowWrap prev" style="left:-70px;top:'+n+'px"><a class="arrow" data-dir="prev"></a></div>');
//o=o.add('<div class="pagingArrowWrap next" style="right:-70px;top:'+n+'px"><a class="arrow" data-dir="next"></a></div>');
m.bannerContainer.append(o).find("a.arrow").on("click",function(p){var q=a(this);
if(q.data().dir==="prev"){m.prevBanner()
}else{m.nextBanner()
}}).hover(function(){m.startPlay(false)
},function(){m.startPlay(true)
});
m.arrowPrev=m.bannerContainer.find("div.pagingArrowWrap.prev");
m.arrowNext=m.bannerContainer.find("div.pagingArrowWrap.next")
};
var d=function(m){m.bannerContainer.hover(function(n){if(a(n.target).hasClass("arrow")){return false
}m.imgBtnWrap.stop().animate({bottom:(1-(m.bannerContainer.height()-78))+"px"});
m.imgBtnWrap.find("img[loadsrc]").each(function(){var o=a(this);
o.attr("src",o.attr("loadsrc")).removeAttr("loadsrc")
});
m.numBtnWrap.stop().animate({bottom:(1-(m.bannerContainer.height()+78))+"px"});
if(typeof m.settings.bannerHover==="function"){m.settings.bannerHover.apply(m,arguments)
}},function(){m.imgBtnWrap.stop().animate({bottom:(1-(m.bannerContainer.height()+100))+100+"px"});
m.numBtnWrap.stop().animate({bottom:(1-(m.bannerContainer.height()-100))+419+"px"})
})
};
var e=function(m){m.imgBtns.hover(function(){var n=a(this),o;
if(n.siblings("img").length>0){o=n.index()+1
}else{o=n.parent().index()+1
}m.slideTo(o);
if(typeof m.settings.imgBtnHover==="function"){m.settings.imgBtnHover.apply(m,arguments)
}});
m.imtBtnContainer.hover(function(){m.startPlay(false)
},function(){m.startPlay(true)
})
};
var f=function(m){m.bannerContainer.on("scrollin",{full:true},function(){if(m.settings.autoPlay){m.startPlay(true)
}}).on("scrollout",{full:true},function(){if(m.settings.autoPlay){m.startPlay(false)
}})
};
var j=function(m){m.autoPlayTimer=setInterval(function(){if(m.currentBanner===m.bannerNum){m.currentBanner=0;
m.slideTo(m.currentBanner+1,true)
}else{m.slideTo(m.currentBanner+1)
}},m.settings.autoPlayInterval)
};
var i=function(m,o,n){m.banners.slice(o,n).each(function(){var p=a(this);
if(p.attr("loadsrc")){p.attr("src",p.attr("loadsrc")).removeAttr("loadsrc")
}})
};
c.startPlay=function(n){var m=this;
if(n){if(!m.autoPlayTimer){if(m.settings.autoPlay){j(m)
}}}else{if(m.autoPlayTimer){clearInterval(m.autoPlayTimer);
m.autoPlayTimer=null
}}};
c.slideTo=function(m,n){var p=this,o=p.bannerWidth*(m-1);
p.imgContainer.stop();
if(a.isFunction(p.settings.beforeSlideTo)){p.settings.beforeSlideTo.apply(p,arguments)
}p.currentBanner=m;
i(p,p.currentBanner-1,p.currentBanner+1);
p.imgBtns.removeClass("cur").eq(p.currentBanner-1).addClass("cur");
p.numBtns.removeClass("cur").eq(p.currentBanner-1).addClass("cur");
if(n){p.imgContainer.animate({left:-o},10)
}else{p.imgContainer.animate({left:-o})
}};
c.nextBanner=function(){var m=this;
if(m.currentBanner>=m.bannerNum){m.slideTo(1,true)
}else{m.slideTo(m.currentBanner+1)
}};

c.prevBanner=function(){
	var m=this;
	if(m.currentBanner<=1){m.slideTo(m.bannerNum,true)
	}
	else{m.slideTo(m.currentBanner-1)
	}
};

c.init=function(o,m){
	var p=this;
	p.elem=m;
	p.$elem=a(m);
	p.bannerContainer=p.$elem;
	p.settings=a.extend(true,{},b,o);
	p.imgContainer=p.bannerContainer.find(p.settings.imgListClass);
	p.imgBtnWrap=p.bannerContainer.find(p.settings.imgBtnWrapClass);
	p.imtBtnContainer=p.imgBtnWrap.closest(p.settings.btnListClass);
	p.imgBtns=p.imgBtnWrap.find("img");
	p.numBtnContainer=p.bannerContainer.find(p.settings.numBtnCLass).removeClass().addClass("BtnNumList");
	var n=p.imgContainer.find("li");
	p.bannerNum=n.length;

	p.imgBtns.each(function(){
		var q=a(this);
		q.width(p.settings.imgBtnWidth).height(p.settings.imgBtnHeight)
	});

	p.bannerWidth=n.outerWidth(true);
	p.banners=n.find("img");
	p.currentBanner=1;

	if(p.bannerNum<=1){
		return false
	}

	p.bannerContainer.on("scrollin",function(){
		p.bannerContainer.off("scrollin");
		f(p);
		i(p,0,1);
		setTimeout(function(){i(p,1,2)
		},p.settings.autoPlayInterval/2)
	});

	p.imgContainer.width(p.bannerNum*p.bannerWidth);
	h(p);

	if(p.settings.arrow&&p.bannerNum>1){
		g(p)
	}d(p);
	e(p)
};

	c.refresh=function(){
		var m=this;
		m.imgBtns=m.imgBtnWrap.find("img");
		m.bannerNum=m.imgBtns.length;
		if(m.currentBanner>m.bannerNum){
			m.currentBanner=m.bannerNum
		}
		m.banners=m.imgContainer.find("li img");
		m.imgContainer.width(m.bannerNum*m.bannerWidth);
		m.numBtnContainer.html("");
		h(m);
		g(m);
		d(m);
		e(m)
	};


	a.fn.bannerSlider=function(m){
		return this.each(function(){var n=Object.create(c);
			n.init(a.extend(true,{},a.fn.bannerSlider.defaults,m),this);
			a.data(this,"bannerSlider",n)
		})
	};

	a.fn.bannerSlider.defaults=a.extend(true,{},b)
	})(jQuery,Plugin.BannerSlider=Plugin.BannerSlider||{},window);