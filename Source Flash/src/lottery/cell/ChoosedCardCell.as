package lottery.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ChoosedCardCell extends Sprite implements Disposeable
   {
       
      
      private var _bgAsset:Bitmap;
      
      private var _shadingAsset:Bitmap;
      
      private var _cardCell:BigCardCell;
      
      public function ChoosedCardCell()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._shadingAsset = ComponentFactory.Instance.creatBitmap("asset.lotteryCardCell.shadingAsset");
         addChild(this._shadingAsset);
         this._bgAsset = ComponentFactory.Instance.creatBitmap("asset.lotteryCardCell.BGAsset");
         addChild(this._bgAsset);
         this._cardCell = new BigCardCell();
         this._cardCell.tipDirctions = "0,1,2";
         addChild(this._cardCell);
         this._cardCell.visible = false;
      }
      
      public function get cardId() : int
      {
         return this._cardCell.cardId;
      }
      
      public function show(param1:int) : void
      {
         this._cardCell.cardId = param1;
         this._cardCell.visible = mouseEnabled = mouseChildren = true;
      }
      
      public function hide() : void
      {
         this._cardCell.visible = mouseEnabled = mouseChildren = false;
      }
      
      public function get isEmptyCard() : Boolean
      {
         return this._cardCell.visible == false;
      }
      
      public function dispose() : void
      {
         if(this._bgAsset)
         {
            ObjectUtils.disposeObject(this._bgAsset);
         }
         this._bgAsset = null;
         if(this._shadingAsset)
         {
            ObjectUtils.disposeObject(this._shadingAsset);
         }
         this._shadingAsset = null;
         if(this._cardCell)
         {
            ObjectUtils.disposeObject(this._cardCell);
         }
         this._cardCell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
