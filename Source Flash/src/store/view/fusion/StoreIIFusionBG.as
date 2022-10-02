package store.view.fusion
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.StrengthDataManager;
   import store.data.PreviewInfoII;
   import store.events.StoreIIEvent;
   import store.view.shortcutBuy.ShortcutBuyFrame;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class StoreIIFusionBG extends Sprite implements IStoreViewBG
   {
      
      private static const ITEMS:Array = [11301,11302,11303,11304,11201,11202,11203,11204];
      
      private static const ZOMM:Number = 0.75;
      
      public static var lastIndexFusion:int = -1;
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _accessoryFrameII:AccessoryFrameII;
      
      private var _fusion_btn:BaseButton;
      
      private var _fusionHelp:BaseButton;
      
      private var fusionShine:MovieImage;
      
      private var fusionArr:MutipleImage;
      
      private var gold_txt:FilterFrameText;
      
      private var _goodName:FilterFrameText;
      
      private var _goodRate:FilterFrameText;
      
      private var _autoFusion:Boolean;
      
      private var _autoSelect:Boolean;
      
      private var _autoCheck:SelectedCheckButton;
      
      private var _pointArray:Vector.<Point>;
      
      private var _gold:int = 400;
      
      private var _maxCell:int = 0;
      
      private var _resulteFusion:Boolean = false;
      
      private var _ckAutoSplit:SelectedCheckButton;
      
      private var _isAutoSplit:Boolean = false;
      
      private var _windowTime:int;
      
      private var _itemsPreview:Array;
      
      public function StoreIIFusionBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public static function autoSplitSend(param1:int, param2:int, param3:int, param4:String, param5:int, param6:Boolean = false, param7:IStoreViewBG = null) : void
      {
         var _loc8_:Array = getAutoSplitSendParam(param4,param5);
         var _loc9_:int = 0;
         var _loc10_:Array = param4.split(",");
         if(_loc10_.length == 4)
         {
            if(_loc8_)
            {
               clearFusion(param7);
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  if(_loc8_[_loc9_] > 0)
                  {
                     SocketManager.Instance.out.sendMoveGoods(param1,param2,param3,_loc9_ + 1,_loc8_[_loc9_],param6);
                  }
                  _loc9_++;
               }
            }
         }
         else if(_loc8_)
         {
            clearFusion(param7,_loc10_);
            _loc9_ = 0;
            while(_loc9_ < _loc8_.length)
            {
               if(_loc8_[_loc9_] > 0)
               {
                  SocketManager.Instance.out.sendMoveGoods(param1,param2,param3,_loc10_[_loc9_],_loc8_[_loc9_],param6);
               }
               _loc9_++;
            }
         }
         lastIndexFusion = -1;
      }
      
      public static function getRemainIndexByEmpty(param1:int, param2:IStoreViewBG) : String
      {
         var _loc5_:StoreCell = null;
         var _loc6_:int = 0;
         if(param1 >= 4)
         {
            return "1,2,3,4";
         }
         var _loc3_:String = "";
         var _loc4_:Array = [];
         if(param2 is StoreIIFusionBG)
         {
            _loc6_ = 1;
            while(_loc6_ < 5)
            {
               _loc5_ = (param2 as StoreIIFusionBG).area[_loc6_];
               if(!_loc5_.info)
               {
                  _loc4_.push(_loc5_.index);
               }
               _loc6_++;
            }
            switch(param1)
            {
               case 2:
                  _loc3_ = _loc4_.concat(findDiff(_loc4_)).slice(0,param1).splice(",");
                  break;
               case 3:
                  _loc3_ = _loc4_.concat(findDiff(_loc4_)).slice(0,param1).splice(",");
            }
         }
         return _loc3_;
      }
      
      private static function findDiff(param1:Array) : Array
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 1;
         while(_loc3_ < 5)
         {
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if(_loc3_ == int(param1[_loc5_]))
               {
                  _loc4_ = true;
               }
               _loc5_++;
            }
            if(!_loc4_)
            {
               _loc2_.push(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function getAutoSplitSendParam(param1:String, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Array = param1.split(",");
         if(_loc4_ && param2 >= 1)
         {
            _loc5_ = param2 % _loc4_.length;
            _loc6_ = int(param2 / _loc4_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc3_.push(_loc6_ + getRemainCellNumber(_loc5_--));
               _loc7_++;
            }
         }
         return _loc3_;
      }
      
      private static function getRemainCellNumber(param1:int) : int
      {
         return param1 > 0 ? int(int(1)) : int(int(0));
      }
      
      private static function clearFusion(param1:IStoreViewBG, param2:Array = null) : void
      {
         var _loc3_:StoreCell = null;
         var _loc4_:int = 0;
         if(!param2)
         {
            _loc4_ = 1;
            while(_loc4_ < 5)
            {
               _loc3_ = (param1 as StoreIIFusionBG).area[_loc4_];
               if(_loc3_.info)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc3_.index,_loc3_.itemBagType,-1);
               }
               _loc4_++;
            }
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc4_ = 1;
            while(_loc4_ < 5)
            {
               _loc3_ = (param1 as StoreIIFusionBG).area[_loc4_];
               if(_loc3_.info && _loc3_.index == int(param2[_loc5_]))
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,_loc3_.index,_loc3_.itemBagType,-1);
                  break;
               }
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      public function get isAutoSplit() : Boolean
      {
         return this._isAutoSplit;
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:StoreCell = null;
         this._items = [];
         this.getCellsPoint();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = new FusionItemCellII(_loc1_);
            }
            else if(_loc1_ == 5)
            {
               _loc2_ = new FusionItemCell(_loc1_);
               _loc2_.scaleX = _loc2_.scaleY = ZOMM;
               FusionItemCell(_loc2_).mouseEvt = false;
               FusionItemCell(_loc2_).bgVisible = false;
            }
            else
            {
               _loc2_ = new FusionItemCell(_loc1_);
            }
            _loc2_.x = this._pointArray[_loc1_].x;
            _loc2_.y = this._pointArray[_loc1_].y;
            addChild(_loc2_);
            if(_loc1_ != 5)
            {
               _loc2_.addEventListener(Event.CHANGE,this.__itemInfoChange);
            }
            this._items.push(_loc2_);
            _loc1_++;
         }
         this._accessoryFrameII = new AccessoryFrameII();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this._fusion_btn = ComponentFactory.Instance.creatComponentByStylename("store.FusionBtn");
         addChild(this._fusion_btn);
         this._fusionHelp = ComponentFactory.Instance.creatComponentByStylename("store.StrengthNodeBtn");
         addChild(this._fusionHelp);
         this.fusionShine = ComponentFactory.Instance.creatComponentByStylename("store.StrengthButtonShine");
         this.fusionShine.mouseChildren = this.fusionShine.mouseEnabled = false;
         addChild(this.fusionShine);
         this.fusionArr = ComponentFactory.Instance.creatComponentByStylename("store.ArrowHeadFusionTip");
         addChild(this.fusionArr);
         this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("store.FusionneedMoneyTxt");
         addChild(this.gold_txt);
         this._goodName = ComponentFactory.Instance.creatComponentByStylename("store.PreviewNameTxt");
         addChild(this._goodName);
         this._goodRate = ComponentFactory.Instance.creatComponentByStylename("store.PreviewSuccessRateTxt");
         addChild(this._goodRate);
         this._autoCheck = ComponentFactory.Instance.creatComponentByStylename("store.AutoOpenButton");
         addChild(this._autoCheck);
         this._ckAutoSplit = ComponentFactory.Instance.creat("store.SellLeftAlerAutoSplitCk");
         addChild(this._ckAutoSplit);
         this._ckAutoSplit.selected = this._isAutoSplit;
         this.hideArr();
         this.hide();
      }
      
	  
      private function initEvent() : void
      {
         this._fusion_btn.addEventListener(MouseEvent.CLICK,this.__fusionClick);
         this._accessoryFrameII.addEventListener(StoreIIEvent.ITEM_CLICK,this.__accessoryItemClick);
         this._fusionHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         this._ckAutoSplit.addEventListener(Event.SELECT,this.__autoSplit);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,this.__upPreview);
         StrengthDataManager.instance.addEventListener(StrengthDataManager.FUSIONFINISH,this.__fusionFinish);
      }
      
      private function removeEvents() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._fusion_btn.removeEventListener(MouseEvent.CLICK,this.__fusionClick);
         this._accessoryFrameII.removeEventListener(StoreIIEvent.ITEM_CLICK,this.__accessoryItemClick);
         this._fusionHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         this._autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,this.__upPreview);
         StrengthDataManager.instance.removeEventListener(StrengthDataManager.FUSIONFINISH,this.__fusionFinish);
         if(this._ckAutoSplit)
         {
            this._ckAutoSplit.removeEventListener(Event.SELECT,this.__autoSplit);
         }
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_FUSION) && TaskManager.isAchieved(TaskManager.getQuestByID(350)))
         {
            NewHandQueue.Instance.push(new Step(Step.FUSION_ITEM_TIP,this.exeItemTip,this.preItemTip,this.finItemTip));
         }
      }
      
      private function preItemTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.FUS_ITEM,0,"trainer.fusItemArrowPos","asset.trainer.txtFusItemTip","trainer.fusItemTipPos");
      }
      
      private function exeItemTip() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.checkItemEmpty() >= 4)
         {
            _loc1_ = PlayerManager.Instance.Self.StoreBag.items[1].FusionType;
            _loc2_ = 2;
            while(_loc2_ <= 4)
            {
               if(_loc1_ != PlayerManager.Instance.Self.StoreBag.items[_loc2_].FusionType)
               {
                  return false;
               }
               _loc2_++;
            }
            return true;
         }
         return false;
      }
      
      private function finItemTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.FUS_ITEM);
         NewHandQueue.Instance.dispose();
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("store.Fusionpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function __buyBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:ShortcutBuyFrame = ComponentFactory.Instance.creatCustomObject("store.ShortcutBuyFrame");
         _loc2_.show(ITEMS,true,LanguageMgr.GetTranslation("store.view.fusion.buyFormula"),4);
      }
      
      /*public function dragDrop(param1:BagCell) : void
      {
         var _loc3_:StoreCell = null;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(this._accessoryFrameII.containsItem(param1.itemInfo))
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         for each(_loc3_ in this._items)
         {
            if(_loc3_.info == _loc2_)
            {
               _loc3_.info = null;
               param1.locked = false;
               return;
            }
         }
         _loc4_ = 1;
         for(; _loc4_ < 5; _loc4_++)
         {
            _loc3_ = this._items[_loc4_];
            if(_loc3_ is FusionItemCell)
            {
               if(_loc2_.getRemainDate() > 0)
               {
                  if(!(_loc2_.FusionType != 0 && _loc2_.FusionRate != 0))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
                  }
                  if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
                  {
                     this.__moveGoods(_loc2_,1);
                     DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                     return;
                  }
                  if(_loc3_.info == null)
                  {
                     this.__moveGoods(_loc2_,_loc3_.index);
                     DragManager.acceptDrag(_loc3_,DragEffect.NONE);
                     return;
                  }
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
               continue;
               continue;
               return;
            }
         }
      }*/
	  
	  public function dragDrop(param1:BagCell) : void
	  {
		  var _loc2_:* = null;
		  var _loc3_:int = 0;
		  if(param1 == null)
		  {
			  return;
		  }
		  if(_accessoryFrameII.containsItem(param1.itemInfo))
		  {
			  return;
		  }
		  var _loc4_:InventoryItemInfo = param1.info as InventoryItemInfo;
		  for each(_loc2_ in _items)
		  {
			  if(_loc2_.info == _loc4_)
			  {
				  _loc2_.info = null;
				  param1.locked = false;
				  return;
			  }
		  }
		  _loc3_ = 1;
		  while(_loc3_ < 5)
		  {
			  _loc2_ = _items[_loc3_];
			  if(_loc2_ is FusionItemCell)
			  {
				  if(_loc4_.getRemainDate() <= 0)
				  {
					  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
				  }
				  else
				  {
					  if(!(_loc4_.FusionType != 0 && _loc4_.FusionRate != 0))
					  {
						  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
						  return;
					  }
					  if(_items[1].info != null && _items[2].info != null && _items[3].info != null && _items[4].info != null)
					  {
						  __moveGoods(_loc4_,1);
						  DragManager.acceptDrag(_loc2_,"none");
						  return;
					  }
					  if(_loc2_.info == null)
					  {
						  __moveGoods(_loc4_,_loc2_.index);
						  DragManager.acceptDrag(_loc2_,"none");
						  return;
					  }
				  }
			  }
			  _loc3_++;
		  }
	  }
      
      private function __moveGoods(param1:InventoryItemInfo, param2:int) : void
      {
         var _loc3_:FusionSelectNumAlertFrame = null;
         if(StrengthDataManager.instance.autoFusion)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
            return;
         }
         if(param1.Count > 1 && !this._isAutoSplit)
         {
            _loc3_ = ComponentFactory.Instance.creat("store.FusionSelectNumAlertFrame");
            _loc3_.goodsinfo = param1;
            _loc3_.index = param2;
            _loc3_.show(param1.Count);
            _loc3_.addEventListener(FusionSelectEvent.SELL,this._alerSell);
            _loc3_.addEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         }
         else if(param1.Count > 1 && this._isAutoSplit)
         {
            autoSplitSend(param1.BagType,param1.Place,BagInfo.STOREBAG,getRemainIndexByEmpty(param1.Count,this),param1.Count,true,this);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(param1.BagType,param1.Place,BagInfo.STOREBAG,param2,param1.Count,true);
         }
      }
      
      private function _alerSell(param1:FusionSelectEvent) : void
      {
         var _loc2_:FusionSelectNumAlertFrame = param1.currentTarget as FusionSelectNumAlertFrame;
         SocketManager.Instance.out.sendMoveGoods(param1.info.BagType,param1.info.Place,BagInfo.STOREBAG,param1.index,param1.sellCount,true);
         _loc2_.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _loc2_.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function _alerNotSell(param1:FusionSelectEvent) : void
      {
         var _loc2_:FusionSelectNumAlertFrame = param1.currentTarget as FusionSelectNumAlertFrame;
         _loc2_.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _loc2_.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function _showDontClickTip() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = this.checkItemEmpty();
         if(_loc1_ == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.noEquip"));
            return true;
         }
         if(_loc1_ < 4)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.notEnoughStone"));
            return true;
         }
         if(_loc1_ == 4)
         {
            _loc2_ = PlayerManager.Instance.Self.StoreBag.items[1].FusionType;
            _loc3_ = 5;
            _loc4_ = 2;
            while(_loc4_ < _loc3_)
            {
               if(_loc2_ != PlayerManager.Instance.Self.StoreBag.items[_loc4_].FusionType)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.notSameStone"));
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      private function showIt() : void
      {
         this.showArr();
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ < 5)
            {
               this._items[_loc3_].info = PlayerManager.Instance.Self.StoreBag.items[_loc3_];
            }
            else
            {
               this._accessoryFrameII.setItemInfo(_loc3_,PlayerManager.Instance.Self.StoreBag.items[_loc3_]);
            }
         }
         if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
         {
            if(this._items[0].info != null)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,FusionItemCellII(this._items[0]).index,FusionItemCellII(this._items[0]).itemBagType,-1);
            }
            this.__previewRequest();
            _loc4_ = PlayerManager.Instance.Self.StoreBag.items[1].FusionType;
            _loc5_ = 5;
            _loc6_ = 2;
            while(_loc6_ < _loc5_)
            {
               if(_loc4_ != PlayerManager.Instance.Self.StoreBag.items[_loc6_].FusionType)
               {
                  this._clearPreview();
               }
               _loc6_++;
            }
         }
         else
         {
            this._clearPreview();
            this.autoFusion = false;
         }
      }
      
      private function __fusionFinish(param1:Event) : void
      {
         if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
         {
            this.__checkAuto();
         }
         else
         {
            this._clearPreview();
            this.autoFusion = false;
         }
      }
      
      private function __checkAuto() : void
      {
         var auto:Function = null;
         if(this.autoFusion)
         {
            auto = function():void
            {
               __fusionClick(null);
            };
            this._windowTime = setTimeout(auto,1000);
         }
      }
      
      public function updateData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._items[_loc1_].info = PlayerManager.Instance.Self.StoreBag.items[_loc1_];
            _loc1_++;
         }
         var _loc2_:int = 5;
         while(_loc2_ < 11)
         {
            this._accessoryFrameII.setItemInfo(_loc2_,PlayerManager.Instance.Self.StoreBag.items[_loc2_ + 5]);
            _loc2_++;
         }
      }
      
      public function startShine(param1:int) : void
      {
         this._items[param1].startShine();
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._items[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      private function showArr() : void
      {
         if(this.autoFusion)
         {
            return;
         }
         this.fusionArr.visible = true;
         this.fusionShine.movie.play();
      }
      
      private function hideArr() : void
      {
         this.fusionArr.visible = false;
         this.fusionShine.movie.gotoAndStop(1);
      }
      
      public function show() : void
      {
         this.visible = true;
         this.updateData();
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.userGuide();
         }
      }
      
      public function hide() : void
      {
         this.autoFusion = false;
         this.visible = false;
         this._accessoryFrameII.hide();
         this.disposeUserGuide();
      }
      
      private function __upPreview(evt:CrazyTankSocketEvent) : void
      {
		  var isBin:Boolean = false;
		  var info:PreviewInfoII = null;
		  var info1:PreviewInfoII = null;
		  this.hideArr();
		  var count:int = evt.pkg.readInt();
		  this._itemsPreview = new Array();
		  for(var i:int = 0; i < count; i++)
		  {
			  info = new PreviewInfoII();
			  info.data(evt.pkg.readInt(),evt.pkg.readInt());
			  info.rate = evt.pkg.readInt();
			  this._itemsPreview.push(info);
		  }
		  isBin = evt.pkg.readBoolean();
		  for(var j:int = 0; j < this._itemsPreview.length; j++)
		  {
			  info1 = this._itemsPreview[j] as PreviewInfoII;
			  info1.info.IsBinds = isBin;
		  }
		  this._showPreview();
		  this.showArr();
      }
      
      private function _showPreview() : void
      {
         this._items[5].info = this._itemsPreview[0].info;
         this._goodName.text = String(this._itemsPreview[0].info.Name);
         this._goodRate.text = this._itemsPreview[0].rate <= 5 ? LanguageMgr.GetTranslation("store.fusion.preview.LowRate") : String(this._itemsPreview[0].rate) + "%";
      }
      
      private function _clearPreview() : void
      {
         this._items[5].info = null;
         this._goodName.text = "";
         this._goodRate.text = "0%";
      }
      
      private function __accessoryItemClick(param1:StoreIIEvent) : void
      {
         this.gold_txt.text = String((this.checkItemEmpty() + this._accessoryFrameII.getCount()) * this._gold);
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.checkItemEmpty();
         this.gold_txt.text = String((_loc2_ + this._accessoryFrameII.getCount()) * this._gold);
         this._clearPreview();
         this.hideArr();
      }
      
      private function checkItemEmpty() : int
      {
         var _loc1_:int = 0;
         if(PlayerManager.Instance.Self.StoreBag.items[1] != null)
         {
            _loc1_++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[2] != null)
         {
            _loc1_++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[3] != null)
         {
            _loc1_++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[4] != null)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      private function isAllBinds() : int
      {
         var _loc1_:int = 0;
         if(this._items[1].info != null && this._items[1].info.IsBinds)
         {
            _loc1_++;
         }
         if(this._items[2].info != null && this._items[2].info.IsBinds)
         {
            _loc1_++;
         }
         if(this._items[3].info != null && this._items[3].info.IsBinds)
         {
            _loc1_++;
         }
         if(this._items[4].info != null && this._items[4].info.IsBinds)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      private function __fusionClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = null;
         var _loc4_:BaseAlerFrame = null;
         if(param1 != null)
         {
            param1.stopImmediatePropagation();
         }
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(PlayerManager.Instance.Self.Gold < (this._accessoryFrameII.getCount() + 4) * this._gold)
         {
            this.autoFusion = false;
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         if(this.isAllBinds() != 0 && this.isAllBinds() != 4)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
            return;
         }
         if(this._accessoryFrameII.isBinds && this.isAllBinds() != 4)
         {
            _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_.addEventListener(FrameEvent.RESPONSE,this._response);
            return;
         }
         this.sendFusionRequest();
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc1_.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendFusionRequest();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function testingSXJ() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            if(EquipType.isRongLing(this._items[_loc2_].info))
            {
               _loc1_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function sendFusionRequest() : void
      {
         SocketManager.Instance.out.sendItemFusion(1);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_FUSION))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_FUSION);
         }
         if(this.autoSelect)
         {
            this.autoFusion = true;
            this._fusion_btn.enable = false;
            this.hideArr();
         }
      }
      
      private function __previewRequest() : void
      {
         SocketManager.Instance.out.sendItemFusion(0);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.autoSelect = this._autoCheck.selected;
         if(this.autoSelect == false)
         {
            this.autoFusion = false;
         }
      }
      
      private function __autoSplit(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._isAutoSplit = this._ckAutoSplit.selected;
         StoreIIFusionBG.lastIndexFusion = -1;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
         this._autoSelect = param1;
      }
      
      public function get autoSelect() : Boolean
      {
         return this._autoSelect;
      }
      
      public function set autoFusion(param1:Boolean) : void
      {
         this._autoFusion = param1;
         StrengthDataManager.instance.autoFusion = this._autoFusion;
         if(!this._autoFusion)
         {
            this._fusion_btn.enable = true;
            clearTimeout(this._windowTime);
            if(this._items[5].info != null)
            {
               this.showArr();
            }
         }
      }
      
      public function get autoFusion() : Boolean
      {
         return this._autoFusion;
      }
      
      private function __openHelp(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("store.fushionHelp");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("store.helpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.say");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         StoreIIFusionBG.lastIndexFusion = -1;
         this.removeEvents();
         this.disposeUserGuide();
         clearTimeout(this._windowTime);
         if(this._area)
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(this._accessoryFrameII)
         {
            ObjectUtils.disposeObject(this._accessoryFrameII);
         }
         this._accessoryFrameII = null;
         if(this._fusion_btn)
         {
            ObjectUtils.disposeObject(this._fusion_btn);
         }
         this._fusion_btn = null;
         if(this._fusionHelp)
         {
            ObjectUtils.disposeObject(this._fusionHelp);
         }
         this._fusionHelp = null;
         if(this.fusionShine)
         {
            ObjectUtils.disposeObject(this.fusionShine);
         }
         this.fusionShine = null;
         if(this.fusionArr)
         {
            ObjectUtils.disposeObject(this.fusionArr);
         }
         this.fusionArr = null;
         if(this.gold_txt)
         {
            ObjectUtils.disposeObject(this.gold_txt);
         }
         this.gold_txt = null;
         if(this._goodName)
         {
            ObjectUtils.disposeObject(this._goodName);
         }
         this._goodName = null;
         if(this._goodRate)
         {
            ObjectUtils.disposeObject(this._goodRate);
         }
         this._goodRate = null;
         if(this._autoCheck)
         {
            ObjectUtils.disposeObject(this._autoCheck);
         }
         this._autoCheck = null;
         if(this._ckAutoSplit)
         {
            ObjectUtils.disposeObject(this._ckAutoSplit);
            this._ckAutoSplit = null;
         }
         this._pointArray = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
