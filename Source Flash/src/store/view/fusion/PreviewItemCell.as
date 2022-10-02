package store.view.fusion
{
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PreviewItemCell extends LinkedBagCell
   {
       
      
      public function PreviewItemCell()
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.store.FusionCellBG");
         _loc1_.addChild(_loc2_);
         super(_loc1_);
         if(_cellMouseOverBg)
         {
            ObjectUtils.disposeObject(_cellMouseOverBg);
         }
         _cellMouseOverBg = null;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
      }
   }
}
