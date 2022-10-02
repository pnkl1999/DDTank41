package giftSystem.view.giftAndRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import giftSystem.data.RecordInfo;
   import giftSystem.element.RecordItem;
   
   public class RecordParent extends Sprite implements Disposeable
   {
      
      public static const RECEIVED:int = 0;
      
      public static const SENDED:int = 1;
       
      
      private var _playerInfo:PlayerInfo;
      
      private var _canClick:Boolean = false;
      
      private var _noGift:Bitmap;
      
      private var _container:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemArr:Vector.<RecordItem>;
      
      public function RecordParent()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._itemArr = new Vector.<RecordItem>();
         this._container = ComponentFactory.Instance.creatComponentByStylename("RecordParent.container");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("RecordParent.Panel");
         this._panel.setView(this._container);
         addChild(this._panel);
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         if(this._playerInfo == param1)
         {
            return;
         }
         this._playerInfo = param1;
         if(this._playerInfo.ID == PlayerManager.Instance.Self.ID)
         {
            this._canClick = true;
         }
      }
      
      public function setList(param1:RecordInfo, param2:int) : void
      {
         this.clear();
         this._itemArr = new Vector.<RecordItem>();
         switch(param2)
         {
            case RECEIVED:
               this.setReceived(param1);
               break;
            case SENDED:
               this.setSended(param1);
         }
      }
      
      private function setReceived(param1:RecordInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RecordItem = null;
         if(param1)
         {
            _loc2_ = param1.recordList.length;
            if(_loc2_ != 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = new RecordItem();
                  _loc4_.setup(this._playerInfo);
                  _loc4_.setItemInfoType(param1.recordList[_loc3_],RecordParent.RECEIVED);
                  this._container.addChild(_loc4_);
                  this._itemArr.push(_loc4_);
                  _loc3_++;
               }
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function setSended(param1:RecordInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:RecordItem = null;
         if(param1)
         {
            _loc2_ = param1.recordList.length;
            if(_loc2_ == 0)
            {
               this._noGift = ComponentFactory.Instance.creatBitmap("asset.GiftRecord.noGift");
               addChild(this._noGift);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new RecordItem();
               _loc4_.setup(this._playerInfo);
               _loc4_.setItemInfoType(param1.recordList[_loc3_],RecordParent.SENDED);
               this._container.addChild(_loc4_);
               this._itemArr.push(_loc4_);
               _loc3_++;
            }
         }
         this._panel.invalidateViewport();
      }
      
      private function clear() : void
      {
         if(this._noGift)
         {
            ObjectUtils.disposeObject(this._noGift);
         }
         this._noGift = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArr.length)
         {
            if(this._itemArr[_loc1_])
            {
               this._itemArr[_loc1_].dispose();
            }
            this._itemArr[_loc1_] = null;
            _loc1_++;
         }
         this._itemArr = null;
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clear();
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this._panel)
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
