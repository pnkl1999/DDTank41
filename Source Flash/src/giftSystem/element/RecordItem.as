package giftSystem.element
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.data.RecordItemInfo;
   import giftSystem.view.giftAndRecord.RecordParent;
   import shop.view.ShopItemCell;
   
   public class RecordItem extends Sprite implements Disposeable
   {
      
      private static var THISHEIGHT:int = 52;
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _info:RecordItemInfo;
      
      private var _headTxt:FilterFrameText;
      
      private var _giftNameTxt:FilterFrameText;
      
      private var _giftCountTxt:FilterFrameText;
      
      private var _playerName:FilterFrameText;
      
      private var _itemCell:ShopItemCell;
      
      private var _clickSp:Sprite;
      
      private var _nameAction:Boolean;
      
      private var _showed:Boolean = false;
      
      public function RecordItem()
      {
         super();
      }
      
      public function setup(param1:PlayerInfo) : void
      {
         this.initView();
         this._playerInfo = param1;
      }
      
      private function initView() : void
      {
         this._headTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.headTxt");
         this._giftNameTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.giftNameTxt");
         this._giftCountTxt = ComponentFactory.Instance.creatComponentByStylename("RecordItem.giftCountTxt");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,50,50);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 46;
         addChild(this._headTxt);
         addChild(this._giftNameTxt);
         addChild(this._giftCountTxt);
         addChild(this._itemCell);
      }
      
      public function setItemInfoType(param1:RecordItemInfo, param2:int) : void
      {
         if(this._info == param1 || param1 == null)
         {
            return;
         }
         this._info = param1;
         var _loc3_:ShopItemInfo = this._info.info;
         if(_loc3_ == null)
         {
            return;
         }
         this._itemCell.info = _loc3_.TemplateInfo;
         switch(param2)
         {
            case RecordParent.RECEIVED:
               this.upReceivedItemView();
               break;
            case RecordParent.SENDED:
               this.upSendedItemView();
         }
      }
      
      private function upReceivedItemView() : void
      {
         this._headTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.receivedHeadTxt");
         this._giftNameTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.receivedGiftName",this._info.info.TemplateInfo.Name);
         this._giftCountTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.giftCount",this._info.count);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("RecordItem.receiverTxt");
         addChild(this._playerName);
         this._playerName.text = this._info.name;
         if(GiftController.Instance.canActive && this._info.playerID != 0 && !GiftController.Instance.inChurch)
         {
            this._clickSp = new Sprite();
            this._clickSp.graphics.beginFill(16711680,0);
            this._clickSp.graphics.drawRect(0,0,this._playerName.textWidth,this._playerName.textHeight);
            this._clickSp.graphics.endFill();
            addChild(this._clickSp);
            this._clickSp.buttonMode = true;
            this._clickSp.y = this._playerName.y;
            this._clickSp.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         this.upPos();
      }
      
      private function upSendedItemView() : void
      {
         this._headTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.sendedHeadTxt");
         this._giftNameTxt.text = this._info.info.TemplateInfo.Name;
         this._giftCountTxt.text = LanguageMgr.GetTranslation("ddt.giftSystem.RecordItem.giftCount",this._info.count);
         this._playerName = ComponentFactory.Instance.creatComponentByStylename("RecordItem.senderTxt");
         addChild(this._playerName);
         this._playerName.text = this._info.name;
         this.upPos();
      }
      
      private function upPos() : void
      {
         this._playerName.x = this._headTxt.x + this._headTxt.textWidth + 4;
         if(this._clickSp)
         {
            this._clickSp.x = this._playerName.x;
         }
         this._giftNameTxt.x = this._playerName.x + this._playerName.textWidth + 4;
         this._itemCell.x = this._giftNameTxt.x + this._giftNameTxt.textWidth;
         this._giftCountTxt.x = this._itemCell.x + this._itemCell.width + 4;
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         RebackMenu.Instance.show(this._info,StageReferance.stage.mouseX,StageReferance.stage.mouseY);
      }
      
      override public function get height() : Number
      {
         return THISHEIGHT;
      }
      
      public function dispose() : void
      {
         if(GiftController.Instance.canActive && this._playerName)
         {
            this._playerName.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         this._info = null;
         if(this._headTxt)
         {
            ObjectUtils.disposeObject(this._headTxt);
         }
         this._headTxt = null;
         if(this._giftNameTxt)
         {
            ObjectUtils.disposeObject(this._giftNameTxt);
         }
         this._giftNameTxt = null;
         if(this._giftCountTxt)
         {
            ObjectUtils.disposeObject(this._giftCountTxt);
         }
         this._giftCountTxt = null;
         if(this._playerName)
         {
            ObjectUtils.disposeObject(this._playerName);
         }
         this._playerName = null;
         if(this._itemCell)
         {
            ObjectUtils.disposeObject(this._itemCell);
         }
         this._itemCell = null;
         if(this._clickSp)
         {
            ObjectUtils.disposeObject(this._clickSp);
         }
         this._clickSp = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
