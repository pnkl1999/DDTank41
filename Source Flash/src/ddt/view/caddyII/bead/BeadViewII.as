package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
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
   
   public class BeadViewII extends RightView
   {
      
      public static const BeadFromSmelt:int = -1;
      
      public static const Bead:int = 1;
      
      public static const OFFER_TURNSPRITE:int = 5;
      
      public static const SCALE_NUMBER:Number = 0;
      
      public static const SELECT_SCALE_NUMBER:Number = 0;
       
      
      private var _bg:Scale9CornerImage;
      
      private var _gridBGI:ScaleBitmapImage;
      
      private var _gridBGII:ScaleBitmapImage;
      
      private var _openBtn:BaseButton;
      
      private var _itemContainer:HBox;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _turnBG:ScaleFrameImage;
      
      private var _movie:MovieImage;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectCell:BaseCell;
      
      private var _selectSprite:Sprite;
      
      private var _lookTrophy:LookTrophy;
      
      private var _selectGoodsInfo:InventoryItemInfo;
      
      private var _selectItem:int = -1;
      
      private var _turnSprite:Sprite;
      
      private var _effect:IEffect;
      
      private var _startY:Number;
      
      private var _endFrame:int;
      
      private var _clickNumber:int;
      
      private var _nodeImage:Bitmap;
      
      private var _turnItemShape:Shape;
      
      private var _cellId:Array;
      
      private var _smeltBeadCell:BeadItem;
      
      private var _beadQuickBuyBtn:BaseButton;
      
      private var _turnCell:BeadCell;
      
      private var _hasCell:Boolean = false;
      
      private var _localAutoOpen:Boolean;
      
      public function BeadViewII()
      {
         this._cellId = [EquipType.BEAD_ATTACK,EquipType.BEAD_DEFENSE,EquipType.BEAD_ATTRIBUTE];
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function setType(param1:int) : void
      {
         _type = param1;
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX)
         {
            this.clearCell();
            this.createBead();
            this.updateBead();
            this._nodeImage.visible = false;
            this._beadQuickBuyBtn.visible = true;
         }
         else if(_type == EquipType.MY_CARDBOX)
         {
            this.clearCell();
            this.createBead();
            this.updateBead();
            this._nodeImage.visible = false;
            this._beadQuickBuyBtn.visible = false;
         }
         else if(_type == EquipType.CARD_CARTON)
         {
            this.clearCell();
            this.createBead();
            this.updateBead();
            this._nodeImage.visible = false;
            this._beadQuickBuyBtn.visible = true;
         }
         else
         {
            this.clearBead();
            this.createCell();
            this._nodeImage.visible = true;
            this._beadQuickBuyBtn.visible = false;
         }
      }
      
      private function createCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BeadItem = null;
         _loc1_ = 0;
         _loc2_ = null;
         if(this._hasCell)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this._cellId.length)
         {
            _loc2_ = new BeadItem();
            _loc2_.info = ItemManager.Instance.getTemplateById(this._cellId[_loc1_]);
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.CLICK,this._itemClick);
            this._itemContainer.addChild(_loc2_);
            this._itemGroup.addSelectItem(_loc2_);
            _loc2_.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cellId[_loc1_]);
            _loc1_++;
         }
         this._hasCell = true;
      }
      
      private function updateCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemContainer.numChildren)
         {
            (this._itemContainer.getChildAt(_loc1_) as BeadItem).count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._cellId[_loc1_]);
            _loc1_++;
         }
      }
      
      private function clearCell() : void
      {
         var _loc1_:BeadItem = null;
         while(this._itemContainer.numChildren > 0)
         {
            _loc1_ = this._itemContainer.getChildAt(0) as BeadItem;
            _loc1_.removeEventListener(MouseEvent.CLICK,this._itemClick);
            ObjectUtils.disposeObject(_loc1_);
            this._itemGroup.removeSelectItem(_loc1_);
            _loc1_ = null;
         }
         this._hasCell = false;
      }
      
      private function createBead() : void
      {
         this._smeltBeadCell = ComponentFactory.Instance.creatCustomObject("bead.SmeltBeadCell");
         this._smeltBeadCell.mouseEnabled = false;
         this._smeltBeadCell.info = ItemManager.Instance.getTemplateById(_type);
         addChild(this._smeltBeadCell);
         if(_type == EquipType.MY_CARDBOX)
         {
            this._smeltBeadCell.x = 124;
            this._smeltBeadCell.y = 264;
         }
         this._turnCell.info = ItemManager.Instance.getTemplateById(_type);
         this.creatTweenMagnify();
      }
      
      private function updateBead() : void
      {
         this._smeltBeadCell.count = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_type);
      }
      
      private function clearBead() : void
      {
         if(this._smeltBeadCell)
         {
            ObjectUtils.disposeObject(this._smeltBeadCell);
            this._smeltBeadCell = null;
         }
      }
      
      private function updateItemShape() : void
      {
         this._turnCell.x = this._turnCell.width / -2;
         this._turnCell.y = this._turnCell.height * -1 + OFFER_TURNSPRITE;
      }
      
      private function initView() : void
      {
         this._itemGroup = new SelectedButtonGroup();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("bead.rightGridBGI");
         this._gridBGII = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGII");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("bead.selectBox");
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         var _loc2_:Image = ComponentFactory.Instance.creatComponentByStylename("bead.fontII");
         this._nodeImage = ComponentFactory.Instance.creatBitmap("asset.bead.selectNode");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.goodsNameBG");
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("bead.goodsNameTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._turnBG = ComponentFactory.Instance.creatComponentByStylename("bead.turnBG");
         this._turnCell = new BeadCell();
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         var _loc4_:int = 0;
         while(_loc4_ < this._movie.movie.currentLabels.length)
         {
            if(this._movie.movie.currentLabels[_loc4_].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[_loc4_].frame;
            }
            _loc4_++;
         }
         this._beadQuickBuyBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.bead.QuickBuyButton");
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(this._gridBGII);
         addChild(this._openBtn);
         addChild(this._itemContainer);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(this._nodeImage);
         addChild(_loc3_);
         addChild(this._goodsNameTxt);
         this._turnSprite.addChild(this._turnCell);
         addChild(this._turnSprite);
         addChild(this._beadQuickBuyBtn);
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         this._localAutoOpen = _autoCheck.selected = SharedManager.Instance.autoBead;
         addChild(_autoCheck);
         this._turnBG.setFrame(1);
         this._startY = this._turnSprite.y;
         this.createSelectCell();
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         this.updateItemShape();
         this.creatEffect();
         this.createCell();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._update);
         CaddyModel.instance.addEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadTypeChange);
         this._openBtn.addEventListener(MouseEvent.CLICK,this._openClick);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._beadQuickBuyBtn.addEventListener(MouseEvent.CLICK,this.__beadQuickBuy);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SharedManager.Instance.autoBead = this._localAutoOpen = _autoCheck.selected;
      }
      
      private function __beadQuickBuy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showQuickBuyBead();
      }
      
      private function showQuickBuyBead() : void
      {
         var _loc1_:QuickBuyBead = null;
         var _loc2_:CardBoxQuickBuy = null;
         if(_type != EquipType.MYSTICAL_CARDBOX && _type != EquipType.MY_CARDBOX && _type != EquipType.CARD_CARTON)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("bead.QuickBuyBead");
            if(EquipType.isAttackBeadFromSmeltByID(_type))
            {
               _loc1_.show(0);
            }
            else if(EquipType.isDefenceBeadFromSmeltByID(_type))
            {
               _loc1_.show(1);
            }
            else if(EquipType.isAttributeBeadFromSmeltByID(_type))
            {
               _loc1_.show(2);
            }
            else
            {
               _loc1_.show(this._clickNumber);
            }
         }
         else
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bead.CardBoxQuickBuy");
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __buyGoods(param1:Event) : void
      {
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._update);
         CaddyModel.instance.removeEventListener(CaddyModel.BEADTYPE_CHANGE,this._beadTypeChange);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this._openClick);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._beadQuickBuyBtn.removeEventListener(MouseEvent.CLICK,this.__beadQuickBuy);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
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
         addChild(this._selectSprite);
         this._selectSprite.visible = false;
      }
      
      private function _update(param1:BagEvent) : void
      {
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX || _type == EquipType.CARD_CARTON)
         {
            this.updateBead();
         }
         else
         {
            this.updateCell();
         }
      }
      
      private function _beadTypeChange(param1:Event) : void
      {
         if(!EquipType.isBeadFromSmeltByID(CaddyModel.instance.beadType) && CaddyModel.instance.beadType != EquipType.MYSTICAL_CARDBOX && CaddyModel.instance.beadType != EquipType.MY_CARDBOX && CaddyModel.instance.beadType != EquipType.CARD_CARTON)
         {
            this._itemGroup.selectIndex = this.selectItem = CaddyModel.instance.beadType;
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]).Name;
         }
         else
         {
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(CaddyModel.instance.beadType).Name;
         }
      }
      
      private function openImp() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX || _type == EquipType.CARD_CARTON)
         {
            if(this._smeltBeadCell.count > 0)
            {
               if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
               }
               else
               {
                  this._openBtn.enable = false;
                  this._localAutoOpen = SharedManager.Instance.autoBead;
                  SocketManager.Instance.out.sendOpenDead(CaddyModel.instance.bagInfo.BagType,-2,_type);
               }
            }
            else
            {
               if(_type != EquipType.MYSTICAL_CARDBOX && _type != EquipType.MY_CARDBOX && _type != EquipType.CARD_CARTON)
               {
                  _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bead.buyNode"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  _loc1_.moveEnable = false;
                  _loc1_.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               if(_type == EquipType.MY_CARDBOX)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNoCardBox1"));
               }
               else
               {
                  if(_type != EquipType.CARD_CARTON)
                  {
                     _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bead.buyNoCardBox"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                     _loc1_.moveEnable = false;
                     _loc1_.addEventListener(FrameEvent.RESPONSE,this._response);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.buyNoCardBox2"));
               }
            }
         }
         else
         {
            if((this._itemContainer.getChildAt(this._selectItem) as BeadItem).count <= 0)
            {
               this._clickNumber = this._selectItem;
               _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bead.buyNode"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc1_.moveEnable = false;
               _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseI);
               return;
            }
            if(CaddyModel.instance.bagInfo.itemNumber >= CaddyBagView.SUM_NUMBER)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            }
            else
            {
               this._openBtn.enable = false;
               this._localAutoOpen = SharedManager.Instance.autoBead;
               SocketManager.Instance.out.sendOpenDead(CaddyModel.instance.bagInfo.BagType,-2,this._cellId[this._selectItem]);
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
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._movie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectGoodsInfo.Name;
            this.creatTweenSelectMagnify();
         }
      }
      
      private function _itemClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         this._clickNumber = this._itemContainer.getChildIndex(param1.currentTarget as BeadItem);
         this._itemGroup.selectIndex = this.selectItem = this._clickNumber;
         if((this._itemContainer.getChildAt(this._clickNumber) as BeadItem).count <= 0)
         {
            this._localAutoOpen = false;
            param1.stopImmediatePropagation();
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bead.buyNode"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         ObjectUtils.disposeObject(param1.currentTarget);
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.showQuickBuyBead();
         }
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyBead = null;
         ObjectUtils.disposeObject(param1.currentTarget);
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bead.QuickBuyBead");
            _loc2_.show(this._clickNumber);
         }
      }
      
      private function creatEffect() : void
      {
         this._effect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._turnCell,{
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
         if(EquipType.isBeadFromSmeltByID(_type) || _type == EquipType.MYSTICAL_CARDBOX || _type == EquipType.MY_CARDBOX || _type == EquipType.CARD_CARTON)
         {
            if(this._goodsNameTxt)
            {
               this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(_type).Name;
            }
         }
         else if(this._goodsNameTxt)
         {
            this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]).Name;
         }
      }
      
      public function set selectItem(param1:int) : void
      {
         if(this._selectItem == param1)
         {
            return;
         }
         this._selectItem = param1;
         this._turnCell.info = ItemManager.Instance.getTemplateById(this._cellId[this.selectItem]);
         EffectManager.Instance.removeEffect(this._effect);
         this.creatTweenMagnify();
         this.creatEffect();
         CaddyModel.instance.beadType = this._cellId[this._selectItem];
      }
      
      public function get selectItem() : int
      {
         return this._selectItem;
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
      }
      
      override public function setSelectGoodsInfo(param1:InventoryItemInfo) : void
      {
         SoundManager.instance.play("139");
         this._selectGoodsInfo = param1;
         this._turnSprite.visible = false;
         this._movie.visible = true;
         this._movie.movie.play();
         this._selectCell.info = this._selectGoodsInfo;
         this._startTurn();
      }
      
      private function _startTurn() : void
      {
         var _loc1_:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         _loc1_.info = this._selectGoodsInfo;
         dispatchEvent(_loc1_);
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         var _loc1_:BeadItem = null;
         this.removeEvents();
         TweenMax.killTweensOf(this._turnSprite);
         TweenMax.killTweensOf(this._selectSprite);
         while(this._itemContainer.numChildren > 0)
         {
            _loc1_ = this._itemContainer.getChildAt(0) as BeadItem;
            _loc1_.removeEventListener(MouseEvent.CLICK,this._itemClick);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
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
         if(this._nodeImage)
         {
            ObjectUtils.disposeObject(this._nodeImage);
         }
         this._nodeImage = null;
         if(this._openBtn)
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         if(this._itemContainer)
         {
            ObjectUtils.disposeObject(this._itemContainer);
         }
         this._itemContainer = null;
         if(this._turnBG)
         {
            ObjectUtils.disposeObject(this._turnBG);
         }
         this._turnBG = null;
         if(this._movie)
         {
            ObjectUtils.disposeObject(this._movie);
         }
         this._movie = null;
         if(this._goodsNameTxt)
         {
            ObjectUtils.disposeObject(this._goodsNameTxt);
         }
         this._goodsNameTxt = null;
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
         if(this._lookTrophy)
         {
            ObjectUtils.disposeObject(this._lookTrophy);
         }
         this._lookTrophy = null;
         if(this._itemGroup)
         {
            ObjectUtils.disposeObject(this._itemGroup);
         }
         this._itemGroup = null;
         ObjectUtils.disposeObject(_autoCheck);
         _autoCheck = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
