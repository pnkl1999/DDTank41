package ddt.view.caddyII.card
{
   import bagAndInfo.cell.BaseCell;
   import cardSystem.data.CardInfo;
   import com.greensock.TweenLite;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.RightView;
   import ddt.view.caddyII.bead.BeadItem;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CardViewII extends RightView
   {
      
      public static var _instance:CardViewII;
      
      public static const CARD_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0.1;
      
      public static const SELECT_SCALE_NUMBER:Number = 0.05;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _bg1:Scale9CornerImage;
      
      private var _gridBGI:ScaleBitmapImage;
      
      private var _gridBGII:ScaleBitmapImage;
      
      private var _openBtn:BaseButton;
      
      private var _turnBG:Bitmap;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _turnSprite:Sprite;
      
      private var _movie:MovieImage;
      
      private var _effect:IEffect;
      
      private var _selectCell:BaseCell;
      
      private var _selectSprite:Sprite;
      
      private var _cardItem:BeadItem;
      
      private var _cardNumberTxt:FilterFrameText;
      
      private var _endFrame:int;
      
      private var _startY:int;
      
      private var _cardID:int;
      
      private var _cardPlace:int;
      
      private var _haveCardNumber:int;
      
      private var _cardInfo:ItemTemplateInfo;
      
      private var _selectGoodsInfo:ItemTemplateInfo;
      
      private var _localAutoOpen:Boolean;
      
      private var winTime:int;
      
      public function CardViewII()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public static function get instance() : CardViewII
      {
         if(_instance == null)
         {
            _instance = new CardViewII();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGII");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         var _loc2_:Image = ComponentFactory.Instance.creatComponentByStylename("bead.fontII");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.card.getFontBG");
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.card.getFont");
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBG");
         this._cardItem = ComponentFactory.Instance.creatCustomObject("card.cardCell");
         this._cardNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.card.cardNumber");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._turnBG = ComponentFactory.Instance.creatBitmap("asset.card.turnBG");
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         var _loc6_:int = 0;
         while(_loc6_ < this._movie.movie.currentLabels.length)
         {
            if(this._movie.movie.currentLabels[_loc6_].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[_loc6_].frame;
            }
            _loc6_++;
         }
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(this._openBtn);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc3_);
         addChild(_loc4_);
         addChild(this._cardNumberTxt);
         this._cardNumberTxt.text = "0";
         addChild(_loc5_);
         addChild(this._goodsNameTxt);
         addChild(this._cardItem);
         addChild(this._turnSprite);
         this._turnBG.x = this._turnBG.width / -2;
         this._turnBG.y = this._turnBG.height * -1 + CARD_TURNSPRITE;
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
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this._update);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.ADD,this._updateCaddyBag);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this._updateCaddyBag);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this._update);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function _update(param1:BagEvent) : void
      {
         this._cardItem.count = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(this._cardID);
      }
      
      private function _updateCaddyBag(param1:DictionaryEvent) : void
      {
         var _loc2_:int = this.haveCardNumber(int(this._cardInfo.Property5));
         if(_loc2_ > this._haveCardNumber)
         {
            this._cardNumberTxt.text = (int(this._cardNumberTxt.text) + _loc2_ - this._haveCardNumber).toString();
            this._haveCardNumber = _loc2_;
            this.moviePlay();
         }
      }
      
      private function _openClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.openImp();
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SharedManager.Instance.autoOfferPack = this._localAutoOpen = _autoCheck.selected;
      }
      
      public function setCard(param1:int, param2:int) : void
      {
         this._cardID = param1;
         this._cardPlace = param2;
         this._cardInfo = ItemManager.Instance.getTemplateById(this._cardID);
         this._cardItem.info = this._cardInfo;
         this._cardItem.count = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(this._cardID);
         this._selectGoodsInfo = ItemManager.Instance.getTemplateById(int(this._cardInfo.Property5));
         this._haveCardNumber = this.haveCardNumber(int(this._cardInfo.Property5));
         this.creatTweenMagnify();
      }
      
      public function setCardBox(param1:int, param2:int) : void
      {
         this._cardID = param1;
         this._cardPlace = param2;
         this._cardInfo = ItemManager.Instance.getTemplateById(this._cardID);
         this._cardItem.info = this._cardInfo;
         this._update(null);
         this._selectGoodsInfo = ItemManager.Instance.getTemplateById(int(this._cardInfo.Property5));
         this._haveCardNumber = this.haveCardNumber(int(this._cardInfo.Property5));
         this.creatTweenMagnify();
      }
      
      private function haveCardNumber(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:CardInfo = null;
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.TemplateID == param1)
            {
               _loc3_ += _loc4_.Count;
            }
         }
         return _loc3_;
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
      
      private function creatTweenMagnify() : void
      {
         TweenLite.killTweensOf(this._turnSprite);
         this._turnSprite.scaleY = 1;
         this._turnSprite.scaleX = 1;
         this._turnSprite.y = this._startY;
         TweenLite.from(this._turnSprite,0.5,{
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER
         });
         TweenLite.to(this._turnSprite,0.4,{
            "delay":0.5,
            "y":this._startY + 4,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      private function creatTweenSelectMagnify() : void
      {
         this._selectSprite.x = 164;
         this._selectSprite.y = 125;
         this._selectSprite.scaleY = 1;
         this._selectSprite.scaleX = 1;
         TweenLite.from(this._selectSprite,0.7,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":320,
            "alpha":20,
            "onComplete":this._moveOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function _moveOk() : void
      {
         TweenLite.to(this._selectSprite,0.3,{
            "scaleX":1.5,
            "scaleY":1.5,
            "repeat":1,
            "yoyo":true
         });
         TweenLite.to(this._selectSprite,0.3,{
            "delay":0.3,
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER,
            "x":550,
            "y":360
         });
         this.winTime = setTimeout(this._toMove,800);
      }
      
      private function _toMove() : void
      {
         TweenLite.killTweensOf(this._selectSprite);
         if(this._selectCell)
         {
            this._selectCell.info = null;
         }
         if(this._selectSprite)
         {
            this._selectSprite.visible = false;
            this._selectSprite.x = 164;
            this._selectSprite.y = 125;
            this._selectSprite.scaleY = 1;
            this._selectSprite.scaleX = 1;
         }
         if(this._goodsNameTxt)
         {
            this._goodsNameTxt.text = "";
         }
         this.again();
      }
      
      private function openImp() : void
      {
         if(this._cardItem)
         {
            if(this.haveCardNumber(int(this._cardInfo.Property5)) >= 997)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.moreCard"));
               this._openBtn.enable = true;
               return;
            }
            if(this._cardItem.count > 0)
            {
               this._openBtn.enable = false;
               this._localAutoOpen = SharedManager.Instance.autoOfferPack;
               SocketManager.Instance.out.sendOpenCardBox(this.getCardPlace(this._cardPlace),1);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noCard"));
            }
         }
      }
      
      private function getCardPlace(param1:int) : int
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc2_:Array = PlayerManager.Instance.Self.Bag.findCellsByTempleteID(this._cardID);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Place == param1)
            {
               return param1;
            }
         }
         return _loc2_[0].Place;
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
      
      private function moviePlay() : void
      {
         SoundManager.instance.play("139");
         this._openBtn.enable = false;
         this._turnSprite.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._movie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectGoodsInfo.Name;
            if(this._selectCell)
            {
               this._selectCell.info = this._selectGoodsInfo;
            }
            this.creatTweenSelectMagnify();
         }
      }
      
      public function get closeEnble() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         clearTimeout(this.winTime);
         TweenLite.killTweensOf(this._turnSprite);
         TweenLite.killTweensOf(this._selectSprite);
         this._cardInfo = null;
         this._selectGoodsInfo = null;
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
         if(this._turnBG)
         {
            ObjectUtils.disposeObject(this._turnBG);
         }
         this._turnBG = null;
         if(this._goodsNameTxt)
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
         if(this._turnSprite)
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(this._movie)
         {
            this._movie.movie.stop();
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
         }
         if(this._effect)
         {
            ObjectUtils.disposeObject(this._effect);
         }
         this._effect = null;
         if(this._selectCell)
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(this._selectSprite)
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(this._cardItem)
         {
            ObjectUtils.disposeObject(this._cardItem);
         }
         this._cardItem = null;
         if(this._cardNumberTxt)
         {
            ObjectUtils.disposeObject(this._cardNumberTxt);
         }
         this._cardNumberTxt = null;
         if(_autoCheck)
         {
            ObjectUtils.disposeObject(_autoCheck);
         }
         _autoCheck = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
