package cardSystem.view.cardEquip
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.elements.CardCell;
   import cardSystem.view.CardSelect;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryEvent;
   
   public class CardEquipView extends Sprite implements Disposeable
   {
       
      
      private var _background:Bitmap;
      
      private var _title:Bitmap;
      
      public var _equipCells:Vector.<CardCell>;
      
      private var _playerInfo:PlayerInfo;
      
      private var _viceCardBit:Vector.<Bitmap>;
      
      private var _mainCardBit:Bitmap;
      
      private var _clickEnable:Boolean = true;
      
      private var _cell3MouseSprite:Sprite;
      
      private var _cell4MouseSprite:Sprite;
      
      private var _open3Btn:BaseButton;
      
      private var _open4Btn:BaseButton;
      
      private var _dragArea:CardEquipDragArea;
      
      private var _collectBtn:BaseButton;
      
      private var _cardBtn:BaseButton;
      
      private var _cardList:CardSelect;
      
      private var _show3:Boolean;
      
      private var _openFrame:BaseAlerFrame;
      
      private var _configFrame:BaseAlerFrame;
      
      public function CardEquipView()
      {
         super();
         this.initView();
      }
      
      public function set clickEnable(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._clickEnable == param1)
         {
            return;
         }
         this._clickEnable = param1;
         if(this._clickEnable)
         {
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               if(this._equipCells[_loc2_])
               {
                  this._equipCells[_loc2_].addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[_loc2_].addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               }
               _loc2_++;
            }
            if(this._equipCells[3].open)
            {
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(this._equipCells[4].open)
            {
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 5)
            {
               if(this._equipCells[_loc3_])
               {
                  this._equipCells[_loc3_].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
                  this._equipCells[_loc3_].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               }
               _loc3_++;
            }
            if(!this._equipCells[3].open)
            {
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell3MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
            if(!this._equipCells[4].open)
            {
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
               this._cell4MouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            }
         }
         this._collectBtn.visible = false;
         this._cardBtn.visible = false;
      }
      
      private function initView() : void
      {
         var _loc3_:CardCell = null;
         this._equipCells = new Vector.<CardCell>(5);
         this._background = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.BG");
         this._dragArea = new CardEquipDragArea(this);
         this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.collectBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("CardBagView.CardBtn");
         addChild(this._background);
         addChild(this._dragArea);
         addChild(this._collectBtn);
         addChild(this._cardBtn);
         this._cardList = new CardSelect();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ == 0)
            {
               _loc3_ = new CardCell(ComponentFactory.Instance.creatComponentByStylename("asset.cardEquipView.mainBG"),_loc1_);
               _loc3_.setContentSize(118,167);
               _loc3_.setStarPos(59,154);
            }
            else
            {
               _loc3_ = new CardCell(ComponentFactory.Instance.creatComponentByStylename("CardEquipView.viceCardBG" + _loc1_),_loc1_);
               _loc3_.setContentSize(74,107);
            }
            if(this._clickEnable)
            {
               _loc3_.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               _loc3_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            }
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            DoubleClickManager.Instance.enableDoubleClick(_loc3_);
            this._equipCells[_loc1_] = _loc3_;
            addChild(_loc3_);
            _loc1_++;
         }
         this._viceCardBit = new Vector.<Bitmap>(4);
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this._viceCardBit[_loc2_] = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.viceCardBG");
            addChild(this._viceCardBit[_loc2_]);
            _loc2_++;
         }
         this._mainCardBit = ComponentFactory.Instance.creatBitmap("asset.cardEquipView.mainCardBorder");
         addChild(this._mainCardBit);
         this.setCellPos();
      }
      
      private function createSprite(param1:CardCell) : Sprite
      {
         var _loc2_:Sprite = null;
         _loc2_ = null;
         _loc2_ = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
         return _loc2_;
      }
      
      private function removeSprite(param1:Sprite, param2:BaseButton) : void
      {
         if(param1)
         {
            param1.removeEventListener(MouseEvent.ROLL_OVER,this.__showOpenBtn);
            param1.removeEventListener(MouseEvent.ROLL_OUT,this.__hideOpenBtn);
            param2.removeEventListener(MouseEvent.CLICK,this._openHandler);
            ObjectUtils.disposeObject(param1);
            ObjectUtils.disposeObject(param2);
         }
         param1 = null;
         param2 = null;
      }
      
      private function __showOpenBtn(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         if(_loc2_ == this._cell3MouseSprite)
         {
            this._show3 = true;
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
         else
         {
            this._show3 = false;
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":1,
               "ease":Quad.easeOut
            });
         }
      }
      
      private function __hideOpenBtn(param1:MouseEvent) : void
      {
         if(this._show3)
         {
            TweenLite.to(this._open3Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
         else
         {
            TweenLite.to(this._open4Btn,0.25,{
               "autoAlpha":0,
               "ease":Quad.easeOut
            });
         }
      }
      
      public function shineMain() : void
      {
         this._equipCells[0].shine();
      }
      
      public function shineVice() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(this._equipCells[_loc1_].open)
            {
               this._equipCells[_loc1_].shine();
            }
            _loc1_++;
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            this._equipCells[_loc1_].stopShine();
            _loc1_++;
         }
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         if(this._playerInfo == param1)
         {
            return;
         }
         this._playerInfo = param1;
         this.initEvent();
         this.setCellsData();
         this.checkCellIsOpen();
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      private function checkCellIsOpen() : void
      {
         if(this._equipCells)
         {
            this._equipCells[3].open = this._playerInfo.cardEquipDic[3] == null ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            if(this._equipCells[3].open == false)
            {
               if(this._cell3MouseSprite == null)
               {
                  this._cell3MouseSprite = this.createSprite(this._equipCells[3]);
                  this._open3Btn = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.openBtn");
                  this._open3Btn.visible = false;
                  this._open3Btn.addEventListener(MouseEvent.CLICK,this._openHandler);
                  addChild(this._cell3MouseSprite);
                  this._cell3MouseSprite.addChild(this._open3Btn);
               }
            }
            else if(this._cell3MouseSprite)
            {
               this.removeSprite(this._cell3MouseSprite,this._open3Btn);
            }
            this._equipCells[4].open = this._playerInfo.cardEquipDic[4] == null ? Boolean(Boolean(false)) : Boolean(Boolean(true));
            if(this._equipCells[4].open == false)
            {
               if(this._cell4MouseSprite == null)
               {
                  this._cell4MouseSprite = this.createSprite(this._equipCells[4]);
                  this._open4Btn = ComponentFactory.Instance.creatComponentByStylename("CardEquipView.openBtn");
                  this._open4Btn.visible = false;
                  this._open4Btn.addEventListener(MouseEvent.CLICK,this._openHandler);
                  addChild(this._cell4MouseSprite);
                  this._cell4MouseSprite.addChild(this._open4Btn);
               }
            }
            else if(this._cell4MouseSprite)
            {
               this.removeSprite(this._cell4MouseSprite,this._open4Btn);
            }
         }
      }
      
      private function setCellsData() : void
      {
         var _loc1_:CardInfo = null;
         for each(_loc1_ in this.playerInfo.cardEquipDic)
         {
            if(_loc1_.Count <= -1)
            {
               this._equipCells[_loc1_.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[_loc1_.Place].cardInfo = _loc1_;
            }
         }
      }
      
      private function setCellPos() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            PositionUtils.setPos(this._equipCells[_loc1_],"CardCell.Pos" + _loc1_);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            PositionUtils.setPos(this._viceCardBit[_loc2_],"CardCell.viceBorder.Pos" + _loc2_);
            _loc2_++;
         }
         PositionUtils.setPos(this._mainCardBit,"CardCell.mainBorder.Pos");
      }
      
      private function initEvent() : void
      {
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.addEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.__collectHandler);
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__cardHandler);
      }
      
      private function removeEvent() : void
      {
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.ADD,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.UPDATE,this.__upData);
         this.playerInfo.cardEquipDic.removeEventListener(DictionaryEvent.REMOVE,this.__remove);
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.__collectHandler);
      }
      
      private function __collectHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CardControl.Instance.showCollectView();
      }
      
      private function __cardHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._cardBtn.localToGlobal(new Point(0,0));
         this._cardList.x = _loc2_.x + this._cardBtn.width;
         this._cardList.y = 332;
         this._cardList.setVisible = true;
      }
      
      private function _openHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = !!this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.openVice4");
         var _loc3_:String = !!this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.open4");
         this._openFrame = AlertManager.Instance.simpleAlert(_loc2_,_loc3_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._openFrame.addEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
      }
      
      private function __openFramehandler(param1:FrameEvent) : void
      {
         this._openFrame.removeEventListener(FrameEvent.RESPONSE,this.__openFramehandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.openActive();
         }
         this._openFrame.dispose();
         this._openFrame = null;
      }
      
      private function openActive() : void
      {
         var _loc1_:String = null;
         if(this._show3 && CardControl.Instance.model.fourIsOpen() || !this._show3 && (CardControl.Instance.model.fiveIsOpen() || CardControl.Instance.model.fiveIsOpen2()))
         {
            if(this._show3)
            {
               this._equipCells[3].open = true;
               SocketManager.Instance.out.sendOpenViceCard(3);
               this.removeSprite(this._cell3MouseSprite,this._open3Btn);
            }
            else
            {
               this._equipCells[4].open = true;
               SocketManager.Instance.out.sendOpenViceCard(4);
               this.removeSprite(this._cell4MouseSprite,this._open4Btn);
            }
         }
         else
         {
            _loc1_ = !!this._show3 ? LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen3") : LanguageMgr.GetTranslation("ddt.cardSystem.cardEquip.cannotOpen4");
            this._configFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc1_,LanguageMgr.GetTranslation("ok"),"",false,false,true,LayerManager.BLCAK_BLOCKGOUND);
            this._configFrame.addEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         }
      }
      
      private function __configResponseHandler(param1:FrameEvent) : void
      {
         this._configFrame.removeEventListener(FrameEvent.RESPONSE,this.__configResponseHandler);
         this._configFrame.dispose();
         this._configFrame = null;
      }
      
      private function __remove(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(this._equipCells[_loc2_.Place])
         {
            this._equipCells[_loc2_.Place].cardInfo = null;
         }
      }
      
      private function __upData(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(_loc2_ && this._equipCells[_loc2_.Place])
         {
            if(_loc2_.Count <= -1)
            {
               this._equipCells[_loc2_.Place].cardInfo = null;
            }
            else
            {
               this._equipCells[_loc2_.Place].cardInfo = _loc2_;
            }
            this.checkCellIsOpen();
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this._open3Btn);
         TweenLite.killTweensOf(this._open4Btn);
         this.removeEvent();
         this.removeSprite(this._cell3MouseSprite,this._open3Btn);
         this.removeSprite(this._cell4MouseSprite,this._open4Btn);
         this._cell3MouseSprite = null;
         this._cell3MouseSprite = null;
         this._open3Btn = null;
         this._open4Btn = null;
         this._playerInfo = null;
         if(this._dragArea)
         {
            this._dragArea.dispose();
         }
         this._dragArea = null;
         if(this._background)
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._mainCardBit)
         {
            ObjectUtils.disposeObject(this._mainCardBit);
         }
         this._mainCardBit = null;
         if(this._collectBtn)
         {
            ObjectUtils.disposeObject(this._collectBtn);
         }
         this._collectBtn = null;
         if(this._cardBtn)
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            if(this._equipCells[_loc1_])
            {
               this._equipCells[_loc1_].dispose();
               this._equipCells[_loc1_].removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               this._equipCells[_loc1_].removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               this._equipCells[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
               this._equipCells[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
               this._equipCells[_loc1_] = null;
            }
            _loc1_++;
         }
         this._equipCells = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._viceCardBit.length)
         {
            if(this._viceCardBit[_loc2_])
            {
               ObjectUtils.disposeObject(this._viceCardBit[_loc2_]);
            }
            this._viceCardBit[_loc2_] = null;
            _loc2_++;
         }
         this._viceCardBit = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __clickHandler(param1:Event) : void
      {
         var _loc3_:ItemTemplateInfo = null;
         param1.stopImmediatePropagation();
         var _loc2_:CardCell = param1.currentTarget as CardCell;
         if(_loc2_)
         {
            _loc3_ = _loc2_.info as ItemTemplateInfo;
         }
         if(_loc3_ == null)
         {
            return;
         }
         if(!_loc2_.locked)
         {
            SoundManager.instance.play("008");
            _loc2_.dragStart();
         }
      }
      
      protected function __doubleClickHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:CardCell = param1.currentTarget as CardCell;
         if(_loc2_.cardInfo)
         {
            param1.stopImmediatePropagation();
            if(_loc2_ && !_loc2_.locked)
            {
               SocketManager.Instance.out.sendMoveCards(_loc2_.cardInfo.Place,_loc2_.cardInfo.Place);
            }
         }
      }
      
      protected function _cellOverEff(param1:MouseEvent) : void
      {
      }
      
      protected function _cellOutEff(param1:MouseEvent) : void
      {
      }
   }
}
