package church.view.churchFire
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChurchFireCell extends BaseCell implements Disposeable
   {
      
      public static const CONTENT_SIZE:int = 48;
       
      
      private var _fireIcon:Bitmap;
      
      private var _fireTemplateID:int;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _fireItemBox:Bitmap;
      
      private var _fireItemBoxAc:Bitmap;
      
      private var _fireIconRectangle:Rectangle;
      
      private var _fireItemGlod:FilterFrameText;
      
      public function ChurchFireCell(param1:DisplayObject, param2:ShopItemInfo, param3:int)
      {
         super(param1,param2.TemplateInfo,true,true);
         this._shopItemInfo = param2;
         this._fireTemplateID = param3;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this.buttonMode = true;
         this._fireIconRectangle = ComponentFactory.Instance.creatCustomObject("asset.church.room.fireIconRectangle");
         this._fireItemBox = ComponentFactory.Instance.creatBitmap("asset.church.room.fireItemBoxAsset");
         addChild(this._fireItemBox);
         this._fireItemGlod = ComponentFactory.Instance.creat("church.room.fireItemGlodAsset");
         this._fireItemGlod.text = String(this._shopItemInfo.getItemPrice(1).goldValue) + "G";
         addChild(this._fireItemGlod);
         this._fireItemBoxAc = ComponentFactory.Instance.creatBitmap("asset.church.room.fireItemBoxAcAsset");
         this._fireItemBoxAc.visible = false;
         addChild(this._fireItemBoxAc);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:Point = null;
         addChildAt(_bg,0);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("church.ChurchFireCell.bgPos");
         _bg.x = _loc1_.x;
         _bg.y = _loc1_.y;
         _contentWidth = _bg.width = CONTENT_SIZE;
         _contentHeight = _bg.height = CONTENT_SIZE;
      }
      
      public function get fireTemplateID() : int
      {
         return this._fireTemplateID;
      }
      
      public function set fireTemplateID(param1:int) : void
      {
         this._fireTemplateID = param1;
         this._shopItemInfo = ShopManager.Instance.getGoldShopItemByTemplateID(this._fireTemplateID);
      }
      
      private function setEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         this._fireItemBoxAc.visible = true;
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         this._fireItemBoxAc.visible = false;
      }
   }
}
