package ddt.view.caddyII.offerPack
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyBagView;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.LookTrophy;
   import ddt.view.caddyII.RightView;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import store.view.ConsortiaRateManager;
   
   public class OfferPackViewII extends RightView
   {
      
      public static const OFFER_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0.1;
      
      public static const SELECT_SCALE_NUMBER:Number = 0.05;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _gridBGI:ScaleBitmapImage;
      
      private var _gridBGII:ScaleBitmapImage;
      
      private var _openBtn:BaseButton;
      
      private var _lookTrophy:LookTrophy;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectGoodsInfo:InventoryItemInfo;
      
      private var _effect:IEffect;
      
      private var _movie:MovieImage;
      
      private var _turnSprite:Sprite;
      
      private var _turnBG:ScaleFrameImage;
      
      private var _selectSprite:Sprite;
      
      private var _selectCell:BaseCell;
      
      private var _offerNumber:int;
      
      private var _packNumber:int;
      
      private var _selectNumber:int = -1;
      
      private var _endFrame:int;
      
      private var _startY:int;
      
      private var _consortiaManagerBtn:BaseButton;
      
      private var _itemTempLateID:Array;
      
      private var _offerBack:Bitmap;
      
      private var _offerField:FilterFrameText;
      
      private var _isItem:Boolean = true;
      
      private var _packItems:Array;
      
      private var _selectedPackItem:OfferPackItem;
      
      private var _localAutoOpen:Boolean;
      
      public function OfferPackViewII()
      {
         this._itemTempLateID = [EquipType.OFFER_PACK_I,EquipType.OFFER_PACK_II,EquipType.OFFER_PACK_III,EquipType.OFFER_PACK_IV,EquipType.OFFER_PACK_V];
         this._packItems = [];
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc10_:OfferPackItem = null;
         var _loc6_:Point = null;
         var _loc9_:ItemTemplateInfo = null;
         _loc10_ = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("offer.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGII");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBG");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("offer.turnCellSize");
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,_loc3_.x,_loc3_.y);
         _loc4_.graphics.endFill();
         this._turnBG = ComponentFactory.Instance.creatComponentByStylename("offer.turnBG");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         var _loc5_:int = 0;
         while(_loc5_ < this._movie.movie.currentLabels.length)
         {
            if(this._movie.movie.currentLabels[_loc5_].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[_loc5_].frame;
            }
            _loc5_++;
         }
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(this._openBtn);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(this._goodsNameTxt);
         addChild(this._turnSprite);
         this._turnBG.x = this._turnBG.width / -2;
         this._turnBG.y = this._turnBG.height * -1 + OFFER_TURNSPRITE;
         this._turnSprite.addChild(this._turnBG);
         this._startY = this._turnSprite.y;
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         this._localAutoOpen = _autoCheck.selected = SharedManager.Instance.autoOfferPack;
         addChild(_autoCheck);
         this.creatEffect();
         this.createSelectCell();
         this.offerNumber = PlayerManager.Instance.Self.Offer;
         _loc6_ = ComponentFactory.Instance.creatCustomObject("offer.OfferPackViewII.PackBar.TopLeft");
         var _loc7_:int = this._itemTempLateID.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = ItemManager.Instance.getTemplateById(this._itemTempLateID[_loc8_]);
            _loc10_ = ComponentFactory.Instance.creatCustomObject("ddt.view.caddyII.offerPack.OfferPackItem");
            _loc10_.x = _loc6_.x + (_loc10_.width + OfferPackItem.HSpace) * _loc8_;
            _loc10_.y = _loc6_.y;
            _loc10_.info = _loc9_;
            addChild(_loc10_);
            this._packItems.push(_loc10_);
            _loc10_.addEventListener(MouseEvent.CLICK,this.__packItemClick);
            _loc8_++;
         }
         this.setupSelectedPack(CaddyModel.instance.offerType);
         this._offerBack = ComponentFactory.Instance.creatBitmap("ddt.view.caddy.OfferPack.OfferBack");
         addChild(this._offerBack);
         this._offerField = ComponentFactory.Instance.creatComponentByStylename("ddt.view.caddy.OfferPack.OfferField");
         addChild(this._offerField);
         this._offerField.text = String(PlayerManager.Instance.Self.Offer);
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            this._consortiaManagerBtn = ComponentFactory.Instance.creat("offerPack.consortiaManagerBtn");
            addChild(this._consortiaManagerBtn);
         }
      }
      
      public function setupSelectedPack(param1:int) : void
      {
         var _loc2_:OfferPackItem = this._packItems[param1];
         this.selectedItem = _loc2_;
      }
      
      private function __packItemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:OfferPackItem = param1.currentTarget as OfferPackItem;
         this.selectedItem = _loc2_;
         if(_loc2_ && _loc2_.count <= 0)
         {
            this._localAutoOpen = false;
            this._quickBuy(null);
         }
      }
      
      private function createSelectCell() : void
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bead.selectCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         this._selectCell = new BaseCell(_loc2_);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChildAt(this._selectSprite,getChildIndex(this._movie));
         this._selectSprite.visible = false;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeProperty);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         if(this._consortiaManagerBtn != null)
         {
            this._consortiaManagerBtn.addEventListener(MouseEvent.CLICK,this.__consortiaMgrClick);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OFFERPACK_COMPLETE,this.__packComplete);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this.__changeConsortia);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SharedManager.Instance.autoOfferPack = this._localAutoOpen = _autoCheck.selected;
      }
      
      private function __changeConsortia(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            if(this._consortiaManagerBtn == null)
            {
               this._consortiaManagerBtn = ComponentFactory.Instance.creat("offerPack.consortiaManagerBtn");
               addChild(this._consortiaManagerBtn);
            }
            this._consortiaManagerBtn.visible = true;
         }
         else if(this._consortiaManagerBtn)
         {
            this._consortiaManagerBtn.visible = false;
         }
      }
      
      private function __consortiaMgrClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ConsortionModelControl.Instance.alertManagerFrame();
      }
      
      private function __packComplete(param1:CrazyTankSocketEvent) : void
      {
         this.moviePlay();
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeProperty);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         if(this._consortiaManagerBtn != null)
         {
            this._consortiaManagerBtn.removeEventListener(MouseEvent.CLICK,this.__consortiaMgrClick);
         }
         var _loc1_:OfferPackItem = this._packItems.shift();
         while(_loc1_)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__packItemClick);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._packItems.shift();
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OFFERPACK_COMPLETE,this.__packComplete);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this.__changeConsortia);
      }
      
      private function openImp() : void
      {
         if(this._selectedPackItem)
         {
            if(this._selectedPackItem.count > 0)
            {
               if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
               }
               else
               {
                  this._openBtn.enable = false;
                  this._localAutoOpen = SharedManager.Instance.autoOfferPack;
                  SocketManager.Instance.out.sendOpenDead(CaddyModel.instance.bagInfo.BagType,-3,this._selectedPackItem.info.TemplateID);
               }
            }
            else
            {
               this._quickBuy(null);
            }
         }
      }
      
      private function _openClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function _lookClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function _quickBuy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:OfferQuickBuyFrame = ComponentFactory.Instance.creatCustomObject("offer.OfferQuickBuyFrame");
         var _loc3_:int = this._packItems.indexOf(this._selectedPackItem);
         if(_loc3_ >= 0)
         {
            _loc2_.show(_loc3_);
         }
      }
      
      private function __changeProperty(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Offer"])
         {
            this.offerNumber = PlayerManager.Instance.Self.Offer;
         }
      }
      
      private function _bagUpdate(param1:BagEvent) : void
      {
         var _loc2_:OfferPackItem = null;
         for each(_loc2_ in this._packItems)
         {
            _loc2_.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc2_.info.TemplateID);
         }
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._isItem)
         {
            if(this._movie.movie.currentFrame == this._endFrame)
            {
               this._selectSprite.visible = true;
               this._goodsNameTxt.text = this._selectGoodsInfo.Name;
               this.creatTweenSelectMagnify();
            }
         }
         else if(this._movie.movie.currentFrame == this._movie.movie.totalFrames)
         {
            this.movieComplete();
         }
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.selectNumber = param1.index;
      }
      
      private function creatTweenMagnify() : void
      {
         TweenMax.killTweensOf(this._turnSprite);
         this._turnSprite.scaleY = 1;
         this._turnSprite.scaleX = 1;
         this._turnSprite.y = this._startY;
         TweenMax.from(this._turnSprite,0.5,{
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER
         });
         TweenMax.to(this._turnSprite,0.4,{
            "delay":0.5,
            "y":this._startY + 4,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      private function creatTweenSelectMagnify() : void
      {
         TweenMax.from(this._selectSprite,0.7,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":320,
            "alpha":20,
            "onComplete":this._moveOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function creatEffect() : void
      {
         this._effect = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._turnBG,{
            "color":EffectColorType.GOLD,
            "speed":0.4,
            "blurWidth":10,
            "intensity":40,
            "strength":0.6
         });
         this._effect.play();
      }
      
      private function _moveOk() : void
      {
         setTimeout(this._toMove,400);
      }
      
      private function _toMove() : void
      {
         dispatchEvent(new Event(RightView.START_MOVE_AFTER_TURN));
         if(this._selectCell)
         {
            this._selectCell.info = null;
         }
         if(this._selectSprite)
         {
            this._selectSprite.visible = false;
         }
         if(this._goodsNameTxt)
         {
            this._goodsNameTxt.text = this._selectedPackItem.info.Name;
         }
      }
      
      public function set offerNumber(param1:int) : void
      {
         this._offerNumber = param1;
         if(this._offerField)
         {
            this._offerField.text = String(this._offerNumber);
         }
      }
      
      public function get offerNumber() : int
      {
         return this._offerNumber;
      }
      
      public function set packNumber(param1:int) : void
      {
         this._packNumber = param1;
      }
      
      public function get packNumber() : int
      {
         return this._packNumber;
      }
      
      public function set selectNumber(param1:int) : void
      {
         if(this._selectNumber == param1)
         {
            return;
         }
         this._selectNumber = param1;
         CaddyModel.instance.offerType = this._itemTempLateID[this._selectNumber];
         this._bagUpdate(null);
         this._goodsNameTxt.text = this._selectedPackItem.info.Name;
         this._turnBG.setFrame(this.selectNumber + 1);
         EffectManager.Instance.removeEffect(this._effect);
         this.creatTweenMagnify();
         this.creatEffect();
      }
      
      public function get selectNumber() : int
      {
         return this._selectNumber;
      }
      
      override public function again() : void
      {
         this._turnSprite.visible = true;
         this._movie.visible = false;
         this._movie.movie.gotoAndStop(1);
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
         if(this._localAutoOpen)
         {
            this.openImp();
         }
         else
         {
            this._openBtn.enable = true;
         }
      }
      
      override public function setSelectGoodsInfo(param1:InventoryItemInfo) : void
      {
         this._selectGoodsInfo = param1;
         this._selectCell.info = this._selectGoodsInfo;
         this.moviePlay(true);
      }
      
      private function moviePlay(param1:Boolean = false) : void
      {
         this._isItem = param1;
         SoundManager.instance.play("139");
         this._openBtn.enable = false;
         this._turnSprite.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
         if(this._isItem)
         {
            this._startTurn();
         }
         else
         {
            setTimeout(this.again,1000);
         }
      }
      
      private function movieComplete() : void
      {
         this._turnSprite.visible = true;
         this._movie.visible = false;
         this._movie.movie.gotoAndStop(1);
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
      }
      
      private function _startTurn() : void
      {
         var _loc1_:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         _loc1_.info = this._selectGoodsInfo;
         dispatchEvent(_loc1_);
      }
      
      public function get selectedItem() : OfferPackItem
      {
         return this._selectedPackItem;
      }
      
      public function set selectedItem(param1:OfferPackItem) : void
      {
         if(this._selectedPackItem == param1)
         {
            return;
         }
         var _loc2_:OfferPackItem = this._selectedPackItem;
         this._selectedPackItem = param1;
         if(this._selectedPackItem)
         {
            this._selectedPackItem.selected = true;
            CaddyModel.instance.offerType = this._selectedPackItem.info.TemplateID;
            this._bagUpdate(null);
            this._goodsNameTxt.text = this._selectedPackItem.info.Name;
            this._turnBG.setFrame(this._packItems.indexOf(this._selectedPackItem) + 1);
            EffectManager.Instance.removeEffect(this._effect);
            this.creatTweenMagnify();
            this.creatEffect();
         }
         if(_loc2_)
         {
            _loc2_.selected = false;
         }
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         TweenMax.killTweensOf(this._turnSprite);
         TweenMax.killTweensOf(this._selectSprite);
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._gridBGI)
         {
            ObjectUtils.disposeObject(this._gridBGI);
         }
         this._gridBGI = null;
         if(this._gridBGII)
         {
            ObjectUtils.disposeObject(this._gridBGII);
         }
         this._gridBGII = null;
         if(this._openBtn)
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         if(this._lookTrophy)
         {
            ObjectUtils.disposeObject(this._lookTrophy);
         }
         this._lookTrophy = null;
         if(this._goodsNameTxt)
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
         if(this._movie)
         {
            this._movie.movie.stop();
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
         }
         if(this._turnSprite)
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(this._turnBG)
         {
            ObjectUtils.disposeObject(this._turnBG);
         }
         this._turnBG = null;
         if(this._selectSprite)
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(this._selectCell)
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(this._effect)
         {
            ObjectUtils.disposeObject(this._effect);
         }
         this._effect = null;
         ObjectUtils.disposeObject(_autoCheck);
         _autoCheck = null;
         if(this._offerBack)
         {
            ObjectUtils.disposeObject(this._offerBack);
         }
         this._offerBack = null;
         if(this._offerField)
         {
            ObjectUtils.disposeObject(this._offerField);
         }
         this._offerField = null;
         if(this._consortiaManagerBtn)
         {
            ObjectUtils.disposeObject(this._consortiaManagerBtn);
         }
         this._consortiaManagerBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
