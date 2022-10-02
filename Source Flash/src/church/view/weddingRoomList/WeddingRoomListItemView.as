package church.view.weddingRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ChurchRoomInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class WeddingRoomListItemView extends Sprite implements Disposeable
   {
       
      
      private var _selected:Boolean;
      
      private var _churchRoomInfo:ChurchRoomInfo;
      
      private var _weddingRoomListItemAsset:ScaleFrameImage;
      
      private var _weddingRoomListItemNumber:FilterFrameText;
      
      private var _roomListItemLockAsset:Bitmap;
      
      private var _weddingRoomListItemName:FilterFrameText;
      
      private var _weddingRoomListItemCount:FilterFrameText;
      
      public function WeddingRoomListItemView()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         mouseChildren = false;
         this.selected = false;
         buttonMode = true;
         this._weddingRoomListItemAsset = ComponentFactory.Instance.creat("asset.church.main.WeddingRoomListItemAsset");
         this._weddingRoomListItemAsset.setFrame(1);
         addChild(this._weddingRoomListItemAsset);
         this._weddingRoomListItemNumber = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemNumberAsset");
         addChild(this._weddingRoomListItemNumber);
         this._roomListItemLockAsset = ComponentFactory.Instance.creatBitmap("asset.church.roomListItemLockAsset");
         this._roomListItemLockAsset.visible = false;
         addChild(this._roomListItemLockAsset);
         this._weddingRoomListItemName = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemNameAsset");
         addChild(this._weddingRoomListItemName);
         this._weddingRoomListItemCount = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemCountAsset");
         addChild(this._weddingRoomListItemCount);
      }
      
      private function update() : void
      {
         if(this._churchRoomInfo)
         {
            this._weddingRoomListItemNumber.text = this._churchRoomInfo.id.toString();
            this._roomListItemLockAsset.visible = this._churchRoomInfo.isLocked;
            this._weddingRoomListItemName.text = this._churchRoomInfo.roomName;
            this._weddingRoomListItemName.x = !!this._churchRoomInfo.isLocked ? Number(Number(this._roomListItemLockAsset.x + 20)) : Number(Number(this._roomListItemLockAsset.x));
            this._weddingRoomListItemName.width = !!this._churchRoomInfo.isLocked ? Number(Number(186)) : Number(Number(208));
            if(this._churchRoomInfo.status == ChurchRoomInfo.WEDDING_ING && this._churchRoomInfo.currentNum < 2)
            {
               this._weddingRoomListItemCount.text = "2/100";
            }
            else
            {
               this._weddingRoomListItemCount.text = String(this._churchRoomInfo.currentNum) + "/100";
            }
            if(this._churchRoomInfo.currentNum >= 100 || this._churchRoomInfo.status == ChurchRoomInfo.WEDDING_ING)
            {
               this._weddingRoomListItemAsset.setFrame(2);
            }
            else
            {
               this._weddingRoomListItemAsset.setFrame(1);
            }
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
         this.update();
      }
      
      public function get churchRoomInfo() : ChurchRoomInfo
      {
         return this._churchRoomInfo;
      }
      
      public function set churchRoomInfo(param1:ChurchRoomInfo) : void
      {
         this._churchRoomInfo = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         this._churchRoomInfo = null;
         if(this._weddingRoomListItemAsset)
         {
            if(this._weddingRoomListItemAsset.parent)
            {
               this._weddingRoomListItemAsset.parent.removeChild(this._weddingRoomListItemAsset);
            }
            this._weddingRoomListItemAsset.dispose();
         }
         this._weddingRoomListItemAsset = null;
         if(this._weddingRoomListItemNumber)
         {
            if(this._weddingRoomListItemNumber.parent)
            {
               this._weddingRoomListItemNumber.parent.removeChild(this._weddingRoomListItemNumber);
            }
            this._weddingRoomListItemNumber.dispose();
         }
         this._weddingRoomListItemNumber = null;
         if(this._weddingRoomListItemName)
         {
            if(this._weddingRoomListItemName.parent)
            {
               this._weddingRoomListItemName.parent.removeChild(this._weddingRoomListItemName);
            }
            this._weddingRoomListItemName.dispose();
         }
         this._weddingRoomListItemName = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
