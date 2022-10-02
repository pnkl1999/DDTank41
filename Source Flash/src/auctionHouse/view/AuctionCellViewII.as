package auctionHouse.view
{
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class AuctionCellViewII extends LinkedBagCell
   {
      
      public static const SELECT_BID_GOOD:String = "selectBidGood";
      
      public static const SELECT_GOOD:String = "selectGood";
       
      
      public function AuctionCellViewII()
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.addChild(ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StripGoodsCellBG"));
         super(_loc1_);
         tipDirctions = "7,5,2,6,4,1";
         PicPos = new Point(2,1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _tbxCount = null;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
