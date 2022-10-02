package hotSpring.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.HotSpringRoomInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import hotSpring.event.HotSpringRoomListEvent;
   import hotSpring.model.HotSpringRoomListModel;
   
   public class RoomListItemView extends Sprite implements Disposeable
   {
       
      
      private var _roomVO:HotSpringRoomInfo;
      
      private var _selected:Boolean;
      
      private var _model:HotSpringRoomListModel;
      
      private var _itemBG:ScaleFrameImage;
      
      private var _mcLock:Bitmap;
      
      private var _lblRoomNumber:FilterFrameText;
      
      private var _lblRoomName:FilterFrameText;
      
      private var _lblCurCount:FilterFrameText;
      
      private var _percentSinge:FilterFrameText;
      
      private var _lblMaxCount:FilterFrameText;
      
      public function RoomListItemView(param1:HotSpringRoomListModel, param2:HotSpringRoomInfo)
      {
         super();
         this._model = param1;
         this._roomVO = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("asset.HotSpringMainView.roomItemBG");
         addChild(this._itemBG);
         this._mcLock = ComponentFactory.Instance.creatBitmap("asset.HotSpringMainView.roomItem.lockAsset");
         addChild(this._mcLock);
         this.initField();
         this.updateView();
         this.setEvent();
      }
      
      private function initField() : void
      {
         this._lblRoomNumber = ComponentFactory.Instance.creat("asset.HotSpringMainView.lblRoomNumber");
         addChild(this._lblRoomNumber);
         this._lblRoomName = ComponentFactory.Instance.creat("asset.HotSpringMainView.lblRoomName");
         addChild(this._lblRoomName);
         this._lblCurCount = ComponentFactory.Instance.creat("asset.HotSpringMainView.lblCurCount");
         addChild(this._lblCurCount);
         this._percentSinge = ComponentFactory.Instance.creat("asset.HotSpringMainView.percentSinge");
         this._percentSinge.text = "/";
         addChild(this._percentSinge);
         this._lblMaxCount = ComponentFactory.Instance.creat("asset.HotSpringMainView.lblMaxCount");
         addChild(this._lblMaxCount);
      }
      
      private function updateView() : void
      {
         var _loc1_:String = this._roomVO.roomNumber.toString();
         this._lblRoomNumber.text = _loc1_;
         this._lblRoomName.text = this._roomVO.roomName;
         this._lblCurCount.text = this._roomVO.curCount.toString();
         this._lblMaxCount.text = this._roomVO.maxCount.toString();
         this._mcLock.visible = this._roomVO.roomIsPassword;
         this._itemBG.setFrame(this._roomVO.roomType);
         if(this._roomVO.curCount >= this._roomVO.maxCount)
         {
            this._itemBG.setFrame(4);
         }
      }
      
      private function setEvent() : void
      {
         this._model.addEventListener(HotSpringRoomListEvent.ROOM_UPDATE,this.roomUpdate);
      }
      
      private function roomUpdate(param1:HotSpringRoomListEvent) : void
      {
         var _loc2_:HotSpringRoomInfo = param1.data as HotSpringRoomInfo;
         if(this._roomVO.roomID == _loc2_.roomID)
         {
            this._roomVO = _loc2_;
            this.updateView();
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
      }
      
      public function get roomVO() : HotSpringRoomInfo
      {
         return this._roomVO;
      }
      
      public function dispose() : void
      {
         this._model.removeEventListener(HotSpringRoomListEvent.ROOM_UPDATE,this.roomUpdate);
         this._model = null;
         this._roomVO = null;
         if(this._itemBG)
         {
            ObjectUtils.disposeObject(this._itemBG);
            this._itemBG = null;
         }
         ObjectUtils.disposeObject(this._mcLock);
         this._mcLock = null;
         if(this._lblRoomNumber)
         {
            ObjectUtils.disposeObject(this._lblRoomNumber);
            this._lblRoomNumber = null;
         }
         if(this._lblRoomName)
         {
            ObjectUtils.disposeObject(this._lblRoomName);
            this._lblRoomName = null;
         }
         if(this._lblCurCount)
         {
            ObjectUtils.disposeObject(this._lblCurCount);
            this._lblCurCount = null;
         }
         if(this._percentSinge)
         {
            ObjectUtils.disposeObject(this._percentSinge);
            this._percentSinge = null;
         }
         if(this._lblMaxCount)
         {
            ObjectUtils.disposeObject(this._lblMaxCount);
            this._lblMaxCount = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
