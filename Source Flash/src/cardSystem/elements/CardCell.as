package cardSystem.elements
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import com.greensock.TweenMax;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardCell extends BaseCell
   {
       
      
      private var _open:Boolean;
      
      private var _cardInfo:CardInfo;
      
      private var _place:int;
      
      private var _cardID:int;
      
      protected var _starContainer:Sprite;
      
      protected var _levelBG:Bitmap;
      
      protected var _level:FilterFrameText;
      
      private var _starVisible:Boolean = true;
      
      private var _cardName:FilterFrameText;
      
      private var _shine:IEffect;
      
      protected var _isShine:Boolean;
      
      private var _canShine:Boolean;
      
      private var _tweenMax:TweenMax;
      
      public function CardCell(param1:DisplayObject, param2:int = -1, param3:CardInfo = null, param4:Boolean = false, param5:Boolean = true)
      {
         this._place = param2;
         super(param1,this._cardInfo == null ? null : ItemManager.Instance.getTemplateById(this._cardInfo.TemplateID),param4,param5);
         this.open = true;
         this.cardInfo = param3;
         this.setStar();
      }
      
      public function set canShine(param1:Boolean) : void
      {
         this._canShine = param1;
      }
      
      public function get canShine() : Boolean
      {
         return this._canShine;
      }
      
      public function showCardName(param1:String) : void
      {
         if(this._cardName == null)
         {
            this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardBagCell.name");
            addChild(this._cardName);
         }
         this._cardName.text = param1;
         this._cardName.y = _bg.height / 2 - this._cardName.textHeight / 2;
      }
      
      public function set cardID(param1:int) : void
      {
         if(this._cardID == param1)
         {
            return;
         }
         this._cardID = param1;
      }
      
      public function get cardID() : int
      {
         return this._cardID;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createStar();
      }
      
      public function shine() : void
      {
         if(this._tweenMax != null)
         {
            TweenMax.killTweensOf(this);
            this._tweenMax.kill();
            this._tweenMax = null;
            filters = null;
            if(this.open)
            {
               this.open = true;
            }
            else
            {
               this.open = false;
            }
         }
         this._tweenMax = TweenMax.to(this,0.5,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":16777011,
               "alpha":1,
               "blurX":8,
               "blurY":8,
               "strength":3
            }
         });
      }
      
      public function stopShine() : void
      {
         TweenMax.killTweensOf(this);
         filters = null;
         if(this.open)
         {
            this.open = true;
         }
         else
         {
            this.open = false;
         }
      }
      
      protected function createStar() : void
      {
         this._starContainer = new Sprite();
         addChild(this._starContainer);
         if(this._place != 0)
         {
            this._levelBG = ComponentFactory.Instance.creatBitmap("asset.cardBag.cell.smalllevelbg");
            this._level = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.small");
            PositionUtils.setPos(this._level,"cardSystem.level.small.pos");
            this._starContainer.addChild(this._levelBG);
            this._starContainer.addChild(this._level);
            this._starContainer.x = _bg.width - this._levelBG.width - 3;
            this._starContainer.y = _bg.height - this._levelBG.height - 3;
         }
         else
         {
            this._levelBG = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.cell.levelBg");
            this._level = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
            PositionUtils.setPos(this._level,"cardSystem.level.big.pos");
            this._starContainer.addChild(this._levelBG);
            this._starContainer.addChild(this._level);
            this._starContainer.x = _bg.width - this._levelBG.width + 13;
            this._starContainer.y = _bg.height - this._levelBG.height - 4;
         }
      }
      
      public function setStarPos(param1:int, param2:int) : void
      {
         this._starContainer.x = param1;
         this._starContainer.y = param2;
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         if(this._cardInfo == param1 && !this._cardInfo)
         {
            return;
         }
         this._cardInfo = param1;
         if(this._cardInfo == null)
         {
            super.info = null;
            if(this._cardName)
            {
               this._cardName.visible = true;
            }
         }
         else
         {
            super.info = this._cardInfo.templateInfo;
            _pic.parent.setChildIndex(_pic,1);
            if(this._cardName)
            {
               this._cardName.visible = false;
            }
         }
         tipStyle = "core.CardsTip";
         tipData = param1;
         this.setStar();
      }
      
      public function get cardInfo() : CardInfo
      {
         return this._cardInfo;
      }
      
      protected function setStar() : void
      {
         if(this.cardInfo == null)
         {
            this._starContainer.visible = false;
         }
         else
         {
            if(this._starVisible)
            {
               this._starContainer.visible = true;
            }
            this._level.text = this._cardInfo.Level < 10 ? "0" + this._cardInfo.Level : this._cardInfo.Level.toString();
         }
      }
      
      public function set starVisible(param1:Boolean) : void
      {
         this._starVisible = param1;
         this._starContainer.visible = param1;
      }
      
      public function set open(param1:Boolean) : void
      {
         this._open = param1;
         if(param1)
         {
            filters = null;
            mouseEnabled = true;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
            mouseEnabled = false;
         }
      }
      
      public function get open() : Boolean
      {
         return this._open;
      }
      
      public function set place(param1:int) : void
      {
         if(this._place == param1)
         {
            return;
         }
         this._place = param1;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      override public function dragStart() : void
      {
         if(this._cardInfo && !locked && stage && allowDrag)
         {
            if(DragManager.startDrag(this,this._cardInfo,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,true,false,false,true))
            {
               locked = true;
               CardControl.Instance.signLockedCard = this.cardInfo.TemplateID;
            }
         }
         if(_info && _pic.numChildren > 0)
         {
            dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.cardInfo,true));
         }
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:CardInfo = null;
         if(param1.data is CardInfo)
         {
            _loc2_ = param1.data as CardInfo;
            if(locked)
            {
               if(_loc2_ == this.cardInfo)
               {
                  locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               if(this._place != -1)
               {
                  if(!this.open)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.notOpen"));
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._place == 0 && _loc2_.templateInfo.Property8 == "0")
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.cannotMoveCardMain"));
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._place <= 4 && this._place > 0 && _loc2_.templateInfo.Property8 == "1")
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.CardCell.cannotMoveCardOther"));
                     param1.action = DragEffect.NONE;
                  }
                  else if(this._place > 4 && _loc2_.Place < 5)
                  {
                     SocketManager.Instance.out.sendMoveCards(_loc2_.Place,_loc2_.Place);
                     param1.action = DragEffect.NONE;
                  }
                  else
                  {
                     SocketManager.Instance.out.sendMoveCards(_loc2_.Place,this._place);
                     param1.action = DragEffect.NONE;
                  }
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         param1.action = DragEffect.NONE;
         locked = false;
      }
      
      override public function dispose() : void
      {
         TweenMax.killTweensOf(this);
         this._cardInfo = null;
         ObjectUtils.disposeAllChildren(this);
         this._starContainer = null;
         this._levelBG = null;
         this._cardName = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.height = _contentHeight;
            param1.width = _contentWidth;
            param1.x = (_bg.width - _contentWidth) / 2;
            param1.y = (_bg.height - _contentHeight) / 2;
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         if(this.open && !locked)
         {
            this.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         if(this.open && !locked)
         {
            this.filters = null;
         }
      }
      
      override public function createDragImg() : DisplayObject
      {
         var _loc1_:Bitmap = null;
         if(_pic && _pic.width > 0 && _pic.height > 0)
         {
            _loc1_ = new Bitmap(new BitmapData(_pic.width / _pic.scaleX,_pic.height / _pic.scaleY,true,0),"auto",true);
            _loc1_.bitmapData.draw(_pic);
            _loc1_.width = 103;
            _loc1_.height = 144;
            return _loc1_;
         }
         return null;
      }
   }
}
