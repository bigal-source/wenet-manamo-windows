(function(){
	ADDONS = {
		zoomText : {
			'1' : "自動調整",
			'2' : "200%",
			'4' : "400%",
			'8' : "800%"
		},
		
		isActive : false,
		isModal : false,
		isOverLayoutHide : false,
		ordernavbar : ["#right-sns-bar", ".prev-button", ".next-button", '#bottom-banner-bar'],
		fullstatus : false,
		allowsPanelOpen : true,
		clicked : null,
		
		//flags
		previewBook : false,
		isBookShelfFlag : false,
		
		//application
		isAppDownloadBook : false, //ダウンロード 現在ブックとダウンロードブックが同じがどうか確認flag

		init : function(){
		    this.zoomText["1"] = PARAM.viewLang.commonlang["view-lang-levelauto"];
			this.setFlagData();
			viewMessageProc.viewMessageEvent();
			this.setSkinDisplayToModuleInit();
			this.commonEvent();
			if( viewUtils.device === 'pc' ) this.pcEvent();
			else this.mobileEvent();
		},
		
		setFlagData : function(){
			//if( typeof( PARAM.viewData.previewBook ) != "undefined" && PARAM.viewData.previewBook == 'on' ) this.previewBook = true;
			if( ('previewBook' in viewInfo) &&  viewInfo.previewBook == 'on' ) this.previewBook = true;
			if( 'bookshelfFlag' in viewInfo ) this.isBookShelfFlag = true;
		},
		
		setLanguage : function(type){
		    var langObj;
		    if( type == "common" ) langObj = PARAM.viewLang.commonlang;
		    else if( type == "print" ) langObj = PARAM.viewLang.printlang;
		    else if( type == "bookmark" ) langObj = PARAM.viewLang.bookmarklang;
		    else if( type == "search" ) langObj = PARAM.viewLang.searchlang;
		    else if( type == "memo" ) langObj = PARAM.viewLang.memolang;
		    else if( type == "pen" ) langObj = PARAM.viewLang.penlang;
		    else if( type == "share" ) langObj = PARAM.viewLang.sharelang;
		    else if( type == "productsearchlang" ) langObj = PARAM.viewLang.productsearchlang;
		    
		    for( var l in langObj ){
    		    $('.'+l).text(langObj[l]);
		    }	
		},
		
		setPlaceholder : function(){
    	    for( var p in PARAM.viewLang.viewplaceholderlang ){
        	    $('.'+p).attr('placeholder', PARAM.viewLang.viewplaceholderlang[p]);
    	    }
		},

		setDownloadAppBook : function( dnInfo ){
			var streamBtn = $("#btn-add-stream"),
				downloadBtn = $("#btn-download"),
				appSelectType = PARAMLIBRARY.createViewInfo.selected;
            
            if( dnInfo == "error" ){
                downloadBtn.removeClass('disable').find(".view-lang-download").text(PARAM.viewLang.commonlang["view-lang-download"]);
                return false;
            }
            
            
			if( PARAMDATA.processAppid != null && PARAMDATA.processAppid == PARAMLIBRARY.createViewInfo.app_book_id ) this.isAppDownloadBook = true;

			if( PARAMDATA.processAppid != null ){
				//streamBtn.addClass("disable");
				downloadBtn.addClass("disable");
			}

			if( !dnInfo ){
				if( PARAMLIBRARY.createViewInfo.objcontents.disttype == "1" )
					downloadBtn.remove(); //stream だけ
				
				if( PARAMLIBRARY.createViewInfo.objcontents.disttype == "2" )
					streamBtn.remove(); //download だけ

				if( (appSelectType == "download" || appSelectType == "update")&& PARAMLIBRARY.createViewInfo.status == 100 ){
					if( PARAMLIBRARY.createViewInfo.objcontents.sel_disttype == "stream" ) streamBtn.remove();
					else{
						downloadBtn.addClass('disable');
						//streamBtn.remove();
					}
				}
			}else{
				switch(dnInfo.status){
					case 2 :
						if( !this.isAppDownloadBook ) return false;
						if( dnInfo.objcontents.sel_disttype == "download" && typeof dnInfo != "undefined" ){
							downloadBtn.find(".view-lang-download").text(PARAM.viewLang.commonlang["view-lang-download"] + ' ('+parseInt( dnInfo.progress, 10) +'%)' );
						}

						break;

					case 3 :
						if( !this.isAppDownloadBook ) return false;

						if( dnInfo.objcontents.sel_disttype == "download" ){
							downloadBtn.find(".view-lang-download").text(PARAM.viewLang.commonlang["view-lang-download"] + ' ('+PARAMDATA.lang.oneword.book_unzip+')' );
						}

						break;

					case 100 :
						if( this.isAppDownloadBook ){
							if( dnInfo.objcontents.sel_disttype == "stream" ){
								//streamBtn.remove();
								//downloadBtn.removeClass("disable");
							}else{
								//streamBtn.remove();
								downloadBtn.addClass('disable').find(".view-lang-download").text(PARAM.viewLang.commonlang["view-lang-download"]);

                if(!PARAMLIBRARY.isAppBookshelfFlag) {
                    h5applib.showConfirm('本棚に移動しますか？', PARAMDATA.lang.oneword.notice, function(){
                        htmlview.destroy();
                        libStore.viewerToLibrary({"goBookshelf":true});
                    }, '');
                }

							}
						}else{
							downloadBtn.removeClass("disable");
							//streamBtn.removeClass("disable");
						}

						
						break;
				}
			}
		},
		
		setSkinDisplayToModuleInit : function(){
			var removeElement = [];
			mediaControl = new wisebookMediaControl();
			
			this.setLanguage("common");
			this.setPlaceholder();
			
			popuptextProc.init();
			removeElement.push('#btn-add-stream');
			
			if(!appFlag) {
			    removeElement.push('.goViewBack', '#btn-download');
                
                //set home
                if( 'homeurl' in viewInfo && 'bookshelfFlag' in viewInfo && 'mychannel' in viewInfo == false ){
                    $('#btn-home').attr('data-href', viewInfo.homeurl);
                    //viewNavContainerAction
                }else{
                    //mychannel
                    removeElement.push('#btn-home');
                    this.viewNavContainerAction('hide');
                }
			}else{
    			removeElement.push('#btn-home');
    			this.setDownloadAppBook();
			}
			
			if( PARAM.bookInfo.skin.hidecontrol && PARAM.bookInfo.skin.hidetool ){
				PARAM.wisebookToobarNavigater.remove();

				tocProc = null;
				thumbnailProc = null;
				searchProc = null;
				helpProc = null;
				printerProc = null;
				shareProc = null;
				bookmarkProc = null;
				productsearchProc = null;

				removeElement.push('#btn-toc', '#btn-thumb', '#btn-bookmark',
									'#btn-search', '#btn-memo', '#btn-pentools',
									'#btn-share', '#btn-help', '#btn-pdf', '#btn-print', 
									'#btn-productsearch', '#btn-pdfdivision');
			}else {
				if( PARAM.bookInfo.skin.hidecontrol ){
					//range slide remove
					$('#view-controlbar-slider').remove();
					$('.center-controlbar-icons').remove();
					navigatorProc.init();
				}else{
					navigatorProc.init();
				}
				
				if( PARAM.bookInfo.skin.hidetool ){
					//hidetool
					$('#view-controlbar-option').remove();
					tocProc = null;
					thumbnailProc = null;
					searchProc = null;
					helpProc = null;
					printerProc = null;
					productsearchProc = null;

					removeElement.push('#btn-toc', '#btn-thumb', '#btn-bookmark',
										'#btn-search', '#btn-memo', '#btn-pentools', 
										'#btn-share', '#btn-help', '#btn-pdf', '#btn-print', 
										'#btn-productsearch', '#btn-pdfdivision'
										);
				}else{
					if(!PARAM.bookInfo.skin.pdfdown) {
						$('#btn-pdfdivision').remove();
						removeElement.push('#btn-pdfdivision');
					}
					
					if(!PARAM.bookInfo.skin.toc ) {
						tocProc = null;
						removeElement.push('#btn-toc');
					}else{
						if( PARAM.tocjsonInfo != null ){
							tocProc.init();
							if( PARAM.tocjsonInfo != null )  htmlview.workerview.postMessage({cmd :'toc'});
						}else tocProc = null;
					}
					
					if(!PARAM.bookInfo.skin.thumb) {
						thumbnailProc = null;
						removeElement.push('#btn-thumb');
					}else{
						thumbnailProc.init();
					}
					
					
					if(!PARAM.bookInfo.skin.bookmark) {
						bookmarkProc = null;
						removeElement.push('#btn-bookmark');
					}else{
						bookmarkProc.init();
					}
						
					if(!PARAM.bookInfo.skin.search) {
						searchProc = null;
						removeElement.push('#btn-search');
					}else searchProc.init();
					
						
					if(!PARAM.bookInfo.skin.postit) 
						removeElement.push('#btn-memo');
					else{
					    this.setLanguage('memo');
						wisebookmemo = new wisebookmemo();
					}
					
					if(!PARAM.bookInfo.skin.pentool) 
						removeElement.push('#btn-pentools');
					else {
					    this.setLanguage('pen');
						wisebookpen = new wisebookpen();
					}
					
					if(!PARAM.bookInfo.skin.mail){
						shareProc = null;
						removeElement.push('#btn-share');
					}else shareProc.init();
					
					if(!PARAM.bookInfo.skin.pdf) {
						removeElement.push('#btn-pdf');
					}
					
					if(!PARAM.bookInfo.skin.help) {
						helpProc = null;
						removeElement.push('#btn-help');
					}else{
						helpProc.init();
						htmlview.workerview.postMessage({cmd :'help'});
					}
					
					if( !PARAM.bookInfo.skin.print || navigator.userAgent.match(/MSAppHost/i) || appFlag == true || viewUtils.androidInfo.check ) {
						removeElement.push('#btn-print');
						if(PARAM.bookInfo.skin.pdfdown) printerProc.init();
					}else{
						printerProc.init();
					}
					
					//商品検索
					if( 'productsearch' in PARAM.bookInfo && PARAM.bookInfo.productsearch.productlist.length > 0 ){
    					productsearchProc.init();
					}else{
					    productsearchProc = null;
    					removeElement.push('#btn-productsearch');
					}
					
					//切り抜き
					if( 'scissors' in PARAM.bookInfo.skin && PARAM.bookInfo.skin.scissors == 1 && viewUtils.device == 'pc' ){
					    wisebookcrop = new wisebookcrop();
					}else{
    				    removeElement.push('#btn-crop');
					}

					if( 'full' in PARAM.bookInfo.skin && PARAM.bookInfo.skin.full == 0 && viewUtils.device == 'pc' ){
					    //$("#btn-full").remove();
					    removeElement.push('#btn-full');
					}
					
					//if( !BookJson.skin.print || (deviceWiseBook == 'an_Tablet' && !userBrowser.match(/msie/gi)) || navigator.userAgent.match(/MSAppHost/i) ) $('#btn_print').remove();
				}
			}
			
			//bottom banner
			if ( 'banner_h5' in PARAM.bookInfo) {
				var length = PARAM.bookInfo.banner_h5.length,
					pointnum = (length == 1) ? 0 : Math.floor( Math.random() * 2 ),
					bannerObj = PARAM.bookInfo.banner_h5[pointnum],
					bannerImgContentsImgElme =  $('.banner-img-contents img');
				
				bannerImgContentsImgElme.attr({ src : viewInfo.bookurl+bannerObj.file, alt : bannerObj.title });
				if( bannerObj.url ){
					bannerImgContentsImgElme.wrap('<a target="_blank" href="'+bannerObj.url+'" />');
				}
				
				$('#bottom-banner-bar').css("display", 'block');
			}else removeElement.push('#bottom-banner-bar'); //$('#bottom-banner-bar').remove();
			
			
			if( !('custom_pc' in  PARAM.bookInfo)
			    && viewUtils.device == "pc"
			    && !PARAM.bookInfo.custom_pc[0].enabled
			    && !PARAM.bookInfo.custom_pc[1].enabled
			    && ('cartinfo' in PARAM.bookInfo.config) == false ||  PARAM.bookInfo.config.cartinfo == 0
            ){
            	removeElement.push('#right-sns-bar');
            }
            
            //request
            if( ('custom_pc' in  PARAM.bookInfo) == false || !PARAM.bookInfo.custom_pc[0].enabled ) 
				removeElement.push('#btn-request');
			else if( viewUtils.device == "pc" ){
				if( ("h5_src" in PARAM.bookInfo.custom_pc[0]) == true && PARAM.bookInfo.custom_pc[0].h5_src != "" ){
					var tmpStyle = 'background:url('+viewInfo.bookurl+PARAM.bookInfo.custom_pc[0].h5_src+');background-size:cover;';
					$('#btn-request').html('').attr('style', tmpStyle);
				}
			}
            
            //contact
            if( ('custom_pc' in  PARAM.bookInfo) == false || !PARAM.bookInfo.custom_pc[1].enabled ) 
				removeElement.push('#btn-contact');
			else if( viewUtils.device == "pc" ){
				if( ("h5_src" in PARAM.bookInfo.custom_pc[1]) == true && PARAM.bookInfo.custom_pc[1].h5_src != "" ){
					var tmpStyle = 'background:url('+viewInfo.bookurl+PARAM.bookInfo.custom_pc[1].h5_src+');background-size:cover;';
					$('#btn-contact').html('').attr('style', tmpStyle);
				}
			}
			
			//cart
			if( ('cartinfo' in PARAM.bookInfo.config) == false ||  PARAM.bookInfo.config.cartinfo == 0 ){
				 removeElement.push('#btn-cart');
			}
            
			
			if( viewUtils.device != "pc"  ){
			    if( 
			        'skinnohtml' in PARAM.bookInfo.skin && PARAM.bookInfo.skin.skinnohtml =="catalog" 
				    && !PARAM.bookInfo.skin.bookmark
				    && ( ('custom_pc' in  PARAM.bookInfo) == false || !PARAM.bookInfo.custom_pc[0].enabled )
				    && ( ('custom_pc' in  PARAM.bookInfo) == false || !PARAM.bookInfo.custom_pc[1].enabled )
				    && ( 'productsearch' in PARAM.bookInfo == false || PARAM.bookInfo.productsearch.productlist.length <= 0)
				){
					$('#view-controlbar-option').remove();
					PARAM.wisebook.addClass('hide-toolbar');
				}else if(
				    !PARAM.bookInfo.skin.toc
				    && !PARAM.bookInfo.skin.thumb
				    && !PARAM.bookInfo.skin.bookmark
				    && !PARAM.bookInfo.skin.search
				    && !PARAM.bookInfo.skin.postit
				    && !PARAM.bookInfo.skin.pentool
				){
					//standard
					removeElement.push('#view-controlbar-option');
					PARAM.wisebook.addClass('hide-toolbar');
				}else{
    				var menuCountCheckPoint = ( viewUtils.Mobile == false ) ? 4 : 2 ;
                    if( $('#view-controlbar-option .option-button').length <= menuCountCheckPoint ){
                        PARAM.wisebook.addClass('mobilesmallmenu');    
                    }
				}
			}else{
				//pc only
				customTelopProc.init();
			}

			if( removeElement.length > 0 ){
				$( removeElement.join(',') ).remove();
			}
		},
		
		commonEvent : function(){
			var that = this;
			
			PARAM.wisebook.hammer({tap_max_touchtime:PARAM.tapTime}).on("tap", '.view-movepage-group', function(e){
				if( !PARAM.isNaviMove ) {
				    if( viewUtils.device == "pc" && (PARAM.nowBusy == 'memo' || PARAM.nowBusy == 'pen') ){
    				    var fadeMessageText = ( PARAM.nowBusy == "memo" ) ? PARAM.viewLang.memoControllClickErrMsg : PARAM.viewLang.penControllClickErrMsg;
                        $(document).trigger(viewdefind.VIEW_MESSAGE_FADE_TYPE, fadeMessageText);
				    }
				    
				    return false;
				}
			
				if( PARAM.autoslide ) htmlview.autopageplay();
				
				var moveType = $(this).data("pagemove");
				if( moveType == "prevpage" ) htmlview.prevpage();
				else if( moveType == "nextpage" ) htmlview.nextpage(true);
				else if( moveType == "firstpage" ) htmlview.gotofirstpage();
				else if( moveType == "lastpage" ) htmlview.gotolastpage();				
			});
			
			//common reisze
			$(document).bind(viewdefind.ADDONS_RESIZE, function(){
			    
				if( viewUtils.Mobile && PARAM.viewMode == "twopage" ) {
				    if(that.isModal == true) {
    				    var _modal = $('.view-popover.modal-in');
                        if( _modal.length > 0 ) that.closeModal(_modal);
                    }
				    that.viewNavContainerAction('hide');
				}
			});
			
			$(document).bind(viewdefind.PAGE_BEFORE_EVENT, function(e, obj){
				if( viewUtils.Mobile && PARAM.viewMode == "twopage" ) that.viewNavContainerAction('hide');
				
				if( 'cartinfo' in PARAM.bookInfo.config &&  PARAM.bookInfo.config.cartinfo == 1 )
				    that.cartinfoStatus();
			});
			
			$(document).bind('addons.view-open', '.view-open', function(e, popupElem){
				if( PARAM.nowBusy == 'memo' || PARAM.nowBusy == 'pen' ){
					if( PARAM.nowBusy == 'pen' ) {
						if( $(popupElem).hasClass('view-popup-pen') ) $(document).trigger(viewdefind.PEN_MODE_OPEN);
						else if( $(popupElem).hasClass('view-popover') ) $(document).trigger(viewdefind.PEN_POPOVER, popupElem);
					}else if( PARAM.nowBusy == 'memo' ){
						if( $(popupElem).hasClass('view-popup-memo') ) $(document).trigger(viewdefind.MEMO_MODE_OPEN);
					}
					
					that.viewNavContainerAction('hide');
				}else{
    				$(document).trigger(viewdefind.VIEW_POPUP_OPEN);
				}
			})
			
			$(document).bind('addons.view-opened', '.view-open', function(e, popupElem){
				that.isActive = false;
				if( viewUtils.device == 'pc' ) $('#viewBody').css('overflow', 'visible'); //chrome bug
								
				$(document).trigger(viewdefind.VIEW_POPUP_OPENED);
			});
			
			$(document).bind('addons.view-close', function(e, popupElem){
				if(  PARAM.nowBusy == 'search' )
					$('#search-textarea').trigger('blur');
				
				$(document).trigger(viewdefind.VIEW_POPUP_CLOSE);
				
				that.busyDestroy();
				if( viewUtils.device == 'pc' ) $('#viewBody').css('overflow', 'hidden');  //chrome bugのために
			});
			
			$(document).bind('addons.view-panel-open', '.view-panel', function(e, panelElem){
				if( $(panelElem).find('.search-panel-view').length ){
					searchProc.searchPhoneProcessBefore( $(panelElem) );
				}else if( $(panelElem).find('.productsearch-panel-view').length ){
    				productsearchProc.productSearchProcessBefore( $(panelElem) );
				}
			});
			
			PARAM.wisebook.hammer({tap_max_touchtime:PARAM.tapTime}).on('tap', '.tool-button, .view-open-popup, .close-view-popup, .view-open-panel, .view-close-panel, .view-open-popover, .view-modal-overlay', this.handleTap);
			
			PARAM.wisebook.on('tap', '#btn-contact, #btn-request', function(){ that.wisebookContact(this.id) });
			PARAM.wisebook.on('tap', '.close-view-banner, #btn-cart', function(){
			    if( this.id == "btn-cart" ){
			        var url = $(this).attr('data-url'),
			            page = $(this).attr('data-page');
    			    if( !url ) return false;
                    
                    var label = "InPage*outLink*" + url;
                    ANALYTICS._trackEvent("InPage", "outLink", label, page);
                    
    			    PARAM.openExtenal(url);
			    }else $('#bottom-banner-bar').remove();
			});
						
			if( appFlag ){
    			PARAM.wisebook.on('tap', '.goViewBack, #btn-download, #btn-add-stream', function(){
    			    if( this.id == "btn-download" || this.id == "btn-add-stream"  ){
    			    	if( $(this).hasClass("disable") ) {
    			    		if( PARAMLIBRARY.createViewInfo.status == 100 ) 
    			    			$(document).trigger(viewdefind.VIEW_MESSAGE_FADE_TYPE, "既にダウンロードが完了しました。");

    			    		return false;
    			    	}

    			        var downloadType = ( this.id == "btn-download" ) ? 'download' : 'streamDownload';
        			    libStore.viewerBookDataDownload(downloadType);
    			    }else{
        			    h5appview.hideView();
    			    }
    			});


    			//downlaod status
    			PARAMDATA.viewDwonloadTrigger = 
	    			$(document).bind('bookDownloadingStatus.viewer', function(e, dnInfo){
	    			    console.log(e.type);
	    				that.setDownloadAppBook( dnInfo );
	    			});
                
                PARAMDATA.viewDwonloadErrTrigger = 
                    $(document).bind('bookDownloadingError.viewer', function(e){
	    				that.setDownloadAppBook( 'error' );
	    			});
			}
		},
		
		handleTap : function(e){
			e.preventDefault();
			$(document).trigger(viewdefind.VIEW_NAV_AUTOHIDE_CLEAR);
			
			var that = ADDONS,
				clicked = $(this),
				clickedClassArr = this.className.split(' ');
			
			that.clicked = clicked;
			
			if( $.inArray('tool-button',  clickedClassArr) != -1 ){
				that.wisebooktools( clicked );
			}else if( $.inArray('view-open-popup',  clickedClassArr) != -1 ){
			
			}else if( $.inArray('view-open-popover',  clickedClassArr) != -1 ){
				var popover;
				
		    	if ( clicked.attr('data-popover') ) {
		    		popover = clicked.attr('data-popover');
		    	}else if( clicked.attr('data-href')  ){
		    		var url = viewPath + clicked.attr('data-href');
		    		htmlview.getHtml(url, function(data){
						that.viewpopover(data, clicked);
					});
		    		
			    	return false;
		    	}else popover = '.popover';
		    	
		    	that.viewpopover(popover, clicked);				
			}else if( $.inArray('view-modal-overlay',  clickedClassArr) != -1 ){
			    if( that.isOverLayoutHide ) return false;
			
				if(that.isModal == true) {
					var _modal = $('.view-popover.modal-in');
					if( _modal.length > 0 ) that.closeModal(_modal);
				}
			}else if( $.inArray('close-view-popup',  clickedClassArr) != -1 ){
				that.closeModal();	
			}else if( $.inArray('view-open-panel',  clickedClassArr) != -1 ){
				that.viewpanel( clicked );
			}else if( $.inArray('view-close-panel',  clickedClassArr) != -1 ){
				that.closePanel();
			}
		},
		
		
		pcEvent : function(){
			var that = this;
			
			if( PARAM.userzoom ){
    			$('#zoomlevel li').on("click", function(){
    				$('#zoomlevel').css('display','none');
    				var zoomval = parseInt( $(this).data('val') );
    				
    				if( PARAM.transformInfo.scale == zoomval ) return false;
    				
    				PARAM.transformInfo.scale = zoomval;
    				htmlview.pcselectZoom(zoomval);
    			});
    			
    			$('#btn-zoomin, #btn-zoomout').on("click", function(){
    				var tempzoomval = PARAM.transformInfo.scale,
    					checkAction = false;
    				
    				if( this.id == "btn-zoomin" && !$(this).hasClass('disable') ){
    					if( tempzoomval == PARAM.maxScale ) return false;
    					
    					tempzoomval *=2
    					checkAction = true;
    				}else if( !$(this).hasClass('disable') ){
    					if( tempzoomval == 1 ) return false;
    					tempzoomval /=2
    					checkAction = true;
    				}
    				
    				if( checkAction )
    					htmlview.pcselectZoom(tempzoomval);
    			});
			}
			
			$("#btn-bookauto").on("click", function(){
				if( !$(this).hasClass('disable') && !PARAM.autoslide ) {
					$(this).addClass("slide-autoplay");
					$("#btn-zoomin, #btn-zoomout").addClass("disable");
					htmlview.autopageplay();
				}else{
					htmlview.autopageplay();
				}
			});
			
			$('#naviMoveNumText').bind('keypress focus blur', function(e){
			    if( e.type == "keypress" ){
    			    if(e.keyCode == 13) {
    					var page = $(this).val().trim();
    					if(!PARAM.pageNumberType){
    						page = parseInt(page);
    						( PARAM.bookInfo.pages >= page && page > 0 ) ? that.sendGotopage( page ) :  viewMessageProc.alert( PARAM.viewLang.pageNumMaxErrMsg, PARAM.viewLang.alertTitle );
    					}else{
    						var nombreData = 0;
    						for( var l in PARAM.bookInfo.labels ){
    							if( PARAM.bookInfo.labels[l] == page ){
    								nombreData = parseInt(l)+1;
    								break;
    							}
    						}
    						( nombreData > 0 && page != "" && PARAM.bookInfo.pages >= nombreData ) ? that.sendGotopage( nombreData ) : viewMessageProc.alert( PARAM.viewLang.pageNumMaxErrMsg, PARAM.viewLang.alertTitle );
    					}
    					if( viewUtils.device == 'pc' ) $(this).blur();
    				}
			    }else if( e.type == "focus" && PARAM.isPcNaviHideAction ){
			        PARAM.isPcMenuShowHold = true;
                    ADDONS.pcViewNavContainerAction("stop");
			    }else if( e.type == "blur" && PARAM.isPcNaviHideAction ){
			        PARAM.isPcMenuShowHold = false;
			        ADDONS.pcViewNavContainerAction("start");
			    }
			});
			
			$(document).on(viewdefind.ZOOM_ANIMATION_END, function(e){
				ADDONS.pcZoomEndChangeStatus();
				$(document).trigger(viewdefind.MEMO_RESIZEBLE_LOCK);
			});			
		},
		
		mobileEvent : function(){
			var that = this;
			PARAM.wisebook.hammer({tap_max_touchtime:200}).on("tap", '.page-wrapper', function(e){
				if( PARAM.nowBusy == 'memo' || PARAM.nowBusy == 'pen' ) return false;
				
				//if( isFindClass( $(e.target), 'popuptext-view' ) )return false;

				if(!PARAM.isdbtap) {
					PARAM.dbtaptimer = setTimeout(function(){
						if( PARAM.isdbtap ){
							PARAM.isdbtap = false;
						}else{
						    if( PARAM.isPageMove ) return false;
						    
							if( PARAM.autoHideTimer )
								$(document).trigger(viewdefind.VIEW_NAV_AUTOHIDE_CLEAR);
							
							if( $(e.target).parent().hasClass('event-space') ) return false;
							if( that.isActive || mediaControl.isBusy ) {
								that.isActive = false;
								return false;
							}
							that.viewNavContainerAction();
						}
					}, 300);
				} 
			});
		},
		
		sendGotopage : function(page){
			//filter cover type page
			ADDONS.closeModal();
			htmlview.gotopage( page + PARAM.cover );
		},
		
		cartinfoStatus : function(){
		    var cartElem = $('#btn-cart');
		    cartElem.attr('data-url', '');
    		
    		if( PARAM.viewMode == "twopage" ){
        		if( PARAM.cover == 0 ){
        		    var pageObj;
            		if( PARAM.side.right == 0 ) pageObj = htmlview._pages[ PARAM.side.left-1 ];
            		else pageObj = htmlview._pages[ PARAM.side.right-1 ];
                    
        		}else{
            		if( PARAM.side.left == 0 ) pageObj = htmlview._pages[ PARAM.side.right-1 ];
            		else pageObj = htmlview._pages[ PARAM.side.left-1 ];
        		}
    		}else{
        		pageObj = htmlview._pages[ PARAM.currentpage-1 ];
    		}
    		    		
    		if( pageObj.cartinfo.url != "" ) { 
    		    cartElem.removeClass('disable').attr({ 'data-url' : pageObj.cartinfo.url, 'data-page' : pageObj.countpage });
    		}else{
        		cartElem.addClass('disable');
    		}
		},
		
		pcZoomEndChangeStatus : function(){
			if( viewUtils.device !== 'pc' ) return false;
			
			$('#zoomleveltext').text( this.zoomText[PARAM.transformInfo.scale] );
			
			if( PARAM.transformInfo.scale == 1 ) $("#btn-zoomout").addClass("disable");
			else $("#btn-zoomout").removeClass("disable");
			
			if( PARAM.transformInfo.scale == PARAM.maxScale ) $("#btn-zoomin").addClass("disable");
			else $("#btn-zoomin").removeClass("disable");
		},
        
        pcViewNavContainerAction : function( action ){
            if( viewUtils.device != 'pc' ) return false;
            
            if( action == "start" ){
                PARAM.wisebookToobarNavigater.css("display", "block").removeClass('view-order-hidden');
		        clearTimeout(PARAM.pcNaviHideTimer);
		        
		        PARAM.pcNaviHideTimer = setTimeout(function(){
		            PARAM.wisebookToobarNavigater.addClass('view-order-hidden');
		        }, PARAM.pcHideTime);
            }else {
                PARAM.wisebookToobarNavigater.css("display", "block").removeClass('view-order-hidden');
                clearTimeout(PARAM.pcNaviHideTimer);
            }
        },
        
		viewNavContainerAction : function( olnywork ){
			if( viewUtils.device == 'pc' ) return false;
			
			var navbar = PARAM.wisebookNavbar,
				toolbar = PARAM.wisebookToobarNavigater,
				navbarHidden = navbar.hasClass('view-navbar-hidden'),
				toolbarHidden = toolbar.hasClass('view-toolbar-hidden');
			
			//特別 work mobile memo, pen
			if( olnywork && olnywork == 'hide' ){
				for( var o in this.ordernavbar ){
					var orderbar = $(this.ordernavbar[o]);
					if( !orderbar ) continue;
					var orderbarHideen = orderbar.hasClass('view-order-hidden');
					if( !orderbarHideen )
						this.hideOrderNavbar(orderbar);
				}
				
				if( navbar.length && !orderbarHideen )
					this.hideTopNavbar(navbar);
					
				if( toolbar.length && !orderbarHideen )
					this.hideBottomNavbar(toolbar);	
				
				$(document).trigger(viewdefind.NAV_FADE_ACTION, 'hide');
				return false;
			}else if( olnywork && olnywork == 'show' ){
				if( viewUtils.Mobile && PARAM.viewMode == "twopage" ) return false;
				
				for( var o in this.ordernavbar ){
					var orderbar = $(this.ordernavbar[o]);
					if( !orderbar ) continue;
					this.showOrderNavbar(orderbar);
				}
			
				if( navbar.length )
					this.showTopNavbar(navbar);
					
				if( toolbar.length )
					this.showBottomNavbar(toolbar);
				
				$(document).trigger(viewdefind.NAV_FADE_ACTION, 'show');		
				return false;
			}
			
			if( viewUtils.Mobile && PARAM.viewMode == "twopage" ) return false;
			
			
			for( var o in this.ordernavbar ){
				var orderbar = $(this.ordernavbar[o]);
				if( !orderbar ) continue;
				
				var orderbarHideen = orderbar.hasClass('view-order-hidden');
				if( orderbarHideen )
					this.showOrderNavbar(orderbar);
				else
					this.hideOrderNavbar(orderbar);
				
			}
					
			if( navbar.length ){
				if( navbarHidden )
					this.showTopNavbar(navbar);
				else
					this.hideTopNavbar(navbar);	
			}
			
			if( toolbar.length ){
				if( toolbarHidden )
					this.showBottomNavbar(toolbar);
				else
					this.hideBottomNavbar(toolbar);
			}
			var status = (navbarHidden) ? 'show' : 'hide';
			$(document).trigger(viewdefind.NAV_FADE_ACTION, status);
		},
		
		hideTopNavbar : function(navbarContainer){
			var that = this;
			that.isActive = true;
			navbarContainer.addClass('view-navbar-hidden');
			navbarContainer.transitionEnd(function(){
				that.isActive = false;
			});
			return false;
		},
		
		showTopNavbar : function(navbarContainer){
			var that = this;
			that.isActive = true;
			navbarContainer.addClass('view-navbar-hiding').removeClass('view-navbar-hidden').transitionEnd(function () {
				navbarContainer.removeClass('view-navbar-hiding');
				that.isActive = false;
			});
			return true;
		},
		
		hideBottomNavbar : function(toolbarContainer){
			var that = this;
			that.isActive = true;
			toolbarContainer.addClass('view-toolbar-hidden');
			toolbarContainer.transitionEnd(function(){
				that.isActive = false;
			});
			return false;
		},
		
		showBottomNavbar : function(toolbarContainer){
			var that = this;
			that.isActive = true;
			toolbarContainer.addClass('view-toolbar-hiding').removeClass('view-toolbar-hidden').transitionEnd(function () {
				toolbarContainer.removeClass('view-toolbar-hiding');
				that.isActive = false;
			});
			return true;
		},
		
		hideOrderNavbar : function(orderContainer){
			var that = this;
			that.isActive = true;
			orderContainer.addClass('view-order-hidden');
			
			orderContainer.transitionEnd(function(){
				orderContainer.css("visibility", "hidden");
				that.isActive = false;
			});
			return false;
		},
		
		showOrderNavbar : function(orderContainer){
			var that = this;
			that.isActive = true;
			orderContainer.css("visibility", "visible");
			orderContainer.addClass('view-order-hiding').removeClass('view-order-hidden').transitionEnd(function () {
				orderContainer.removeClass('view-order-hiding');
				that.isActive = false;
			});
			return true;
		},
		
		viewpopup : function(modal){
			if( this.isActive ) return false;
			
			if (typeof modal === 'string' && modal.indexOf('<') >= 0) {
				 var _modal = document.createElement('div');
				 _modal.innerHTML = $.trim(modal);
				
				 if (_modal.childNodes.length > 0) {
				 	modal = _modal.childNodes[0];
				 	PARAM.wisebook.append(modal);
				 	
				 }else return false;
			}
			
			this.isActive = true;
			
			modal = $(modal);

			if (modal.length === 0) return false;
			
			modal.css('display', 'block');
			this.openModal(modal);
		},
		
		viewpopover : function(modal, target){
			if (typeof modal === 'string' && modal.indexOf('<') >= 0) {
				
				var _modal = document.createElement('div');
				_modal.innerHTML = $.trim(modal);
				
				if (_modal.childNodes.length > 0) {
					modal = _modal.childNodes[0];
					modal.classList.add('remove-on-close');
					PARAM.wisebook.append(modal);
				}else return false;
			}
			
			modal = $(modal);
			target = $(target);
			
			if (modal.length === 0 || target.length === 0) return false;
			modal.show();
			function viewSizePopover() {
				modal.css({left: '', top: ''});
				var modalWidth =  modal.width();
				var modalHeight =  modal.height(); // 13 - height of angle
				var modalAngle = modal.find('.view-popover-angle');
				var modalAngleSize = modalAngle.width() / 2;
				modalAngle.removeClass('on-left on-right on-top on-bottom').css({left: '', top: ''});
				
				var targetWidth = target.outerWidth();
				var targetHeight = target.outerHeight();
				var targetOffset = target.offset();
				var targetParentPage = PARAM.wisebook;
				if (targetParentPage.length > 0) {
				    targetOffset.top = targetOffset.top - targetParentPage[0].scrollTop;
				}
					
				var windowHeight = $(window).height();
				var windowWidth = $(window).width();

				var modalTop = 0;
				var modalLeft = 0;
				var diff = 0;
				// Top Position
				var modalPosition = 'top';
					
				if ((modalHeight + modalAngleSize) < targetOffset.top) {
				    // On top
				    modalTop = targetOffset.top - modalHeight - modalAngleSize;
				}
				else if ((modalHeight + modalAngleSize) < windowHeight - targetOffset.top - targetHeight) {
				    // On bottom
				    modalPosition = 'bottom';
				    modalTop = targetOffset.top + targetHeight + modalAngleSize;
				}
				else {
				    // On middle
				    modalPosition = 'middle';
				    modalTop = targetHeight / 2 + targetOffset.top - modalHeight / 2;
				    diff = modalTop;
				    if (modalTop < 0) {
					modalTop = 5;
				    }
				    else if (modalTop + modalHeight > windowHeight) {
					modalTop = windowHeight - modalHeight - 5;
				    }
				    diff = diff - modalTop;
				}
				// Horizontal Position
				if (modalPosition === 'top' || modalPosition === 'bottom') {
				    modalLeft = targetWidth / 2 + targetOffset.left - modalWidth / 2;
				    diff = modalLeft;
				    if (modalLeft < 5) modalLeft = 5;
				    if (modalLeft + modalWidth > windowWidth) modalLeft = windowWidth - modalWidth - 5;
				    if (modalPosition === 'top') modalAngle.addClass('on-bottom');
				    if (modalPosition === 'bottom') modalAngle.addClass('on-top');
				    diff = diff - modalLeft;
				    modalAngle.css({left: (modalWidth / 2 - modalAngleSize + diff) + 'px'});
				}
				else if (modalPosition === 'middle') {
				    modalLeft = targetOffset.left - modalWidth - modalAngleSize;
				    modalAngle.addClass('on-right');
				    if (modalLeft < 5) {
					modalLeft = targetOffset.left + targetWidth + modalAngleSize;
					modalAngle.removeClass('on-right').addClass('on-left');
				    }
				    if (modalLeft + modalWidth > windowWidth) {
					modalLeft = windowWidth - modalWidth - 5;
					modalAngle.removeClass('on-right').addClass('on-left');
				    }
				    modalAngle.css({top: (modalHeight / 2 - modalAngleSize + diff) + 'px'});
				}

				// Apply Styles
				modal.css({top: modalTop + 'px', left: modalLeft + 'px'});
			}
			
			viewSizePopover();
			
			//phone no resize
			if( !viewUtils.Mobile ){
    			$(window).on('resize', viewSizePopover);
    			modal.on('close', function () {
    			    $(window).off('resize', viewSizePopover);
    			});
			}			
			
			this.openModal(modal);
		},
		
		openModal : function(modal, noRemoveOverlayClose){
			var isPopup = modal.hasClass('view-popup');
			var isPopover = modal.hasClass('view-popover');
			var overlay = isPopup ? $('.view-popup-overlay') : $('.view-modal-overlay');
			var modalOutType = ( modal.attr('data-popup-direction') == "down" ) ? "modal-down-out" : "modal-up-out";
			
			if( overlay.length > 0 ){
				if( noRemoveOverlayClose ) overlay.addClass('view-modal-overlay-visible modal-no-remove');
				else overlay.addClass('view-modal-overlay-visible');
			}

			modal.trigger('addons.view-open', modal);
			this.isModal = true;
			setTimeout(function(){
				modal.removeClass(modalOutType).addClass('modal-in').transitionEnd(function (e) {
					modal.trigger('addons.view-opened', modal);
				});
			}, 100);
		},
		
		closeModal : function(modal){
			var that = this;			
			modal = ( modal ) ? $(modal) : $('.view-popup.modal-in');			
			
			if( modal.length <= 0 ) return false;
			
			var isPopover = modal.hasClass('view-popover');
			var isPopup = modal.hasClass('view-popup');
			var removeOnClose = modal.hasClass('remove-on-close');
			var overlay = isPopup ? $('.view-popup-overlay') : $('.view-modal-overlay');
			var modalOutType = ( modal.attr('data-popup-direction') == "down" ) ? "modal-down-out" : "modal-up-out";
						
			overlay.removeClass('view-modal-overlay-visible');
			
			that.isOverLayoutHide = false;
			
			this.isActive = true;
			if( isPopover == false && removeOnClose == false )
				modal.trigger('addons.view-close', modal);
				
			if(!isPopover){
				modal.removeClass('modal-in').addClass(modalOutType).transitionEnd(function (e) {
					modal.trigger('addons.view-closed', modal);
					
					if (isPopup) modal.removeClass(modalOutType).hide();
					
					that.isModal = false;
					that.isActive = false;
				});
			}else{
				
				modal.removeClass('modal-in '+modalOutType).trigger('addons.view-closed').hide();
				if (removeOnClose) modal.remove();
				
				if( $('.popup-overlay').length != 0 || $('.modal-overlay').length != 0 ) that.isModal = true;
				else that.isModal = false;
				
				that.isActive = false;
			}
		},
		
		viewpanel : function(clicked){
			var that = this,
				position = (clicked.data('panel') === 'right') ? 'right' : 'left';
			
			if( clicked.data('href') != undefined ){
				var href = viewPath + clicked.attr('data-href');
				htmlview.getHtml(href, function(data){
					var _panel = document.createElement('div');
					_panel.innerHTML = $.trim(data);
					if (_panel.childNodes.length > 0) {
						var panel = _panel.childNodes[0];
						$('.view-panel-' + position).html(panel);
					}else return false;
					
					that.openPanel(position);					
				});
				return false;
			}
			
			this.openPanel(position);
		},
		
		openPanel : function(position){
			var that = this;
			if( !this.allowsPanelOpen ) return false;
			
			var panel = $('.view-panel-' + position);
			if (panel.length === 0 || panel.hasClass('active')) return false;
			var size = ( this.clicked != null ) ? this.clicked.data('size') : null;
			
			if( size ) panel.addClass('panel'+size).attr('data-size', size);
			
			this.closePanel();
			this.allowPanelOpen = false;
			var effect = panel.hasClass('panel-reveal') ? 'reveal' : 'cover';
			panel.css({display: 'block'}).addClass('active');
			panel.trigger('addons.view-panel-open', panel);
			
			// Trigger reLayout
			var clientLeft = panel[0].clientLeft;
			// Transition End;
			//var transitionEndTarget = effect === 'reveal' ? $('.' + that.view.viewsClass) : panel;
			var openedTriggered = false;
            
            function panelTransitionEnd(){
				panel.transitionEnd(function (e) {
					if ($(e.target).is(panel)) {
						if (panel.hasClass('active')) {
							panel.trigger('addons.view-panel-opened');
						}else {
							panel.trigger('addons.view-panel-closed');
						}
						that.allowsPanelOpen = true;
						that.clicked = null;
					}
					else panelTransitionEnd();
				});
			}
			            
			panelTransitionEnd();
			$('#wisebook_contents').addClass('with-panel-' + position + '-' + effect);
		},
		
		closePanel : function(){
			var that = this,
				activePanel = $('.view-panel.active');
				
			if (activePanel.length === 0) return false;
			
			var effect = activePanel.hasClass('panel-reveal') ? 'reveal' : 'cover';
			var position = activePanel.hasClass('view-panel-left') ? 'left' : 'right';
			activePanel.removeClass('active');
			
			activePanel.trigger('close');
			activePanel.transitionEnd(function () {
				if (activePanel.hasClass('active')) return;
				activePanel.css({display: ''});
				activePanel.trigger('closed');
				$('#wisebook_contents').removeClass('panel-closing');
				var size = activePanel.data("size");
				
				if( size ) activePanel.removeClass( 'panel'+size ).removeAttr( "data-size" );
				
				that.allowPanelOpen = false;
				that.clicked = null;
			});
				
			$('#wisebook_contents').addClass('panel-closing').removeClass('with-panel-' + position + '-' + effect);
		},
		
		/*
        animateMenu : function( only ){
		    var that = this;
		    
		    var elem = $('.menu-etc-list-block'),
		        direction;
		        
		    if( elem.hasClass('element-on-down') ){
                direction = 'down-to-up';
		    }else{
    		    if( only ) return false;
    		    direction = 'up-to-down';
		    }
		    
            this.isActive = true;
            $('#btn-menu-etc').toggleClass('active');
                		
    		if( direction == "down-to-up" ){
        		elem.removeClass('element-on-down').transitionEnd(function(){
            		that.isActive = false;
        		});
    		}else if( direction == "up-to-down" ){
    		    elem.addClass('element-on-down').transitionEnd(function(){
        		    that.isActive = false;
    		    });
    		}
		},
        */
		
		/**************************************
			tools contact
		***************************************/
		wisebookContact : function(filter){
			
			var contactObj = ( filter == 'btn-contact' ) ? PARAM.bookInfo.custom_pc[1] : PARAM.bookInfo.custom_pc[0];
						
			if( contactObj.enabled != 1 ) return false;
			
			$(document).trigger(viewdefind.VIEW_NAV_AUTOHIDE_CLEAR);
			if( contactObj.type == 'link' ){
				var url = contactObj._value;
				if( url.match(/^(http|https):\/\//i) == null ) url = 'http://'+url;
				
				PARAM.openExtenal(url);
			}else htmlview.gotopage(contactObj._value);
		},
		
		wisebooktools : function(elem){
		    if( PARAM.nowBusy == "crop" ){
		        $(elem).removeClass("active");
		        $(document).trigger(viewdefind.CROP_MODE_OPEN);
    		    return false;
		    }
		    
			if( this.isActive || PARAM.nowBusy != "" ) {
			    var fadeMessageText = ( PARAM.nowBusy == "memo" ) ? PARAM.viewLang.memoControllClickErrMsg : PARAM.viewLang.penControllClickErrMsg;
                $(document).trigger(viewdefind.VIEW_MESSAGE_FADE_TYPE, fadeMessageText);
			    return false;
            }
            
			$(document).trigger(viewdefind.VIEW_NAV_AUTOHIDE_CLEAR);
						
			var tools = elem.data('tool'),
			    closeModal = elem.data('close'), 
				popup = '.view-popup-'+tools;
			
			if( closeModal != "" && this.isModal ){
    			var _modal = $(closeModal+'.modal-in');
    			if( _modal.length > 0 ) this.closeModal(_modal);
			}
			
			switch(tools){
				case 'crop':
				    $(elem).addClass("active");
				    $(document).trigger(viewdefind.CROP_MODE_OPEN);
				    PARAM.nowBusy = tools;
				    
				break;
				
				case 'pdf' :
					var pdfhref;
					if (appFlag) {
						pdfhref = PARAMLIBRARY.createViewInfo.objcontents.stream_url;
					}
					else {
						pdfhref = viewInfo.bookurl;
					}
					pdfhref +=PARAM.bookInfo.config.pdfdown+'?d='+new Date().getTime();
					PARAM.openExtenal(pdfhref);
				break;
				
				case 'full' :
					this.bookFullScreen();
				break;
				
				case 'home' :
				    window.open(elem.attr('data-href'), '_self');
				break;
				
				case 'print':
				case 'pdfdivision':
					printerProc.setType(tools);
					$('#tool-printer').css('display', 'block');
				break;
				
				case 'toc':case 'thumb':case 'search':case 'memo':
				case 'pen':case 'bookmark':case 'share':case 'help': case 'productsearch':
					PARAM.nowBusy = tools;
					
					if(tools == 'search'){
						setTimeout(function(){
							h5applib.keyboardShow();
							$('#search-textarea').focus();
						}, 700);
                    }

					if( PARAM.autoslide ) htmlview.autopageplay();
					if( PARAM.transformInfo.scale == 1 && tools != 'pen' && tools != 'memo' ) htmlview.viewActionDisable();

                    //2021-08-27 sns共有はnativeからosの標準機能を呼ぶ
                    if(tools=='share'){
                        console.log("atempt to call sns api");
                        this.isActive =false;
                        PARAM.nowBusy = "";
                        let oc = PARAMLIBRARY.createViewInfo.objcontents;
                        let url = oc.serverurl+ '/html/'+oc.author + '/' + oc.bookid+ '/#' + PARAM.currentpage;
                        $webApiRouter.shareForSNS(url,function(o){
                            console.log("done to call sns api");
                        });
                    }else{
                        this.viewpopup(popup);
                    }

					//this.viewpopup(popup);
				break;
			}
			
			if( viewUtils.device == "pc" 
			 && PARAM.isPcNaviHideAction 
			 && PARAM.nowBusy != "" 
			 && PARAM.nowBusy != "memo" 
			 && PARAM.nowBusy != "pen"  )
             {
			    PARAM.wisebookToobarNavigater.css("display", "none");
             }
			
            //if( PARAM.nowBusy != "" && PARAM.nowBusy != "memo" && PARAM.nowBusy != "pen" ){
		    //if( !PARAM.wisebookToobarNavigater.hasClass("view-order-hidden") ) PARAM.wisebookToobarNavigater.addClass('view-order-hidden').css("display", "none");
		},
		
		bookFullScreen : function(){
			if(this.fullstatus){
				if (document.exitFullscreen) {
					document.exitFullscreen();
				}
				else if (document.msExitFullscreen) {
					document.msExitFullscreen();
				}
				else if (document.mozCancelFullScreen) {
					document.mozCancelFullScreen();
				}
				else if (document.webkitCancelFullScreen) {
					document.webkitCancelFullScreen();
				}
				
				this.fullstatus = false;
			}else if(!this.fullstatus){
				var el = document.body;
				
				if (el.requestFullscreen) {
				  	el.requestFullscreen();
				  	this.fullstatus = true;
				}
				else if (el.msRequestFullscreen) {
				  	el.msRequestFullscreen();
				 	this.fullstatus = true;
				}
				else if (el.mozRequestFullScreen) {
			
					el.mozRequestFullScreen();
					this.fullstatus = true;
		    	    }
				else if (el.webkitRequestFullscreen) {
					var webkitOnly = document.documentElement;
					webkitOnly.webkitRequestFullscreen();
					this.fullstatus = true;
				}else {
				    viewMessageProc.alert( PARAM.viewLang.fullSizeIeErr, PARAM.viewLang.alertTitle );
				}
			}
		},

		busyDestroy : function(){
		    //if( !PARAM.wisebookToobarNavigater.hasClass("view-order-hidden") ) PARAM.wisebookToobarNavigater.addClass('view-order-hidden').css("display", "none");
			htmlview.viewActionEnable();
			PARAM.nowBusy = '';
			
			if( viewUtils.device == "pc" && PARAM.isPcNaviHideAction ){
			    PARAM.wisebookToobarNavigater.css("display", "block");
             }
		},
		
		loadingImgView: function (viewType) {	    	
	    	if (viewType == 'show'){
				/*
var tempDiv = '<div class="processing-wrap">'
							+	'<div id="processing-animation">'
							+		'<div id="circularG">'
							+			'<div id="circularG_1" class="circularG"></div>'
							+			'<div id="circularG_2" class="circularG"></div>'
							+			'<div id="circularG_3" class="circularG"></div>'
							+			'<div id="circularG_4" class="circularG"></div>'
							+			'<div id="circularG_5" class="circularG"></div>'
							+			'<div id="circularG_6" class="circularG"></div>'
							+			'<div id="circularG_7" class="circularG"></div>'
							+			'<div id="circularG_8" class="circularG"></div>'
							+		'</div>'
							+	'</div>'
							+ '</div>';
*/
				
				var tempDiv = '<div class="processing-wrap">'
				                +'<img class="indicator-loading-img" src="'+viewPath+'v2_images/common/loading.gif"/>'
				             + '</div>';		
		    	PARAM.wisebook.append(tempDiv);
	    	}else{
		    	$('.processing-wrap').remove();
	    	}
		},
		
		mb_strimwidth : function(str,start,width,trimmarker){
			if(typeof trimmarker === 'undefined') trimmarker='';
			var trimmakerWidth = this.mb_strwidth(trimmarker),i=start,l=str.length,trimmedLength=0,trimmedStr='';
			
			for(;i<l;i++){
				var charCode=str.charCodeAt(i), c=str.charAt(i), charWidth=this.mb_strwidth(c), next=str.charAt(i+1), nextWidth=this.mb_strwidth(next);
				trimmedLength += charWidth;
				trimmedStr += c;
				if(trimmedLength+trimmakerWidth+nextWidth>width){
					trimmedStr += trimmarker;
					break;
				}
			}
			return trimmedStr;
		},
		
		mb_strwidth : function(str){
			var i=0,l=str.length,c='',length=0;
			for(;i<l;i++){
				c=str.charCodeAt(i);
				if(0x0000<=c&&c<=0x0019){
					length += 0;
				}else if(0x0020<=c&&c<=0x1FFF){
					length += 1;
				}else if(0x2000<=c&&c<=0xFF60){
					length += 2;
				}else if(0xFF61<=c&&c<=0xFF9F){
					length += 1;
				}else if(0xFFA0<=c){
					length += 2;
				}
			}
			return length;
		},
		
		destroy : function(){
			var events = [
				"addons.view-opened",
				"addons.view-open",
				"addons.view-close",
				"addons.view-panel-open",
				"addons.view-panel-opened",
				"addons.view-panel-closed"
			];
			
			for( var i in  events){
				$(document).unbind(events[i]);
			}
			
			if( viewUtils.device === 'pc' ){
				$('#zoomlevel li, #btn-zoomin, #btn-zoomout, #btn-bookauto').off("click");
				$('#naviMoveNumText').unbind("keypress");
				
				$(document).off("wisebook-zoom.animation-end");
			}

			//module destroy evnets
			$(document).trigger(viewdefind.VIEW_DESTROY);

			delete mediaControl;
			delete wisebookmemo;
			delete wisebookpen;
			delete viewMessageProc;
		}
	};
	
	/**************************************
	 message alert, confim, fadeIn-out
	***************************************/
    viewMessageProc = {
	    isModalMessage : false,
    	modalButtonOk		: 'OK',
		modalButtonCancel	: 'CANCEL',
		
		viewMessageEvent : function(){
		    var that = this;
            $(document).bind(viewdefind.VIEW_MESSAGE_FADE_TYPE, function(e, text){
                that.fadeMessage(text);
            });
		},
		
		openMessageModal : function(messageModal){
		    if( this.isModalMessage ) return false;
            
    		modal =  ( typeof( messageModal ) == "string" ) ?  $(messageModal) : messageModal;
			modal.css({marginTop: - Math.round(modal.outerHeight() / 2) + 'px'});
			
			if ( $('.view-modal-overlay').length === 0 ) {
				PARAM.wisebook.append('<div class="view-modal-overlay"></div>');
			}
			
			$('.view-modal-overlay').addClass('view-modal-overlay-visible');			
			
			this.isModalMessage = true;
			setTimeout(function(){
				modal.removeClass('modal-out').addClass('modal-in').transitionEnd(function (e) {
					modal.trigger('opened', modal);
				});
			}, 100);
		},
		
		closeMessageModal : function( messageModal ){
		    var  that = this;
            
    		modal = $(messageModal || '.view-message-modal.modal-in');
    		$('.view-modal-overlay').removeClass('view-modal-overlay-visible');
    		ADDONS.isOverLayoutHide = false;
    		
    		modal.removeClass('modal-in').addClass('modal-out').transitionEnd(function (e) {
    		    modal.removeClass('modal-out').hide().remove();
    		    that.isModalMessage = false;
    		});	
		},
		
		alert : function(text, title, callbackOk){
		    var that = this;
		    ADDONS.isOverLayoutHide = true;
		    
            if (typeof title === 'function') {
                callbackOk = arguments[1];
                title = undefined;
            }
            
            return this.messageModal({
                text: text || '',
                title: typeof title === 'undefined' ? 'WISEBOOK' : title,
                buttons: [ {text: that.modalButtonOk, bold: true, onClick: callbackOk} ]
            }); 
		},
		
		confirm : function(text, title, callbackOk, callbackCancel){
		    var that = this;
		    ADDONS.isOverLayoutHide = true;
		
    		if (typeof title === 'function') {
                callbackCancel = arguments[2];
                callbackOk = arguments[1];
                title = undefined;
            }
            
            return this.messageModal({
                text: text || '',
                title: typeof title === 'undefined' ? 'WISEBOOK' : title,
                buttons: [
                    {text: PARAM.viewLang.bookMarkdelete_cancel, onClick: callbackCancel},
                    {text: that.modalButtonOk, bold: true, onClick: callbackOk}
                ]
			});
		},
		
		fadeMessage : function( text ){
    		 var that = this;  		 
    		 $('.view-message-fade').remove();
    		 var modalTemplate = '<div class="view-message-fade">' 
							+	'<div class="view-message-fade-inner">' 
							+		'<span>'+text+'</div>' 
							+	'</div>' 
							+'</div>';
                        
            PARAM.wisebook.append(modalTemplate);
            var fadeElem = $('.view-message-fade');
            fadeElem.css({marginTop: - Math.round(fadeElem.outerHeight() / 2) + 'px'});
            
            setTimeout(function(){
                fadeElem.fadeOut(300, function(){
                    $(this).remove();
                });
            }, 1800);
			
			return false;
		},
		
		messageModal : function( params ){
		    var that = this;
		
    		var modalTemplate = '<div class="view-message-modal {{noButtons}}">' 
							+	'<div class="view-modal-inner">' 
							+		'{{if title}}<div class="view-message-title">{{title}}</div>{{/if title}}' 
							+		'<div class="view-message-text">{{text}}</div>' 
							+		'{{afterText}}' 
							+	'</div>' 
							+	'<div class="view-message-buttons">{{buttons}}</div>' 
							+'</div>';
							
            var _modalTemplateTempDiv = document.createElement('div');
            params = params || {};
            
            var buttonsHTML = '';
            if (params.buttons && params.buttons.length > 0) {
                for (var i = 0; i < params.buttons.length; i++) {
                    buttonsHTML += '<span class="view-message-button' + (params.buttons[i].bold ? ' modal-button-bold' : '') + '">' + params.buttons[i].text + '</span>';
                }
            }
            
            if (!params.title) {
    			modalTemplate = modalTemplate.split('{{if title}}')[0] + modalTemplate.split('{{/if title}}')[1];
    		}else {
    			modalTemplate = modalTemplate.replace(/{{if\ title}}/g, '').replace(/{{\/if\ title}}/g, '');
    		}
            
            
            var modalHTML = modalTemplate
		            .replace(/{{title}}/g, params.title || '')
		            .replace(/{{text}}/g, params.text || '')
		            .replace(/{{afterText}}/g, params.afterText || '')
		            .replace(/{{buttons}}/g, buttonsHTML)
		            .replace(/{{noButtons}}/g, !params.buttons || params.buttons.length === 0 ? 'view-message-no-buttons' : '');
		
            _modalTemplateTempDiv.innerHTML = modalHTML;
            
           var messageModal = $(_modalTemplateTempDiv).children();
           PARAM.wisebook.append(messageModal[0]);
           
           messageModal.find('.view-message-button').each(function (index, el) {
    			$(el).hammer({tap_max_touchtime:200}).on("tap", function (e) {
    				if (params.buttons[index].close !== false) {
    					that.closeMessageModal(messageModal);
    				}
    				if (params.buttons[index].onClick) params.buttons[index].onClick(messageModal, e);
    				if (params.onClick) params.onClick(messageModal, index);
    			});
    		});
           
           this.openMessageModal(messageModal);
		}
	};
	
	/**************************************
	 navigator
	***************************************/
	var navigatorProc = {
		rangeElem : null,
		tipElem : null,
		pcdbthumb1 : null,
		pcdbthumb2 : null,
		pcsinglethumb : null,
		tipSpan : null,
		isNavDrag : false,
		navWidth : 0,
		max : 0,
		
		init : function(){
			this.rangeElem = $("#view-slide-range");
			if( viewUtils.device == "pc" ){
    			this.tipElem = $('#range-tip');
    			if( PARAM.viewMode == "twopage" ) {
        			this.pcdbthumb1 = this.tipElem.find('.range-tip-item-thumb-double1');
        			this.pcdbthumb2 = this.tipElem.find('.range-tip-item-thumb-double2');
        			this.tipElem.find('.range-tip-item-thumb-single').remove();
    			}else{
    			    this.pcsinglethumb = this.tipElem.find('.range-tip-item-thumb-single');
        			this.tipElem.find('.range-tip-item-thumb-double1, .range-tip-item-thumb-double2').remove();
    			}
			}else{
			    this.tipElem = $('#page-track-message-bg');
                this.tipSpan = this.tipElem.find('.page-track-message span');
			}
						
			this.navWidth = this.rangeElem.width();
			this.max = PARAM.bookInfo.pages;
			
			this.rangeElem.css('direction', PARAM.direct).attr({min : 1, max:this.max, dir: PARAM.direct});
			this.navievent();
		},
		
        slideLineColorChange : function(obj){
            var that = this;
            var val = (obj - that.rangeElem.attr('min')) / (that.rangeElem.attr('max') - that.rangeElem.attr('min'));
                              
            var direct = 'left top, right top,';
            if(PARAM.direct == 'rtl') direct = 'right top, left top,';
                              
            that.rangeElem.css('background-image',
                '-webkit-gradient(linear, ' + direct
                + 'color-stop(' + val + ', #007aff), '
                + 'color-stop(' + val + ', #C5C5C5))'
            );
        },
                              
		navievent : function(){
			var that = this;
			
			$(document).bind(viewdefind.PAGE_BEFORE_EVENT, function(e, obj){
			    if( viewUtils.device == "pc" ){
			        var temppage = PARAM.getPageNumToLabel(obj.page);
			        $('#naviMoveNumText').val( temppage );
    			    that.pcRangeTipThumb(obj.page);
			    }
    			
    			that.rangeElem.val(obj.page);
				that.navibuttonDisable(obj.page);
                that.slideLineColorChange(obj.page);
			});
			
			$(document).bind(viewdefind.NAV_MOVE_DISABLE, function(e, flag){
				if( flag ) that.rangeElem[0].disabled = true;
				else that.rangeElem[0].disabled = false;
			});
			
			
			$(document).bind(viewdefind.ADDONS_RESIZE, function(e){
				that.navWidth = that.rangeElem.width();
			});
			
			//navi destroy event
			$(document).bind(viewdefind.VIEW_DESTROY, function(e, val){
				that.destroy();
			});
			
			this.rangeElem.on( "dragstart drag dragend tap", function(e){
				switch(e.type){
					case "dragstart" :
						that.isNavDrag = false;
						that.tipElem.css("display", "block");
						
						if( PARAM.autoHideTimer )
							$(document).trigger(viewdefind.VIEW_NAV_AUTOHIDE_CLEAR);
					break;
					
					case "drag" :
						that.isNavDrag = true;
						if( viewUtils.device == "pc" )
							that.moveTipPC($(this));
						else 
							that.moveTipMobile( $(this).val() );
					break;
					
					case "dragend" :
						if( !that.isNavDrag ) return false;
						that.isNavDrag = false;
						that.tipElem.css("display", "none");
						
						ADDONS.sendGotopage( parseInt(that.rangeElem.val() ) );
					break;
					
					default :
						if( that.isNavDrag ) return false;
						that.tipElem.css("display", "none");
						ADDONS.sendGotopage( parseInt(that.rangeElem.val() ) );
					break;
				}
			} );
		},
		
		moveTipMobile : function(page){
			var nowpage = ( PARAM.pageNumberType ) ? PARAM.bookInfo.labels[page-1] : page;
			this.tipSpan.text( nowpage+'/'+PARAM.bookInfo.pages+' '+PARAM.viewLang.sliderPageLang );
		},
		
		moveTipPC : function(el){
			if( this.isNavDrag ){
				var page = el.val(),
				    newPoint = (page - el.attr("min")) / (el.attr("max") - el.attr("min")),
					offset = 20 * newPoint, //range bool size * newpoint
					newPlace;

				if (newPoint < 0) { newPlace = 0; }
				else if (newPoint > 1) { newPlace = width; }
				else { newPlace = this.navWidth * newPoint - offset; }
				
				var dr = ( PARAM.direct == 'ltr' ) ? 'left' : 'right';				
				this.tipElem.css(dr, newPlace);
				this.pcRangeTipThumb(page);
			}
		},
		
		pcRangeTipThumb : function(page){
		    if( PARAM.viewMode == 'twopage' ){
		        var src1, src2,
		            pointnum = PARAM.getPointnum(page),
		            leftpage = PARAM.doublePair[pointnum].left,
					rightpage = PARAM.doublePair[pointnum].right;
				
				if( leftpage != 0 ){
    				var pageObj = htmlview._pages[leftpage-1];
    				src1 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
				}else{
				    src1 = viewPath+'v2_images/common/transparency_img.png';
				}
				this.pcdbthumb1.find('img').attr('src', src1);
				
				if( rightpage != 0 ){
				    var pageObj = htmlview._pages[rightpage-1];
    				src2 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
				}else{
    				src2 = viewPath+'v2_images/common/transparency_img.png';
				}
				this.pcdbthumb2.find('img').attr('src', src2);
		    }else{
    		    var pageObj = htmlview._pages[page-1];
    		    var src = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
    		    this.pcsinglethumb.find('img').attr('src', src);
		    }
		},
		
		navibuttonDisable : function(page){
			if( page <= 1 ) {
			    $('.nav-leftend, .nav-left').addClass('disable');
			    $('.prev-button').addClass('view-display-none');
            }else {
                $('.nav-leftend, .nav-left').removeClass('disable');
                $('.prev-button').removeClass('view-display-none');
            }
			
			if( page == PARAM.bookInfo.pages ) {
			    $('.nav-rightend, .nav-right').addClass('disable');
			    $('.next-button').addClass('view-display-none');
			    
			    if( viewUtils.device === 'pc' ) {
					$("#btn-bookauto").addClass('disable');
					if(  PARAM.autoslide ) {
						htmlview.autopageplay();
					}
				}
			}else {
			    $('.nav-rightend, .nav-right').removeClass('disable');
			    $('.next-button').removeClass('view-display-none');
			    if( viewUtils.device === 'pc' && !PARAM.autoslide ) $("#btn-bookauto").removeClass('disable');
            }		
		},
		
		destroy : function(){
			this.rangeElem.unbind('dragstart drag dragend');
		}
	};
	
	/**************************************
	 toc
	***************************************/
	var tocProc = {
		tempElement : document.createElement('div'),
		defaults :{
			listNodeName    : 'ol',
            itemNodeName    : 'li',
            rootClass       : 'dd',
            listClass       : 'dd-list',
            itemClass       : 'dd-item',
            collapsedClass  : 'dd-collapsed'
		},
		
		init : function(){
			this.opentoc = PARAM.bookInfo.config.opentoc;
			this.tocTable =  $('<ol class="dd-list"/>').appendTo("#view-toc-table");
			this.tocEvent();
		},
		
		tocEvent : function(){
			var that = this;
			$(document).bind(viewdefind.TOC_CREATE, function(){ that.createToc() });
			
			PARAM.wisebook.on('tap', '.toc-button, .dd-handle', function(e){
				if( $(this).hasClass('toc-button') ){
					var action = $(this).data('action');
					itemli   = $(this).parent(that.defaults.itemNodeName);
					
					if (action === 'collapse') 
	                    that.collapseItem(itemli);
	                if (action === 'expand') 
	                    that.expandItem(itemli);
				}else{
					var li = $(this).closest('li');
					if( li.data('url') != '0' ){
					    PARAM.openInside(li.data('url'));
					}else if( li.data('bookchange') != '0' &&  PARAM.bookInfo.bookid != li.data('bookchange') ){
						//else window.open(tocHost+author+'/'+chageBookValue+'/?#'+gotoPageValue, "_self");
					}else {
						var page = li.data('page');
						if( page == 0 ) return false;
						ADDONS.sendGotopage(page);
					}
				}
			});
		},
		
		createToc : function(){
			var that = this;
			var tocData = PARAM.tocjsonInfo;
			var nowol = null;
			var parentNoneNo = 1;
			
			var olcreate = function(elem, addelem, group){
				var tmpElemStr = '<button data-action="collapse" type="button" class="collapse-expand toc-button" style="display: block;">Collapse</button>'
							+ 	'<button data-action="expand" type="button" class="collapse-expand toc-button" style="display: none;">Expand</button>';
				elem.prepend(tmpElemStr);
				
			
				var olelm = $('<ol class="dd-list"/>').appendTo(elem);
				addelem.attr('data-subparent', group);
				
				olelm.append(addelem);
			};
			
			var samelicreate = function(sameElem, addelem, group){
				addelem.attr('data-subparent', group);
				sameElem.append(addelem);
			};
				
			for( var t in tocData ){
				var itemObj = tocData[t], parentIndex = '', prevlevel,nowlevel;
						
				var templi = this.liitemCreate(itemObj);
				
				if( itemObj.level == 1 || itemObj.level == "" ) {
					templi.attr('data-parent', parentNoneNo++);
					this.tocTable.append(templi);
				}else{
					prevlevel = tocData[t-1].level;
					nowlevel = tocData[t].level;
					
					if(prevlevel < nowlevel) {
						var parentElem;
						var group;
						if( prevlevel == 1 ) {
							parentElem = this.tocTable.find('[data-parent="'+(parentNoneNo-1)+'"]');
							group = (parentNoneNo-1)+templi.attr('data-level');
						}else{
							var subparent = (parentNoneNo-1)+''+prevlevel;
							group = (parentNoneNo-1)+templi.attr('data-level');
							parentElem = this.tocTable.find('[data-subparent="'+subparent+'"]:last');
						}
						olcreate(parentElem, templi, group);
					}else {
						var subparent = ( prevlevel == nowlevel ) ? (parentNoneNo-1)+''+prevlevel : (parentNoneNo-1)+''+nowlevel;
						group = (parentNoneNo-1)+templi.attr('data-level');
						parentElem = this.tocTable.find('[data-subparent="'+subparent+'"]:last').closest('ol');
						samelicreate(parentElem, templi, group);
					}
				}
			} //for end
	
			this.inittocsetting();
		},
		
		inittocsetting : function(){
			var that = this;
		
			if( this.opentoc == 0 ) this.expandAll();
			else if( this.opentoc == 1 ) this.collapseAll();
			else {
				var elem = this.tocTable.find('[data-level="'+(this.opentoc-1)+'"]').parent('ol');
				elem.find('li').each(function(){
					that.collapseItem($(this));
				});
				//elem.elem()
			}
		},
		
		liitemCreate : function(obj){
			var pageLebel =  ( obj.pagelabel != null || PARAM.pageNumberType ) ? PARAM.bookInfo.labels[obj.page-1] : obj.page,
				tocBookid =  ('book' in obj) ? obj.book : '0',
				tocUrl = ('url' in obj )? obj.url : '0';
			
			if( obj.page == 0 ) pageLebel = '';
			
			if( tocUrl != '0' ) pageLebel = '';

			this.tempElement.innerHTML = '<li class="dd-item"/>';
			var liitem = htmlview.findElement('li', this.tempElement);
			
			liitem.attr({ 'data-level' : obj.level, 'data-bookchange' : tocBookid, 'data-url' : tocUrl, 'data-page' : obj.page });
			liitem.append('<div class="dd-handle">  <div class="toc-list"> <div class="toc-title">'+obj.title+'</div> <div class="toc-number">'+pageLebel+'</div> </div></div>');
			//<div style="width:30px;height : 30px;"></div>
			return liitem;
		},
		
		expandItem : function(li){
			//open
			li.removeClass(this.defaults.collapsedClass);
            li.children('[data-action="expand"]').hide();
            li.children('[data-action="collapse"]').show();
            li.children(this.defaults.listNodeName).show();
		},
		
		collapseItem : function(li){
			//close
			var lists = li.children(this.defaults.listNodeName);
            if (lists.length) {
                li.addClass(this.defaults.collapsedClass);
                li.children('[data-action="collapse"]').hide();
                li.children('[data-action="expand"]').show();
                li.children(this.defaults.listNodeName).hide();
            }
		},
		
		expandAll : function(){
			var that = this;
            this.tocTable.find(this.defaults.itemNodeName).each(function() {
                that.expandItem($(this));
            });
		},
		
		collapseAll : function(){
			var that = this;
            this.tocTable.find(this.defaults.itemNodeName).each(function() {
                that.collapseItem($(this));
            });
		}
	};
	
	
	/**************************************
	 tumbanil
	***************************************/
	var thumbnailProc = {
		thumbElem : null,
		itemElement : document.createElement('div'),
		
		init : function(){
			var that = this,
				url = ( PARAM.bookInfo.config.single == 0 ) ? viewPath + 'v2_viewhtml/items/thumb/double-thumb.html' : viewPath + 'v2_viewhtml/items/thumb/single-thumb.html';
				
			this.thumbElem = $('#view-thumb-table');
			
			htmlview.getHtml(url, function(data){
				that.itemElement.innerHTML = data;
				$(that.itemElement).find('img').attr('src', viewPath+'v2_images/common/transparency_img.png');
				
				that.createThumb();
			});
			that.thumbEvent();
		},
		
		thumbEvent : function(){
			var that = this;
			$(document).bind(viewdefind.VIEW_DESTROY, function(){ that.destroy() });
			
			$(document).bind(viewdefind.PAGE_AFTER_EVENT, function(e, obj){ that.thumbChangePage(obj.page); });
			PARAM.wisebook.on('tap', '.btn-thumb-status', function(){ 
				if( $(this).hasClass('thumb-noimage') ) return false;
				
				ADDONS.sendGotopage( $(this).data('page') ); 
			});
			
			if( viewUtils.browser == 'msie' ){
				PARAM.wisebook.on('mouseenter mouseleave', '.view-item-thumb',  function(e){
					if( PARAM.nowBusy != "thumb" ) return false;
				
					if( $(this).find('.btn-thumb-status').hasClass('selected') ) return false;
					if( $(this).find('.btn-thumb-status').hasClass('thumb-noimage') ) return false;
					
					if(e.type == 'mouseenter') $(this).find('.btn-thumb-status').addClass('hover');
					else $(this).find('.btn-thumb-status').removeClass('hover');
				})
			}
		},
		
		thumbChangePage : function(page){
			$('.btn-thumb-status').removeClass('selected');
			$('.thumb-pageno'+page).addClass('selected');
		},
		
		createThumb : function(){
			var _tempElement = document.createElement('div');
						
			if( PARAM.bookInfo.config.single == 0 ){
				//two page
				var pageObj;
				for( var d in PARAM.doublePair ){
					var pairArr = PARAM.doublePair[d];
					
					_tempElement.innerHTML = '';
					_tempElement.innerHTML = this.itemElement.innerHTML;
					
					var findBoxElem = htmlview.findElement('.double-thumb-items', _tempElement);
                    
					if( pairArr.left != 0 ){
						pageObj = htmlview._pages[pairArr.left-1];
						var src1 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
						pageObj.thumbload.check = true;
						findBoxElem.find('.view-item-thumb-double1 img').attr('src', src1);
						findBoxElem.find('.view-item-thumb-double1 .view-item-title span').text(pageObj.label);
						findBoxElem.find('.view-item-thumb-double1 .btn-thumb-status').addClass('thumb-pageno'+pageObj.countpage).attr('data-page', pageObj.countpage);
						
					}else{
					    findBoxElem.find('.view-item-thumb-double1 img').attr('src', viewPath+'v2_images/common/transparency_img.png');
						findBoxElem.find('.view-item-thumb-double1 .btn-thumb-status').addClass('thumb-noimage');
					}
					
					if( pairArr.right != 0 ){
						pageObj = htmlview._pages[pairArr.right-1];
						var src2 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
						pageObj.thumbload.check = true;
						findBoxElem.find('.view-item-thumb-double2 img').attr('src', src2);
						findBoxElem.find('.view-item-thumb-double2 .view-item-title span').text(pageObj.label);
						findBoxElem.find('.view-item-thumb-double2 .btn-thumb-status').addClass('thumb-pageno'+pageObj.countpage).attr('data-page', pageObj.countpage);
					}else{
					    findBoxElem.find('.view-item-thumb-double2 img').attr('src', viewPath+'v2_images/common/transparency_img.png');
						findBoxElem.find('.view-item-thumb-double2 .btn-thumb-status').addClass('thumb-noimage');
					}

					this.thumbElem.append(findBoxElem);
				}
			}else {
				for( var p in htmlview._pages ){
					_tempElement.innerHTML = '';
					_tempElement.innerHTML = this.itemElement.innerHTML;
					findBoxElem = htmlview.findElement('.single-thumb-items', _tempElement);
					
					var src = viewInfo.bookurl+htmlview._pages[p].number+'/thumb.jpg';
					findBoxElem.find('.view-item-thumb img').attr('src', src);
					findBoxElem.find('.view-item-title span').text(htmlview._pages[p].label);
					findBoxElem.find('.btn-thumb-status').addClass('thumb-pageno'+htmlview._pages[p].countpage).attr('data-page', htmlview._pages[p].countpage);
					htmlview._pages[p].thumbload.check = true;
					this.thumbElem.append(findBoxElem);
				}
			}
			
		},
		
		destroy : function(){
			if( viewUtils.browser == 'msie' ){
				PARAM.wisebook.off('mouseenter mouseleave');
			}
		}
	};
	/**************************************
	 sior
	***************************************/
	var bookmarkProc = {
		bookmarkElem : null,
		module : 'bookmark',
		deleteMode : false,
		itemElement : document.createElement('div'),
		bookmarkleftElem : null,
		bookmarkrightElem : null,
		nowBookmarkPageList : [],
		
		init : function(){
			var that = this;
				url = viewPath + 'v2_viewhtml/items/bookmark/double-bookmark.html';
			
			this.bookmarkElem = $('#view-bookmark-table');
			
			if( viewUtils.Mobile ) {
				var suburl = viewPath + 'v2_viewhtml/items/bookmark/bookmark-subnav-phone.html';
				
				htmlview.getHtml(suburl, function(data){
					$('.view-popup-bookmark .view-subnavbar').html(data);
					ADDONS.setLanguage("bookmark");
				}, true);
			}else{
    			ADDONS.setLanguage("bookmark");
			}
			
			
			if( PARAM.bookInfo.config.single != 0 ){
				$('.bookmark-dir-select-block .view-buttons-row').remove();
				this.bookmarkleftElem = $('#bookmark-save');
				url = viewPath + 'v2_viewhtml/items/bookmark/single-bookmark.html';
			}else{
				this.bookmarkleftElem = $('#bookmark-save-left');
				this.bookmarkrightElem = $('#bookmark-save-right');
				$('#bookmark-save').remove();
			}
			
			htmlview.getHtml(url, function(data){
				that.itemElement.innerHTML = data;
			});
			
			this.bookmarkEvent();
		},
		
		bookmarkEvent : function(){
			var that = this;
			$(document).bind(viewdefind.VIEW_POPUP_OPEN, function(){
			    if( PARAM.nowBusy != "bookmark" ) return false;
			    
			    that.createBookmark(); 
			    that.bookmarkChangePage(PARAM.currentpage); 
            });
            
			$(document).bind(viewdefind.VIEW_DESTROY, function(){ that.destroy() });
			$(document).bind(viewdefind.PAGE_AFTER_EVENT, function(e, obj){ that.bookmarkChangePage(obj.page);});
			
			
			$(document).bind(viewdefind.VIEW_POPUP_CLOSE, function(){
    			if(PARAM.nowBusy != 'bookmark') return false;
    			that.bookmarkDeleteBtnInit();
			});
			
			
			PARAM.wisebook.on('tap', '.bookmark-select, .bookmark-save, .bookmark-check-mark, .bookmark-delete, .btn-bookmark-status', function(){
				var clicked = $(this),
					tempModule = that.module;
				
				if( clicked.hasClass('bookmark-select') ){
					$('.bookmark-select').removeClass('active');
					clicked.addClass('active');
					that.module = clicked.data('module');
										
					if( that.module != 'bookmark' ) {	
						if( that.deleteMode ){
							that.bookmarkDeleteBtnInit();
							that.deleteMode = false;
						}					
					
						$('.bookmark-delect-block, .bookmark-dir-select-block').css('visibility', 'hidden');
					} else $('.bookmark-delect-block, .bookmark-dir-select-block').css('visibility', 'visible');
					
				} else if( clicked.hasClass('bookmark-save') ){
					var page = $(this).attr('data-page');
					if( page == 0 || page == null ) return false;
					
					if( that.bookMarkSamePageCk(page) ){
						that.setBookmarkData(page);
						that.bookmarkDeleteBtnInit();
					}
					
				}else if( clicked.hasClass('bookmark-check-mark') ){
					if( clicked.hasClass('selected') ) clicked.removeClass('selected');
					else clicked.addClass('selected');
					
					that.ckBookmarkDeleteIconSelectedElement();
					
					return false;
				}else if( clicked.hasClass('bookmark-delete') ){
				
					if( that.module == 'bookmark' && !clicked.hasClass('disable') ){
						viewMessageProc.confirm( PARAM.viewLang.bookMarkPageDeleteMsg, PARAM.viewLang.confirm_title,
						    function(){
    						   that.deleteBookmarkData();
                               that.bookmarkDeleteBtnInit();
                               that.createBookmark();
                               that.bookmarkChangePage(PARAM.currentpage);
						    }
                        );
                        
                        return false;
					}
				} else{
					if( clicked.hasClass('thumb-noimage') ) return false;
					ADDONS.sendGotopage( $(this).data('page') );
					return false;
				}
				
				that.createBookmark();
				that.bookmarkChangePage(PARAM.currentpage);
			});
			
			PARAM.wisebook.on('tap', '.bookmark-edit, .bookmark-cancel', function(){
				$('.bookmark-edit, .bookmark-cancel').removeClass('selected');
				$('.bookmark-delete').addClass('disable');
				var clicked = $(this);
				if( clicked.hasClass('bookmark-edit') ){
					$('.bookmark-cancel').addClass('selected');
					$('.bookmark-check-mark').removeClass('selected').css('display', 'block');
					
					that.deleteMode = true;
				}else{
					$('.bookmark-edit').addClass('selected');
					$('.bookmark-check-mark').removeClass('selected').css('display', 'none');
					
					that.deleteMode = false;
				}
			});
			
			if( viewUtils.browser == 'msie' ){
				PARAM.wisebook.on('mouseenter mouseleave', '.view-item-thumb',  function(e){
					if( PARAM.nowBusy != "bookmark" ) return false;
					
					if( $(this).find('.btn-bookmark-status').hasClass('selected') ) return false;
					if( $(this).find('.btn-bookmark-status').hasClass('thumb-noimage') ) return false;
					
					if(e.type == 'mouseenter') $(this).find('.btn-bookmark-status').addClass('hover');
					else $(this).find('.btn-bookmark-status').removeClass('hover');
				});
			}
		},
		
		createBookmark : function(){
			var data = null,
				_tempElement = document.createElement('div');	
			
			switch(this.module){
				case 'bookmark' : data = h5appview.wisebookStorageList.bookmark.siori; break;
				case 'memo' : data = h5appview.wisebookStorageList.bookmark.memo; break;
				case 'pen' : data = h5appview.wisebookStorageList.bookmark.canvas; break;		
				case 'stamp': data = h5appview.wisebookStorageList.bookmark.stamp; break;
				case 'picture' : data = h5appview.wisebookStorageList.bookmark.picture; break;
				case 'movie' : data = h5appview.wisebookStorageList.bookmark.movie; break;
				case 'urllink' : data = h5appview.wisebookStorageList.bookmark.urllink; break;
			}
			
			this.bookmarkElem.html('');
			
			if( data.length <= 0 ) return false;
			
			this.nowBookmarkPageList = [];
				
			if( PARAM.bookInfo.config.single == 0 ){
				//two page
				for( var i in data ){
					
					if( $.inArray( parseInt(data[i]), this.nowBookmarkPageList ) != -1 ) continue;
					
					var obj = this.checkBookmark( parseInt(data[i]) );
					
					_tempElement.innerHTML = '';
					_tempElement.innerHTML = this.itemElement.innerHTML;
					var findBoxElem = htmlview.findElement('.double-thumb-items', _tempElement);
				
					if( obj.left != 0 && obj.left != null ){
						pageObj = htmlview._pages[obj.left-1];
						var src1 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
						
						findBoxElem.find('.view-item-thumb-double1 img').attr('src', src1);
						findBoxElem.find('.view-item-thumb-double1 .view-item-title span').text(pageObj.label);
						findBoxElem.find('.view-item-thumb-double1 .btn-bookmark-status').addClass('thumb-pageno'+pageObj.countpage).attr('data-page', pageObj.countpage);
						findBoxElem.find('.view-item-thumb-double1 .bookmark-check-mark').attr('data-page', pageObj.countpage);
						
						if( data.indexOf( obj.left ) < 0 ){
							findBoxElem.find('.view-item-thumb-double1 .bookmark-disable-thumb').css('display', 'block');
							findBoxElem.find('.view-item-thumb-double1 .bookmark-check-mark').remove();
						}
												
					}else{
						findBoxElem.find('.view-item-thumb-double1 .btn-bookmark-status').addClass('thumb-noimage');
						findBoxElem.find('.view-item-thumb-double1 .bookmark-check-mark').remove();
					}
					
					if( obj.right != 0 && obj.right != null ){
						pageObj = htmlview._pages[obj.right-1];
						var src2 = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
						findBoxElem.find('.view-item-thumb-double2 img').attr('src', src2);
						findBoxElem.find('.view-item-thumb-double2 .view-item-title span').text(pageObj.label);
						findBoxElem.find('.view-item-thumb-double2 .btn-bookmark-status').addClass('thumb-pageno'+pageObj.countpage).attr('data-page', pageObj.countpage);
						findBoxElem.find('.view-item-thumb-double2 .bookmark-check-mark').attr('data-page', pageObj.countpage);
						
						if( data.indexOf( obj.right ) < 0 ) {
							findBoxElem.find('.view-item-thumb-double2 .bookmark-disable-thumb').css('display', 'block');
							findBoxElem.find('.view-item-thumb-double2 .bookmark-check-mark').remove();
						}
					}else{
						findBoxElem.find('.view-item-thumb-double2 .btn-bookmark-status').addClass('thumb-noimage');
						findBoxElem.find('.view-item-thumb-double2 .bookmark-check-mark').remove();
					}
							
					this.bookmarkElem.append(findBoxElem);
				}
				
			}else{
				for( var i in data ){
					_tempElement.innerHTML = '';
					_tempElement.innerHTML = this.itemElement.innerHTML;
					var findBoxElem = htmlview.findElement('.single-thumb-items', _tempElement);
					
					var src = viewInfo.bookurl+htmlview._pages[ data[i] -1 ].number+'/thumb.jpg';
					findBoxElem.find('.view-item-thumb img').attr('src', src);
					findBoxElem.find('.view-item-title span').text(htmlview._pages[ data[i] -1 ].label);
					findBoxElem.find('.btn-bookmark-status').addClass('thumb-pageno'+htmlview._pages[ data[i] -1 ].countpage).attr('data-page', htmlview._pages[ data[i] -1 ].countpage);
					findBoxElem.find('.bookmark-check-mark').attr('data-page', htmlview._pages[ data[i] -1 ].countpage);
					
					this.bookmarkElem.append(findBoxElem);				
				}
			}
		},
		
		checkBookmark : function(page){
			for( var d in PARAM.doublePair ){
				if(PARAM.doublePair[d].left == page ||PARAM.doublePair[d].right == page ){
					this.nowBookmarkPageList.push(PARAM.doublePair[d].left);
					this.nowBookmarkPageList.push(PARAM.doublePair[d].right);
					return PARAM.doublePair[d];
					break;
				}
			}
			
			return false;
		},
		
		ckBookmarkDeleteIconSelectedElement : function(){
			var ckselectedElm = false;
			$('.bookmark-check-mark').each(function() {
	            if( $(this).hasClass('selected') ){
					ckselectedElm = true;
					return false;
				}
	        });
			
			if(ckselectedElm) $('.bookmark-delete').removeClass('disable');
			else $('.bookmark-delete').addClass('disable');
		},
		
		bookMarkSamePageCk : function(page){
			
			if( this.module != 'bookmark' ) return false;
			var storage = h5appview.wisebookStorageList.bookmark.siori;
			
			for( var s in storage ){
				if( storage[s] == page ){
					return false;
					break;
				}
			}
			
			return true;
		},
		
		setBookmarkData : function(page){
			h5appview.wisebookStorageList.bookmark.siori.push( parseInt(page) );
			h5appview.wisebookStorageList.bookmark.siori.sort( function(a,b){return a-b} );
			if( appFlag )
				h5appview.setBoomarkInfo();
			else 
				h5appview.setStorageData();
		},
		
		deleteBookmarkData : function(){
			var deleteBookMarkArr = [];
			$('.bookmark-check-mark').each(function() {
				if( $(this).hasClass('selected') ) deleteBookMarkArr.push( $(this).data('page') );
			});
			
			if( deleteBookMarkArr.length <= 0 ) return false;
			
			var storage = h5appview.wisebookStorageList.bookmark.siori;		
			for( var s in storage ){
				for(var d in deleteBookMarkArr){
					if(storage[s] == deleteBookMarkArr[d]){
						storage.splice(s, 1);
						continue;
					}
				}
			}
			
			if( appFlag )
				h5appview.setBoomarkInfo();
			else 
				h5appview.setStorageData();
		},
		
		bookmarkDeleteBtnInit : function(){
			$('.bookmark-delete').addClass('disable');
			$('.bookmark-cancel').removeClass('selected');
			$('.bookmark-edit').addClass('selected');
			$('.bookmark-check-mark').removeClass('selected').css('display', 'none');
		},
		
		bookmarkChangePage : function(page){
			$('.btn-bookmark-status').removeClass('selected');
			$('.thumb-pageno'+page).addClass('selected');
			
			if( PARAM.bookInfo.config.single != 0 ){
				this.bookmarkleftElem.attr('data-page', PARAM.currentpage);
			}else{
				this.bookmarkleftElem.attr('data-page', PARAM.side.left);
				this.bookmarkrightElem.attr('data-page', PARAM.side.right);
			}
		},
		
		destroy : function(){
			if( viewUtils.browser == 'msie' ){
				PARAM.wisebook.off('mouseenter mouseleave');
			}
		}
		
	};
	
	
	/**************************************
	 search
	***************************************/
	var searchProc = {
		searchElem : null,
		nowKeyword : '',
		mblen : 1000,
		itemElement : document.createElement('div'),
		phonePanelSearch : null,
		
		init : function(){
		    
			var that = this;
			var url = viewPath + 'v2_viewhtml/items/search/search-item.html';
			
			htmlview.getHtml(url, function(data){
				that.itemElement.innerHTML = data;
				
				//横断検索から来た場合すぐ検索
    			if( 'htp' in viewInfo && viewInfo.htp != "" && PARAM.bookInfo.skin.search ){
    			    that.htpProcess(viewInfo.htp);
    			}else if( appFlag && PARAMLIBRARY.createViewSeachInfo != null && 'keyword' in PARAMLIBRARY.createViewSeachInfo ){
    				that.htpProcess( PARAMLIBRARY.createViewSeachInfo.keyword );
    			}
			});
			
			if( viewUtils.Mobile ) {
				//mobile phone only
				this.mblen = 200;
				this.searchPhoneSetting();
				this.searchPhoneEvent();
			}else{
				this.searchElem = $('#view-search-table .view-search-list');
				this.searchTotalElem = $('.search-total-count');
				this.searchPcTabletEvent();
				ADDONS.setLanguage('search');
			}
			
			this.searchcommonEvent();
		},
		
		htpProcess : function(text){
		    var that = this;
		    
            if( viewUtils.Mobile ){
            	this.nowKeyword = text;
                PARAM.searchinfo.keyword = text.split(" ");
            }else{
                this.nowKeyword = text;
                $('#search-textarea').val(text);
                this.searchTextCheck(text, function(){
    				that.searchProcess(text);
                });
            }
		},
		
		searchPhoneSetting : function(){
			var url = viewPath + 'v2_viewhtml/items/search/search-subnav-phone.html';		
			htmlview.getHtml(url, function(data){
				var searchpopupElem = $('.view-popup-search');
				searchpopupElem.find('.view-subnavbar').html(data);
				searchpopupElem.find('.view-through').remove();
				searchpopupElem.find('.view-lang-search').text(PARAM.viewLang.commonlang["view-lang-search"]);
				ADDONS.setPlaceholder();
				ADDONS.setLanguage('search');
			});
		},
		
		searchcommonEvent : function(){
			var that = this;

			if( appFlag == false ){
				$(document).bind(viewdefind.VIEW_POPUP_OPEN, function(){
	                if( PARAM.nowBusy != 'search' ) return false;
	                
				    if( viewUtils.androidInfo.check && viewUtils.Mobile ){
				        PARAM.isResizeWork = false;
				    }    
				 });
				 
				 $(document).bind(viewdefind.VIEW_POPUP_CLOSE, function(){ 
	                if( PARAM.nowBusy != 'search' ) return false;
	                 
	                if( viewUtils.androidInfo.check && viewUtils.Mobile ){
				    	PARAM.isResizeWork = true;
				    }
				 });
			}
			
			PARAM.wisebook.on('tap', '#btn-search-reset, .view-search-type, .view-search-item', function(e){
				var searchTextarea = $('#search-textarea');
				if( this.id == 'btn-search-reset' ){
					searchTextarea.val('');
					that.searchReset();
				}else if( $(this).hasClass('view-search-type') )
					PARAM.searchinfo.searchType = $(this).val();
				else if( $(this).hasClass('view-search-item') ){
					searchTextarea.trigger('blur');
					var page = $(this).data('page');
					
					if( page == PARAM.currentpage ) {
						htmlview.workerview.postMessage({cmd :'makesearch', pagenum : page-1});
						var highlightElem = htmlview.domDisplay[page].find('.search-space');
                        highlightElem.removeClass('searchhighlightanimation');
                        highlightElem.addClass('searchhighlightanimation');
					}
					
					ADDONS.closePanel();
					ADDONS.sendGotopage( page ); 
				}
			});
			
		},
		
		searchPhoneEvent : function(){
			var that = this;
			
			$(document).bind(viewdefind.VIEW_POPUP_OPENED, function(){
			    if( PARAM.nowBusy != 'search' ) return false;
			    
			    if( !viewUtils.Mobile ) {
					setTimeout(function(){
						$('#search-textarea').focus();
					}, 0);
				}else{
    				if( that.phonePanelSearch != null ) {
    					$('#search-textarea').trigger('blur');
    					ADDONS.clicked = $('#btn-booktext-search');
    					ADDONS.viewpanel( ADDONS.clicked );
    				}else if( PARAM.searchinfo.keyword.length > 0 ){
    					$('#search-textarea').val(that.nowKeyword);
    					ADDONS.clicked = $('#btn-booktext-search');
    					ADDONS.viewpanel( ADDONS.clicked );
    				}
				}
			});
			
			PARAM.wisebook.on('tap', '#btn-booktext-search', function(){
				var clicked = $(this);
				var searchTextarea = $('#search-textarea');
				if( this.id == 'btn-booktext-search' ) {
					var text = $('#search-textarea').val();
					
					that.searchTextCheck(text, function(){
						searchTextarea.trigger('blur');
						that.nowKeyword = text;
						
						ADDONS.clicked = clicked;
						ADDONS.viewpanel( clicked );
					});
				}
			});
			PARAM.wisebook.on('keypress', '#search-textarea', function(e){
				if(e.keyCode == 13) {
					var text = $(this).val();
					that.searchTextCheck(text, function(){
						$('#search-textarea').trigger('blur');
						that.nowKeyword = text;
						
						ADDONS.clicked = $('#btn-booktext-search');
						ADDONS.viewpanel( ADDONS.clicked );
					});
				}
			});
		},
		
		searchPcTabletEvent : function(){
			var that = this;
			
			PARAM.wisebook.on('keypress', '#search-textarea', function(e){
				if(e.keyCode == 13) {
					var text = $(this).val();
					that.searchTextCheck(text, function(){
						$(this).trigger('blur');
						that.searchProcess(text);
					});		
				}
			});
			
			PARAM.wisebook.on('tap', '#btn-booktext-search', function(){
				var searchTextarea = $('#search-textarea');
				if( this.id == 'btn-booktext-search' ) {
					var text = searchTextarea.val();
					that.searchTextCheck(text, function(){
						searchTextarea.trigger('blur');
						that.searchProcess(text);
					});
				}
			});
		},
		
		searchReset : function(){
		    if( this.searchElem ) this.searchElem.html('');
            if( this.searchTotalElem ) this.searchTotalElem.text('');			
			this.nowKeyword = '';
			PARAM.searchinfo.keyword = [];
			
			if( this.phonePanelSearch != null ) {
				this.phonePanelSearch.html('');
				this.phonePanelSearch = null
			}
			
			$('#search-textarea').trigger('blur');
			htmlview.workerview.postMessage({cmd :'resetSearch'});
		},
		
		searchPhoneProcessBefore : function(elem){
		    elem.find('.lang-search').text(PARAM.viewLang.commonlang["view-lang-search"]);
			this.searchElem = elem.find('#view-search-table .view-search-list');
			this.searchTotalElem = elem.find('#view-search-table .search-total-count');
			this.phonePanelSearch = elem;
			
			this.searchProcess(this.nowKeyword);
		},
		
		searchTextCheck : function(searchtext, callback){
			if(searchtext == "") {
				viewMessageProc.alert( PARAM.viewLang.searchNotValue, PARAM.viewLang.alertTitle );
				return false;
			}
			
			if(searchtext.length > 300){
				viewMessageProc.alert( PARAM.viewLang.searchNotValue.replace('maxnum', 300), PARAM.viewLang.alertTitle  ); 
				return false;
			}
			
			if( typeof(callback) == 'function' ) callback();
		},
		
		searchProcess : function(searchtext){
			var that = this;
			
			var chStr = "";
			searchtext = searchtext.replace(/(^\s*)|(\s*$)/g, "");
			
			for(i=0;i<searchtext.length;i++){
				var c = searchtext.charAt(i);
				if(c.charCodeAt(0) == 0x3000) chStr +=' ';
				else chStr += c;
			}
			
			searchtext = chStr;
			this.setKeyword(searchtext, function(data){
				that.searchElem.html('');
				if( data != false ){
					that.nowKeyword = searchtext;
					PARAM.searchinfo.keyword = searchtext.split(" ");
					that.createSearch(data);
				}else{
					//no search
					if( that.phonePanelSearch != null ) that.phonePanelSearch = null;
					that.searchElem.html( PARAM.viewLang.notTextSearch.replace( 'searchText', searchtext) );
				}
			});
		},
		
		createSearch : function( searchReulstData ){
			var _tempElement = document.createElement('div'),
				findBoxElem = null;	
			
			this.searchTotalElem.text( PARAM.viewLang.searchTotalCount.replace('number', searchReulstData.length) );
			
			for( var s in searchReulstData ){
				var info = searchReulstData[s],
					pagelabel = (PARAM.pageNumberType) ? PARAM.bookInfo.labels[info.page-1] :  info.page;
				
				_tempElement.innerHTML = '';
				_tempElement.innerHTML = this.itemElement.innerHTML;
				
				findBoxElem = htmlview.findElement('.view-search-item', _tempElement);
				
				findBoxElem.attr('data-page', info.page);
				
				findBoxElem.find('.view-search-number').html(pagelabel);
				findBoxElem.find('.view-search-text').html(info.text);
				
				this.searchElem.append(findBoxElem);
			}
			$('.search-keyword-text').css('color','#'+PARAM.bookInfo.config.searchcolor);
		},
		
		setKeyword : function(keyword , callback){
			var that = this,
				scJudgment = '|',
				searchResultList = [],
				matchSearchStr;
			
			var matchKeyword = new RegExp(keyword.replace(/\s+/g, scJudgment), 'ig'),
				arrKeyword = keyword.split(" ");
			
			if( Object.keys(PARAM.searchExtenalTextData).length <= 0 ) {
				callback(false);
				return false;
			}
			
			var	searchTextData = PARAM.bookInfo.search.type == 'external' ? PARAM.searchExtenalTextData : htmlview._descriptions;
			
			$.each(searchTextData, function(sNum, sInfo){
				var scResult, scNumber="", scText="";
				
				if(PARAM.bookInfo.search.type == 'external'){
					scResult =  matchKeyword.test( sInfo.text );
					if(scResult){
						scNumber = sInfo.number;
						scText = sInfo.text;
					}
				}else {
					//htmlview._descriptions
					return false;
				}
				
				if( scResult ){
					if(PARAM.searchinfo.searchType == 'and'){
						//and 検索
						var andSearchCheck = false, matchData;
						for( var list in arrKeyword ){
							var valueKeyword = arrKeyword[list];
							var regVal = new RegExp( valueKeyword, 'ig');
							
							if( scText.match( regVal ) ) andSearchCheck = true;
							else {
								andSearchCheck = false;
								break;
							}
						}
						
						if( andSearchCheck ){
							matchSearchStr = scText.match(matchKeyword);
							scText = scText.substr(matchSearchStr.index, scText.length);
							$.each(arrKeyword, function(kv, keyTagValue){ 
								scText = scText.replace(new RegExp(keyTagValue, 'ig'), '<strong class="search-keyword-text">'+keyTagValue+'</strong>');
							});
							
							//that.mb_strimwidth(sList.scText, 0, mb_string_default, '...')
							searchResultList.push({page:scNumber, text: ADDONS.mb_strimwidth(scText, 0, that.mblen, '...') });
						}
						
					}else{
						//or 検索
						matchSearchStr = scText.match(matchKeyword);
						scText = scText.substr(matchSearchStr.index, scText.length);
						
						$.each(arrKeyword, function(kv, keyTagValue){ 
							scText = scText.replace(new RegExp(keyTagValue, 'ig'), '<strong class="search-keyword-text">'+keyTagValue+'</strong>');
						});
						searchResultList.push({page:scNumber, text: ADDONS.mb_strimwidth(scText, 0, that.mblen, '...') });
					}
				}
			});
			
			if( searchResultList.length <= 0 ) callback(false);
			else {
			    ANALYTICS._sendSearchAnalytics(keyword);
			    callback(searchResultList);
			 }
		}
	};
	
	var shareProc = {
		shareElem : null,
		
		init : function(){
		    ADDONS.setLanguage('share');
			this.shareElem = $('.share-layout-items-list');
			
			if( ('facebook' in PARAM.bookInfo.skin == false || PARAM.bookInfo.skin.facebook == 0 ) && ('twitter' in PARAM.bookInfo.skin == false || PARAM.bookInfo.skin.twitter == 0 ) ) 
				$('.share-item-icons').remove();
			
			this.shareEvent();
		},
		
		shareEvent : function(){
			var that = this;

			$(document).bind(viewdefind.VIEW_POPUP_OPEN, function(){ 
                if( PARAM.nowBusy != 'share' ) return false;
                
                if( appFlag == false && viewUtils.androidInfo.check && viewUtils.Mobile ){
                    PARAM.isResizeWork = false;
                }    
                that.shareOpen(); 
             });
             
             $(document).bind(viewdefind.VIEW_POPUP_CLOSE, function(){ 
                 if( PARAM.nowBusy != 'share' ) return false;
                 
                 if( appFlag == false && viewUtils.androidInfo.check && viewUtils.Mobile ){
                    PARAM.isResizeWork = true;
                }
             });
            			 
			
			if( viewUtils.device == "pc" ){
				$(document).bind(viewdefind.VIEW_POPUP_OPENED, function(){ 
				    if( PARAM.nowBusy != 'share' ) return false;
				    that.shareClipBoardRefresh(); 
				});
				$(document).bind(viewdefind.ADDONS_RESIZE, function(){ that.shareClipBoardRefresh(); });
				$(document).bind(viewdefind.VIEW_DESTROY, function(e, val){
					if( that.clipBoard ){
						var copylink = $('#copy-link'),
							copyumekomi = $('#copy-umekomi'),
							clipBoard1_id = that.clipBoard.movieId,
							clipBoard2_id = that.clipBoard2.movieId;				
						
						$('#'+clipBoard1_id).unbind('mouseOver complete').parent().remove();
						$('#'+clipBoard2_id).unbind('mouseOver complete').parent().remove();
					}
				});
			}
			
			PARAM.wisebook.on('tap', '#btn-facebook, #btn-twitter', function(){
				var url = '';
				if( this.id == 'btn-facebook' ){
					url = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(that.shareLinkInput);
					if(appFlag == true){
						PARAM.openExtenal(url);
					}else{
						window.open(url, 'facebook-share-dialog', 'width=626,height=436');
					}
				}else{
					url = 'https://twitter.com/intent/tweet?original_referer=' + encodeURIComponent(that.shareLinkInput) + '&text=' + encodeURIComponent(PARAM.bookInfo.twitter) + encodeURIComponent(' ') + encodeURIComponent(PARAM.bookInfo.title) + encodeURIComponent(' ') + '&tw_p=tweetbutton&url=' + encodeURIComponent(that.shareLinkInput);
					if(appFlag == true){
						PARAM.openExtenal(url);
					}else{
						PARAM.openExtenal(url);
					}
				}
			});
			
			PARAM.wisebook.on('tap', '.mail-send-btn', function(e){
				e.preventDefault();
				var to_mail = $("input[name='mailinfo-address']").val(),
					from_name = $("input[name='mailinfo-sendname']").val(),
					from_mail = "no-reply@wisebook.jp ",
					mail_msg  = $("textarea[name='mailinfo-message']").val();
				
				var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
				if ( filter.test(to_mail) != true ) {
				    viewMessageProc.alert( PARAM.viewLang.js_str.mail_sender_warn, PARAM.viewLang.alertTitle );
					return false;
				}

                if (from_name == "") {
                    viewMessageProc.alert(PARAM.viewLang.js_str.mail_sender_name_warn, PARAM.viewLang.alertTitle);
                    return false;
                }
				
				var loc = window.location,
					cur_url = loc.protocol + '//' + loc.host + loc.pathname,
					sendMailUrl = "/library/sendmail";
				
				
				$.ajax({
					type: "POST",
					url: sendMailUrl,
					data: { 
						frommail: from_mail, 
						tomail: to_mail, 
						fromname: from_name, 
						url: cur_url, 
						book: PARAM.bookInfo.bookid, 
						page: PARAM.currentpage, 
						title: PARAM.bookInfo.title, 
						userid: PARAM.bookInfo.author, 
						body: mail_msg, 
						//skin: skinName, 
						send: "ok" 
					},
					success : function( msg ){
					    viewMessageProc.alert( PARAM.viewLang.js_str.mail_send_success, PARAM.viewLang.alertTitle );
					},
					error:function(request,status,error){
					    viewMessageProc.alert( PARAM.viewLang.js_str.mail_send_fail, PARAM.viewLang.alertTitle );
					}
				});
				
				return false;
			});
		},
		
		shareClipBoardRefresh : function(){
			if( viewUtils.device != "pc"  ) return false;
			
			if( this.clipBoard ){
				var copylink = $('#copy-link'),
					copyumekomi = $('#copy-umekomi'),
					clipBoard1_id = this.clipBoard.movieId,
					clipBoard2_id = this.clipBoard2.movieId;				
				
				$('#'+clipBoard1_id).unbind('mouseOver complete').parent().remove();
				$('#'+clipBoard2_id).unbind('mouseOver complete').parent().remove();
			}
			
			this.initClipBoard();
		},
		
		shareOpen : function(){
			var that = this;
			
			$("input[name='mailinfo-address']").val('');
			$("input[name='mailinfo-sendname']").val('');
			$("textarea[name='mailinfo-message']").val(PARAM.viewLang.sharelang["view-lang-mailinfo-message-default"]);
			


			this.shareLinkInput = location.href;
			if( appFlag == true ) this.shareLinkInput = PARAMDATA.manifest.host+'html/'+PARAM.bookInfo.author+'/'+PARAM.bookInfo.bookid+'/#'+Hash.getText();
			
			$('.share_link_input').val(this.shareLinkInput);
			$('.share_embed_input').val('<iframe src="' + this.shareLinkInput + '" width="1250" height="720" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen> </iframe></div>');	
		},
		
		initClipBoard : function(){
			var that = this;
			this.clipBoard = new ZeroClipboard.Client(),
            this.clipBoard2 = new ZeroClipboard.Client();
			//cursor hand type 
            this.clipBoard.setHandCursor( true );                        
            this.clipBoard2.setHandCursor( true );                        
			
            //swf
            ZeroClipboard.setMoviePath("v2_lib/zclip/ZeroClipboard.swf");
            var data1 = $('#copy-link')[0];
            var data2 = $('#copy-umekomi')[0]
            
            this.clipBoard.glue(data1);
            this.clipBoard2.glue(data2);
            
            this.clipBoard.addEventListener('mouseOver', function (client) {
				that.clipBoard.setText( $(".share_link_input").val() );
            });
            this.clipBoard2.addEventListener('mouseOver', function (client) {
				that.clipBoard2.setText( $(".share_embed_input").val() );
            });
            
            this.clipBoard.addEventListener('complete', function (client) {
                viewMessageProc.alert( PARAM.viewLang.copyIsOk, PARAM.viewLang.alertTitle );
            });          
            this.clipBoard2.addEventListener('complete', function (client) {
                viewMessageProc.alert( PARAM.viewLang.copyIsOk, PARAM.viewLang.alertTitle );
            });   
		}
	};
	
	/**************************************
	 help
	***************************************/
	var helpProc = {
		helpElem : null,
		
		init : function(){
			var that = this;
			
			this.helpElem = $('#view-help-table');
			
			$(document).bind(viewdefind.HELP_CREATE, function(){ that.createHelp() });
		},
		
		createHelp : function(){
			var helpTitle = '',
			 	helpImgPath =  (viewUtils.device == 'pc') ? viewPath + 'v2_images/help/pc/' : viewPath + 'v2_images/help/mobile/';
			 	
			var helpTableTemp = '<table>';			
			for( var h in PARAM.viewLang.help_info ){
				var helpInfo = PARAM.viewLang.help_info[h];
				if( !helpInfo.help_enable ) continue;
				
				if( helpInfo.help_device != 'all' ){
					if( viewUtils.device == 'pc' && helpInfo.help_device != viewUtils.device ) continue;
					else if( viewUtils.device != 'pc'  &&   helpInfo.help_device == 'pc' ) continue;
					
				}
				
				if(helpInfo.help_haeder == 'warning'){	
					var warningStyle = 'padding-top:0;color:#FFF600;font-size:17px;line-height:20px;';
					helpTableTemp += '<tr><td class="help-title" colspan="2" style="'+warningStyle+'">'+helpInfo.help_text.replace(/\n/g, '</br>')+'</td></tr>';
					return true;							
				}
				
				if(helpTitle != helpInfo.help_haeder){
					helpTitle = helpInfo.help_haeder;
					if(h == 0) helpTableTemp += '<tr><td class="help-title" colspan="2" style="padding-top:0;">'+helpTitle+'</td></tr>';
					else helpTableTemp += '<tr><td class="help-title" colspan="2">'+helpTitle+'</td></tr>';
				}
				
				var helpImg = helpImgPath+helpInfo.help_img;
				helpText = helpInfo.help_text.split('\n');
				helpTableTemp += '<tr>'
						+ '<td class="help-contents-img"><img src="'+helpImg+'" width="'+helpInfo.help_img_w+'" height="'+helpInfo.help_img_h+'"/></td>'
						+ '<td class="help-contents-text" valign="top">';
						$.each(helpText, function(tl, tVal){
							helpTableTemp += tVal+'<br>';
						});
						helpTableTemp += '</td> </tr>';	
				
			}
			helpTableTemp += '</table>';
			this.helpElem[0].innerHTML = helpTableTemp;
		}
	};
	
	/**************************************
	 textpopup
	***************************************/
	var popuptextProc = {
		itemElement : document.createElement('div'),
		popuptextEnableArr : [],
		
		init : function(){
			var that = this,
				url = viewPath + 'v2_viewhtml/items/popuptext/popuptext-item.html';
			
			htmlview.getHtml(url, function(data){
				that.itemElement.innerHTML = data;
				$(that.itemElement).find('.close-textpopup img').attr('src', viewPath+'v2_images/common/btn_x_close.png');
				//v2_images/common/btn_x_close.png
			});
			
			this.popuptextEvent();
		},
		
		popuptextEvent : function(){
			var that = this;
			$(document).bind(viewdefind.ADDONE_OPNE_POPUPTEXT, function(e,data, page){ that.openPopuptext(data, page); });
			$(document).bind(viewdefind.PAGE_BEFORE_EVENT, function(){ that.allPopuptextRemove() });
			PARAM.wisebook.on('tap', '.close-popuptext', function(){ that.textPopupRemove( $(this).data('id') ); });
		},
		
		openPopuptext : function(data, page){
			var popupid = data.id+'_popup',
				DOMpage = parseInt( page ) + PARAM.cover,
				popupObj = ( 'action' in data ) ? data.action : data,
				popuptextBgHex = PARAM.__hexToRgb('#'+popupObj.popupbgcolor),
				tempContentsBgColor = popuptextBgHex.split(','),
				_tempElement = document.createElement('div');


			if( this.popuptextEnableArr.indexOf(popupid) != -1 ) {
				this.textPopupRemove(popupid)
				return;
			}
			
			var eventspaceElem = (!viewUtils.Mobile) ? $('.p'+DOMpage).find('.collections-space .event-space') : PARAM.wisebook;

			$.each(tempContentsBgColor, function(i, h){
				var bgVal = parseInt(h);
				
				if( bgVal !=0 ) return true;
				tempContentsBgColor[i] = '166';
			});
			
			tempContentsBgColor = tempContentsBgColor.join(',');
		
			var popuptextAlpha = 1;
			if(popupObj.popuptrans) popuptextAlpha = 0.8;
			
			var popuptextBgRgba = 'rgba('+popuptextBgHex+', '+popuptextAlpha+')',
				textContentsBgRgbColor = tempContentsBgColor,
				textContentsRgb = 'rgb('+textContentsBgRgbColor+')';
			
			
			if(viewUtils.Mobile){
				popuptextBgRgba = '#'+popupObj.popupbgcolor;
			}
			
			_tempElement.innerHTML = '';
			_tempElement.innerHTML = this.itemElement.innerHTML;


			var findBoxElem = htmlview.findElement('.popuptext-view', _tempElement);

			if( !viewUtils.Mobile ) {
				var actualpos = PARAM.getLookPosByActualPos(popupObj.popupx, popupObj.popupy, popupObj.popupwidth, popupObj.popupheight);
				findBoxElem.attr({'id' : popupid}).css({ left : actualpos.x, top : actualpos.y, width : actualpos.w, height : actualpos.h, 'background' : popuptextBgRgba });
			}else{
				findBoxElem.attr({'id' : popupid}).css({ left : 0, top : 0, width : '100%', height : '100%', 'z-index' : 10000, 'background' : popuptextBgRgba });
				ADDONS.viewNavContainerAction('hide');
			}
			

			findBoxElem.find('.close-popuptext').attr('data-id', popupid);
			findBoxElem.find('.close-popuptext img').attr('src', viewPath+'v2_images/common/btn_x_close.png');

			var popupTextString = ( 'action' in data ) ? popupObj.popuptext : popupObj._value;

			findBoxElem.find('.popup-text-value').css({ 'background' : textContentsRgb, 'color' : '#'+popupObj.popupcolor }).html(popupTextString.replace(/\r\n/g,'\n').replace(/\n/g,'<br>'));

			eventspaceElem.append(findBoxElem);
			this.popuptextEnableArr.push(popupid);
			this.popupDragEvent(popupid);
		},
		
		popupDragEvent : function(id){
			
			if (viewUtils.device == 'pc' || viewUtils.device == 'ipad' || viewUtils.device == 'an_Tablet') {
				$('#'+id).draggable({
					start: function(e, ui) {},
					drag : function(e, ui){
						var changeLeft = ui.position.left - ui.originalPosition.left;
	                    var newLeft = ui.originalPosition.left + changeLeft / (( PARAM.transformInfo.scale));
	                    
	                    var changeTop = ui.position.top - ui.originalPosition.top;
	                    var newTop =  ui.originalPosition.top + changeTop / PARAM.transformInfo.scale;
	                    
	                    if( newLeft < 0 ) newLeft = 0;
	                    if( newTop < 0 ) newTop = 0;
	                    if( newLeft + $(this).width() > PARAM.onesizePage ) newLeft = PARAM.onesizePage - $(this).width();
	                    if( newTop + $(this).height() > PARAM.userModeInfo.h ) newTop = PARAM.userModeInfo.h - $(this).height();
	                                        
	                    ui.position.left = newLeft;
	                    ui.position.top = newTop;
					},
					stop : function(e, ui){}
				});
			}
		},
		
		textPopupRemove : function(romveid){
			var elemLinkDiv = document.getElementById(romveid);
			$(elemLinkDiv).remove();
			
			for(var pid in this.popuptextEnableArr){
				if(this.popuptextEnableArr[pid] == romveid) {
					this.popuptextEnableArr.splice(pid, 1);
					break;
				}
			}
		},
		
		allPopuptextRemove : function(){
			if( this.popuptextEnableArr.length <= 0 ) return false;
			
			for( var pid in this.popuptextEnableArr ){
				var elemLinkDiv = document.getElementById(this.popuptextEnableArr[pid]); 
				$(elemLinkDiv).remove();
			}
			
			this.popuptextEnableArr = [];
		}
	};
	
	/**************************************
	 printer
	***************************************/
	var printerProc = {
	    printerLib : null,
		printerElem : null,
		printerTitleElem : null,
		leftImgElem : null,
		rightImgElem : null,
		singleImgElem : null,
		radioBtnElem : null,
		
		type : '',
		
		init : function(){
			ADDONS.setLanguage("print");
			
			this.printerElem = $('#tool-printer');
			this.printerTitleElem = $('.printer-title-icon');
			this.leftImgElem = $('.printer-left-thumb img');
			this.rightImgElem = $('.printer-right-thumb img');
			this.singleImgElem = $('.printer-single-thumb img');
			this.radioBtnElem = $('.printer-radio-button');
			
			var modeSel = "iframe";
            if( viewUtils.browser == 'msie' || viewUtils.browser == 'safari' || viewUtils.browser == "firefox" || viewUtils.browser == "edge" ) modeSel = "popup";
            if( viewUtils.device != 'pc' ) modeSel = "iframe";
			this.printerLib = new wisebookPrint({printMode : modeSel, popTitle : PARAM.bookInfo.title });
			
			this.printerEvent();
			this.refresh();
		},
		
		setType : function(type){
			this.type = type;
			if( type == 'print' ){
				this.printerTitleElem.find('i').addClass('icon-view-view_i_print').removeClass('icon-view-view_i_pdfdivision');
				this.printerTitleElem.find('span').text(PARAM.viewLang.commonlang["view-lang-print"]);
				$('#printer-start').val(PARAM.viewLang.printlang["view-lang-send-print"]);			
			}else{
				this.printerTitleElem.find('i').addClass('icon-view-view_i_pdfdivision').removeClass('icon-view-view_i_print');
				this.printerTitleElem.find('span').text(PARAM.viewLang.commonlang["view-lang-pdfdivision"]);
				$('#printer-start').val(PARAM.viewLang.printlang["view-lang-send-pdfdivision"]);
			}
			
			this.printerChangeStatus();
		},
		
		printerEvent : function(){
			var  that = this;
			
			$(document).on(viewdefind.PAGE_BEFORE_EVENT, function(){ that.printerChangeStatus() });
			$(document).on(viewdefind.ADDONS_RESIZE, function(){ that.refresh(); });
			$(document).on('printer.destroy', function(){ that.destroy() });
			this.printerElem.on('tap', '.close-elem', function(){
				that.printerElem.css('display', 'none');
				that.type = '';
			});
			
			this.radioBtnElem.on('change', 'input:radio', function(){
				if( PARAM.bookInfo.config.single == 1 ) return false;
				that.printerThumbDisableStatus( $(this).data('thumb') );
			});
			
			PARAM.wisebook.on('tap', '#printer-start', function(){
				if( that.type == "" ) return false;
			
				var checkElem = that.radioBtnElem.find('input:checked'),
					page = checkElem.val();
				
				if( that.type == 'print' ){
					ADDONS.loadingImgView('show');
					that.printerLibSendImgData( page );
				}else{
					that.pdfLibSendImgData(page);
				}	
			});
		},
		
		printerChangeStatus : function(){
			if( this.type == '' ) return false;
			//thumb
			if( PARAM.viewMode == 'twopage' ){
				var pointnum = PARAM.getPointnum(PARAM.currentpage),
					centerpage = [],
					leftpage = PARAM.doublePair[pointnum].left,
					rightpage = PARAM.doublePair[pointnum].right;
				
				//left
				if( leftpage != 0 ){
					pageObj = htmlview._pages[leftpage-1];
					var leftThumb = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
					this.leftImgElem.attr('src', leftThumb).css('visibility', 'visible');
					this.radioBtnElem.removeClass('radio-hide-left');
					$('#printer-left-selecter').val(pageObj.countpage);
					centerpage.push(pageObj.countpage);
					
				}else {
					this.leftImgElem.attr('src', '').css('visibility', 'hidden');
					$('#printer-left-selecter').val(0);
					document.querySelector( '#printer-right-selecter' ).checked = true;
					this.radioBtnElem.addClass('radio-hide-left radio-hide-center');
					$('.printer-thumb').removeClass('not-printer-status');
				}
				
				//right
				if( rightpage != 0 ){
					pageObj = htmlview._pages[rightpage-1];
					var leftThumb = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
					this.rightImgElem.attr('src', leftThumb).css('visibility', 'visible');
					this.radioBtnElem.removeClass('radio-hide-right');
					$('#printer-right-selecter').val(pageObj.countpage);
					centerpage.push(pageObj.countpage);
				}else{
					this.rightImgElem.attr('src', '').css('visibility', 'hidden');
					$('#printer-right-selecter').val(0);
					document.querySelector( '#printer-left-selecter' ).checked = true;
					this.radioBtnElem.addClass('radio-hide-right radio-hide-center');
					$('.printer-thumb').removeClass('not-printer-status');
				}
				
				if( centerpage.length == 2 ){
					var checkElem = this.radioBtnElem.find('input:checked');
					if( checkElem.data('thumb') ) this.printerThumbDisableStatus( checkElem.data('thumb') );
					
					this.radioBtnElem.removeClass('radio-hide-left radio-hide-right radio-hide-center');
				}
				
				$('#printer-center-selecter').val( centerpage.join(',') );
			}else{
				pageObj = htmlview._pages[PARAM.currentpage-1];
				var singleTumb = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
				this.singleImgElem.attr('src', singleTumb);
				this.radioBtnElem.removeClass('radio-hide-center');
				$('.printer-thumb').removeClass('not-printer-status');
				
				var tmpRadioElem = document.querySelector( '#printer-center-selecter' );
				tmpRadioElem.checked = true;
				tmpRadioElem.value = PARAM.currentpage;
			}
		},
		
		printerThumbDisableStatus : function(thumbClass){
			if( thumbClass ){
				$('.printer-thumb').addClass('not-printer-status');
				$('.'+ thumbClass).removeClass('not-printer-status');
			}else $('.printer-thumb').removeClass('not-printer-status');
		},
		
		printerLibSendImgData : function(printPage){
    		var that = this,
    		    printPageList = printPage.split(',');
            
            this.printerLib.startPrinter({
                pageList : printPageList
            });
		},
		
		getPageObjSrcData : function(pagenum, srcData){
		    var that = this;
		        imageSrcData = new Array();
		
    		$.each(srcData, function(p, srcVal){
    			var dirname = that.dirname(location.href);
    			var imagePath = dirname+'/'+viewInfo.bookurl+pagenum+'/'+srcVal.src;
    			imageSrcData.push(imagePath);
    		});
    		
    		return imageSrcData;
		},
		
		dirname : function(path) {
            var result = path.replace(/\\/g, '/').replace(/\/[^/]*$/, '');
            if (result.match(/^[^/]*\.[^/\.]*$/)) {
                result = '';
            }
            return result;
        },
		
		pdfLibSendImgData : function( printPage ){
			var printPageList = printPage.split(',');
	        var in_pdf_src = '';
	
	        var ieFlag = false;
	        if (viewUtils.browser.indexOf('msie') == 0) {
				ieFlag = true;
	        }
	        if(printPageList.length == 1){
	        	var pagenum = printPage;
	        }else if(printPageList.length == 2){
	        	if(PARAM.bookInfo.config.direct){
					printPage = printPage.replace(",", "-");
				}else{
					printPage = printPageList[1]+'-'+printPageList[0];
				}
				
	            var pagenum = printPage;
	        }
	        
			// if( !ADDONS.isBookShelfFlag ){
			// 	//制作
			// 	if(viewInfo.printUrlFlag){
			// 		in_pdf_src = viewInfo.bookurl+'src/'+PARAM.bookInfo.bookid+'_'+pagenum+'.pdf';
			// 	}else in_pdf_src = "/library/pdfdown/" + PARAM.bookInfo.author + "/" + PARAM.bookInfo.bookid + "/" + pagenum + "/pdf";
				
			// }else{
			// 	//配信
			// 	in_pdf_src = viewInfo.bookurl+'src/'+PARAM.bookInfo.bookid_orig+'_'+pagenum+'.pdf';
			// }
	        
	        var bookId = PARAM.bookInfo.bookid;

	        if (typeof PARAM.bookInfo.bookid_orig != 'undefined') 
	        	bookId = PARAM.bookInfo.bookid_orig

	        in_pdf_src = PARAMLIBRARY.createViewInfo.objcontents.stream_url + 'src/' + bookId + '_' + pagenum + '.pdf';	

	        if (ieFlag == true) { 
				this.gotoIeWindowsOpen(in_pdf_src);
	        } else {
	        	if (viewUtils.browser == 'chrome'){
	                viewMessageProc.confirm( PARAM.viewLang.externalLink, PARAM.viewLang.confirm_title, 
	                    function(){
	                        window.open(in_pdf_src, '_system', 'location=yes');
	                    }
	                );
	        		return;	
	        	} 
	            PARAM.openInside(in_pdf_src);	        	
	        }
	        return false;
		},
		
		gotoIeWindowsOpen: function(url) {
	        var referLink = document.createElement('a');
	        referLink.href = url;
	        referLink.target = '_blank';
	        document.body.appendChild(referLink);
	        referLink.click();
	    },
		
		refresh : function(){
			this.printerChangeStatus();
		},
		
		destroy : function(){
		    delete this.printerLib;
		    
			var events = [
				"printer.destroy"
			];
			
			for( var e in  events){
				$(document).unbind(events[i]);
			}
			
			this.printerElem.unbind('tap');
			this.radioBtnElem.unbind('tap');
		}
	};
	
	/**************************************
	 productsearch
	***************************************/
	var productsearchProc = {
	    itemElement : document.createElement('div'),
	    
    	init : function(){
    	    var that = this;
			var url = viewPath + 'v2_viewhtml/items/productsearch/productsearch-item.html';
						
			htmlview.getHtml(url, function(data){
			    that.itemElement.innerHTML = data;
			});
			
			if( viewUtils.Mobile ) {
			    this.productSearchPhoneSetting();
			    this.productsearchPhoneEvent();
			}else{
			    ADDONS.setLanguage('productsearchlang');
    			this.productSearchElem = $('#view-productsearch-table');
    			this.productsearchPcTabletEvent();
    			this.settingProductCategory();
			}
    	},
    	
    	productSearchPhoneSetting : function(){
    	    var that = this,
        	    url = viewPath + 'v2_viewhtml/items/productsearch/productsearch-subnav-phone.html';
            
			htmlview.getHtml(url, function(data){
				var productSearchhpopupElem = $('.view-popup-productsearch');
				productSearchhpopupElem.find('.view-productsearch-subnavbar').html(data);
				productSearchhpopupElem.find('.view-through').remove();
				ADDONS.setPlaceholder();
				ADDONS.setLanguage('productsearchlang');
				that.settingProductCategory();
			});
    	},
    	
    	settingProductCategory : function(){
    	    var cateList = PARAM.bookInfo.productsearch.categorylist.split(','),
    	        categoryElem = $('.productsearch-category');
        	
        	for( var c in cateList ){
            	categoryElem.append('<option value="'+cateList[c]+'">'+cateList[c]+'</option>');
        	}
    	},    	
    	
    	productsearchPcTabletEvent : function(){
    	    var that = this;
            PARAM.wisebook.on('tap', '#product-search-btn, #product-reset-btn, .productsearch-item-infos', function(){
                if( this.id == "product-search-btn" ) that.productSearchProcess();
                else if( this.id == "product-reset-btn" ){
                    $('.productsearch-product-input').val('');
                    $('.productsearch-productnumber-input').val('');
                    $('.productsearch-price-from-input').val('');
                    $('.productsearch-price-to-input').val('');
                    $('.productsearch-category').val('all');
                    that.productSearchElem[0].innerHTML = '';
                }else if( $(this).hasClass('productsearch-item-infos') ){
                    ADDONS.sendGotopage( parseInt( $(this).attr('data-page') ) );    
                }
            });
            
            if( viewUtils.device === 'pc' ){
                PARAM.wisebook.on('keypress', '.productsearch-product-input, .productsearch-productnumber-input, .productsearch-price-from-input, .productsearch-price-to-input', function(e){
                    if(e.keyCode == 13) {
                        that.productSearchProcess();
                    }
                });
            }
    	},
    	
    	productsearchPhoneEvent : function(){
    	    var that = this;
            PARAM.wisebook.on('tap', '#product-search-btn, #product-reset-btn, .productsearch-item-infos', function(){
                var clicked = $(this);
                if( this.id == "product-search-btn" ) {
                    ADDONS.clicked = clicked;
                    ADDONS.viewpanel( clicked );
                }else if( this.id == "product-reset-btn" ){
                    $('.productsearch-product-input').val('');
                    $('.productsearch-productnumber-input').val('');
                    $('.productsearch-price-from-input').val('');
                    $('.productsearch-price-to-input').val('');
                    $('.productsearch-category').val('all');
                    if( that.productSearchElem ) that.productSearchElem[0].innerHTML = '';
                    that.productSearchElem = null;
                }else if( $(this).hasClass('productsearch-item-infos') ){
                    ADDONS.closePanel();
                    ADDONS.sendGotopage( parseInt( $(this).attr('data-page') ) );    
                }
            });
            
			if( appFlag == false ){
				$(document).bind(viewdefind.VIEW_POPUP_OPEN, function(){
	                if( PARAM.nowBusy != 'productsearch' ) return false;
	                
				    if( viewUtils.androidInfo.check && viewUtils.Mobile ){
				        PARAM.isResizeWork = false;
				    }    
				 });
				 
				$(document).bind(viewdefind.VIEW_POPUP_CLOSE, function(){ 
	                if( PARAM.nowBusy != 'productsearch' ) return false;
	                 
	                if( viewUtils.androidInfo.check && viewUtils.Mobile ){
				        PARAM.isResizeWork = true;
				    }
				});
			}
            
    	},
    	
    	productSearchProcessBefore : function(elem){			
        	this.productSearchElem = elem.find('#view-productsearch-table');
        	this.productSearchProcess();
    	},
    	
    	unformat : function(value, decimal){
    		if (Array.isArray(value)) {
    			return map(value, function(val) {
    				return unformat(val, decimal);
    			});
    		}
    
    		value = value || 0;
    		if (typeof value === "number") return value;
    
    		decimal = decimal || '.';
    		var regex = new RegExp("[^0-9-" + decimal + "]", ["g"]),
    			unformatted = parseFloat(
    				("" + value)
    				.replace(/\((.*)\)/, "-$1") 
    				.replace(regex, '')
    				.replace(decimal, '.')
    			);
    
    		return !isNaN(unformatted) ? unformatted : 0;
    	},
    	
    	productSearchProcess : function(){
            var productItemList = PARAM.bookInfo.productsearch.productlist,
                productsearchData = [],
                productVal = $('.productsearch-product-input').val(),
        	    productNumVal = $('.productsearch-productnumber-input').val(),
        	    productCate = $('.productsearch-category').val(),
        	    productPriceFrom = ( $('.productsearch-price-from-input').val() == "" ) ? 0 : parseInt( $('.productsearch-price-from-input').val() ),
        	    productPriceTo = ( $('.productsearch-price-to-input').val() == "" ) ? 0 : parseInt( $('.productsearch-price-to-input').val() );
            
            for( var p in productItemList ){
                var tmpdata = productItemList[p],
                    checkInputData = true,
                    objPrice = this.unformat(tmpdata.price),
                    regVal;
                
                if( productCate != "all" && tmpdata.category != productCate ) continue;
                
                if( productVal != "" ){
    				regVal = new RegExp( productVal, 'ig');
                    if( !tmpdata.product.match( regVal ) ) checkInputData = false;
				}
                if( productNumVal != "" ){
    				regVal = new RegExp( productNumVal.toLowerCase(), 'ig');
    				if( !tmpdata.productnumber.toLowerCase().match( regVal ) ) checkInputData = false;
				}
                
                if( productPriceFrom > 0 &&  objPrice < productPriceFrom  ) {
                    checkInputData = false;
                }
                if( productPriceTo > 0 &&  objPrice > productPriceTo  ) {
                    checkInputData = false;
                }
                
                if( checkInputData ) productsearchData.push(tmpdata);                
            }
            
            if( productsearchData.length > 0 ) this.createProductsearch(productsearchData);
            else this.productSearchElem.text( PARAM.viewLang.notProductSearch );
    	},
    	
    	createProductsearch : function(obj){
        	this.productSearchElem[0].innerHTML = '';
        	var _tempElement = document.createElement('div');
        	
        	for( var l in obj ){
        	    _tempElement.innerHTML = '';
        	    _tempElement.innerHTML = this.itemElement.innerHTML;
        	    
        	    var findBoxElem = htmlview.findElement('.productsearch-item-infos', _tempElement);
        	    
        	    pageObj = htmlview._pages[obj[l].page-1];
				var src = viewInfo.bookurl+pageObj.number+'/thumb.jpg';
        	    findBoxElem.attr('data-page', pageObj.countpage);
        	    findBoxElem.find('.productsearch-item-thumb img').attr('src', src);
        	    findBoxElem.find('.productsearch-product').text(obj[l].product);
        	    findBoxElem.find('.productsearch-productnumber').text( PARAM.viewLang.productsearchlang["view-lang-productnumber-text"] +' : '+ obj[l].productnumber );
        	    findBoxElem.find('.productsearch-productcategory').text( PARAM.viewLang.productsearchlang["view-lang-productcategory-text"] +' : '+ obj[l].category );
        	    findBoxElem.find('.productsearch-productprice').text( PARAM.viewLang.productsearchlang["view-lang-productprice-text"] +' : '+ obj[l].price );
        	    findBoxElem.find('.productsearch-productpage').text( PARAM.viewLang.sliderPageLang + ' : ' + pageObj.label );
        	    this.productSearchElem.append(findBoxElem);
        	}
    	}
	};

	/**************************************
	*custom telop
	*旧ビューアはjquery.wisebookAddOns.jsに実装
	***************************************/
	var customTelopProc = {
		preview : "help_div",
		isShow : false,
		itemElement : document.createElement('div'),

		init : function(){
			var that = this;

			var url = viewPath + 'v2_viewhtml/items/customtelop/customtelop-item.html';
						
			htmlview.getHtml(url, function(data){
			    that.itemElement.innerHTML = data;
			});


			$(document).bind(viewdefind.OPEN_CUSTIMTELOP, function(e, postion, obj){
				that.openCustomTelop(postion, obj);			
			});

			$(document).bind(viewdefind.CLOSE_CUSTIMTELOP, function(e, obj){
				that.closeCustomTelop();				
			});
			
			$(document).on('mouseleave.viewer', '#'+this.preview, function() {
				that.closeCustomTelop();
			});
		},

		openCustomTelop : function(e, info){
			if( this.isShow ) return false;

			PARAM.wisebook.append(this.itemElement.innerHTML);
			
			var hp_textElem = document.getElementById("help_text");
			hp_textElem.innerHTML = info.action.customtelop.replace(/\r\n/g,'\n').replace(/\n/g,'<br>');

			var hb = document.getElementById(this.preview);
			hb.style.display="";
			var evt = e ? e : window.event;
			var posx=0;
			var posy=0;

			if (evt.pageX || evt.pageY) { 
				posx = evt.pageX;
				posy = evt.pageY;
			} else if (evt.clientX || evt.clientY) { 
				posx = evt.clientX;
				posy = evt.clientY;
				if (window.event) { 
					posx += document.body.scrollLeft;
					posy += document.body.scrollTop;
				}
			}
			// dw = document.body.scrollLeft + document.body.clientWidth;
			// if (posx + hb.clientWidth > dw) posx = dw - hb.clientWidth;
			// ax = (evt.pageX ? evt.pageX : evt.clientX) - posx;
			// if (ax <= 0) ax = 0;
			// document.getElementById("help_div_arrow").style.paddingLeft = ax + "px";

			var actualpos = PARAM.getLookPosByActualPos(info.x, info.y, info.width, info.height);
			var limitPos = this.limitPos(actualpos, posx, posy);

			hb.style.left = limitPos.x + "px";
			hb.style.top = limitPos.y + "px";
			this.isShow = true;
		},
		
		limitPos : function(currentItemPos, x, y) {
			var helpBoxH = $('#'+this.preview).height();
			var itemH = currentItemPos.h;
			var pos = {x: x, y: y};
			
			if (y+helpBoxH > PARAM.imageHeight) {
				pos.y = PARAM.imageHeight - helpBoxH;
			}/* else {
				pos.y = currentItemPos.h + currentItemPos.y;
			}*/
			
			return pos;
		},

		closeCustomTelop : function(){
			this.isShow = false;
			$('#'+this.preview).remove();
		}
	}
})();
